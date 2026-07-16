import 'package:flutter/material.dart';
import 'main.dart';
import 'coupons_screen.dart';
import 'delivery_screen.dart';

class CartScreen extends StatefulWidget {
  final Restaurant restaurant;
  const CartScreen({super.key, required this.restaurant});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<String, dynamic>? _appliedCoupon;

  void _addItem(Map<String, dynamic> item) {
    final currentCart = Map<String, List<Map<String, dynamic>>>.from(SoraAppState.cartNotifier.value);
    final restName = widget.restaurant.name;

    final list = List<Map<String, dynamic>>.from(currentCart[restName]!);
    final index = list.indexWhere((i) => i['name'] == item['name']);
    if (index >= 0) {
      list[index]['quantity'] = (list[index]['quantity'] as int) + 1;
    }

    currentCart[restName] = list;
    SoraAppState.cartNotifier.value = currentCart;
  }

  void _removeItem(Map<String, dynamic> item) {
    final currentCart = Map<String, List<Map<String, dynamic>>>.from(SoraAppState.cartNotifier.value);
    final restName = widget.restaurant.name;

    final list = List<Map<String, dynamic>>.from(currentCart[restName]!);
    final index = list.indexWhere((i) => i['name'] == item['name']);
    if (index >= 0) {
      final qty = list[index]['quantity'] as int;
      if (qty > 1) {
        list[index]['quantity'] = qty - 1;
      } else {
        list.removeAt(index);
      }
    }

    currentCart[restName] = list;
    SoraAppState.cartNotifier.value = currentCart;
  }

  void _selectCoupon() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CouponsScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _appliedCoupon = result;
      });
    }
  }

  void _placeOrder(double grandTotal, List<Map<String, dynamic>> cartItems) {
    final walletBal = SoraAppState.walletBalanceNotifier.value;
    if (walletBal < grandTotal) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Insufficient Funds', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
            'Your Sora Wallet has ₹${walletBal.toStringAsFixed(2)}, but the order total is ₹${grandTotal.toStringAsFixed(2)}. Please add money to your wallet to continue.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK', style: TextStyle(color: kOrange)),
            ),
          ],
        ),
      );
      return;
    }

    // Process payment
    SoraAppState.walletBalanceNotifier.value = walletBal - grandTotal;

    // Save order in history
    final orderId = 'ODR-${(10000 + (90000 * (1.0 - 0.5))).toInt()}';
    final newOrder = {
      'id': orderId,
      'restaurant': widget.restaurant.name,
      'items': cartItems.map((item) => {
        'name': item['name'],
        'price': item['price'],
        'quantity': item['quantity'],
      }).toList(),
      'total': grandTotal,
      'time': 'Just Now',
      'status': 'Out for Delivery',
    };

    final currentOrders = List<Map<String, dynamic>>.from(SoraAppState.ordersNotifier.value);
    currentOrders.insert(0, newOrder);
    SoraAppState.ordersNotifier.value = currentOrders;

    // Clear cart for this restaurant
    final currentCart = Map<String, List<Map<String, dynamic>>>.from(SoraAppState.cartNotifier.value);
    currentCart.remove(widget.restaurant.name);
    SoraAppState.cartNotifier.value = currentCart;

    // Open Live Delivery screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DeliveryScreen()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order placed successfully! Wallet balance: ₹${SoraAppState.walletBalanceNotifier.value.toStringAsFixed(0)}'),
        backgroundColor: kGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final restName = widget.restaurant.name;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kOrange),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Cart',
          style: TextStyle(
            color: isDark ? Colors.white : kInk,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Map<String, List<Map<String, dynamic>>>>(
        valueListenable: SoraAppState.cartNotifier,
        builder: (context, cart, child) {
          if (!cart.containsKey(restName) || cart[restName]!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🛒', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : kInk,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Add items from the menu to build your feast.', style: TextStyle(color: kGrey)),
                ],
              ),
            );
          }

          final items = cart[restName]!;
          
          // Bill calculations
          final subtotal = items.fold<double>(0, (sum, i) => sum + ((i['price'] as double) * (i['quantity'] as int)));
          final gst = subtotal * 0.05; // 5% GST
          
          double deliveryFee = 30.0;
          double couponDiscount = 0.0;

          if (_appliedCoupon != null) {
            final discountPercent = _appliedCoupon!['discountPercent'] as int;
            final maxDiscount = _appliedCoupon!['maxDiscount'] as double;
            final minAmount = _appliedCoupon!['minAmount'] as double;

            if (subtotal >= minAmount) {
              if (_appliedCoupon!['code'] == 'SORAFREE') {
                deliveryFee = 0.0;
                couponDiscount = 0.0;
              } else {
                couponDiscount = (subtotal * (discountPercent / 100));
                if (couponDiscount > maxDiscount) {
                  couponDiscount = maxDiscount;
                }
              }
            }
          }

          final grandTotal = subtotal + gst + deliveryFee - couponDiscount;

          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              // 1. Restaurant Header Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: Sora3D.cardDecoration(isDark: isDark, radius: 20),
                child: Row(
                  children: [
                    const Icon(Icons.storefront, color: kOrange, size: 24),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.restaurant.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : kInk,
                          ),
                        ),
                        Text(
                          widget.restaurant.cuisine,
                          style: const TextStyle(color: kGrey, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. Items List
              const Text('ITEMS ADDED', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kGrey, letterSpacing: 0.5)),
              const SizedBox(height: 10),
              Container(
                decoration: Sora3D.cardDecoration(isDark: isDark, radius: 20),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(color: kChipBorder, height: 1),
                  itemBuilder: (context, idx) {
                    final item = items[idx];
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.circle, color: item['isVeg'] ? kGreen : Colors.red, size: 12),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : kInk,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          
                          // Quantity Controls
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: kOrange),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _removeItem(item),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Icon(Icons.remove, size: 14, color: kOrange),
                                  ),
                                ),
                                Text(
                                  item['quantity'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kOrange,
                                    fontSize: 12,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _addItem(item),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Icon(Icons.add, size: 14, color: kOrange),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '₹${((item['price'] as double) * (item['quantity'] as int)).toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : kInk,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // 3. Coupon promo card
              const Text('PROMOTIONS & OFFERS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kGrey, letterSpacing: 0.5)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _selectCoupon,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: Sora3D.cardDecoration(isDark: isDark, radius: 16).copyWith(
                    border: _appliedCoupon != null ? Border.all(color: kOrange, width: 1.5) : null,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_offer_outlined, color: kOrange, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _appliedCoupon == null
                            ? Text(
                                'Apply Coupon Code',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : kInk,
                                  fontSize: 14.5,
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Coupon Applied: ${_appliedCoupon!['code']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kOrange,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    _appliedCoupon!['description'],
                                    style: const TextStyle(color: kGrey, fontSize: 11),
                                  ),
                                ],
                              ),
                      ),
                      const Icon(Icons.chevron_right, color: kGrey, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 4. Detailed Bill Calculator
              const Text('BILL DETAILS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kGrey, letterSpacing: 0.5)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: Sora3D.cardDecoration(isDark: isDark, radius: 20),
                child: Column(
                  children: [
                    _buildBillRow('Item Subtotal', subtotal, isDark),
                    const SizedBox(height: 8),
                    _buildBillRow('GST & Restaurant Charges (5%)', gst, isDark),
                    const SizedBox(height: 8),
                    _buildBillRow('Delivery Partner Fee', deliveryFee, isDark),
                    if (couponDiscount > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Promo Discount', style: TextStyle(color: kGreen, fontSize: 13, fontWeight: FontWeight.w500)),
                          Text('-₹${couponDiscount.toStringAsFixed(2)}', style: const TextStyle(color: kGreen, fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                    const Divider(height: 24, color: kChipBorder),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Grand Total',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: isDark ? Colors.white : kInk,
                          ),
                        ),
                        Text(
                          '₹${grandTotal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,                            fontSize: 16,
                            color: isDark ? Colors.white : kInk,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 5. Payment details card (Pay with Sora Wallet)
              const Text('PAYMENT MODE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kGrey, letterSpacing: 0.5)),
              const SizedBox(height: 10),
              ValueListenableBuilder<double>(
                valueListenable: SoraAppState.walletBalanceNotifier,
                builder: (context, balance, child) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: Sora3D.cardDecoration(isDark: isDark, radius: 20),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet_outlined, color: kGreen, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sora Wallet Pay',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : kInk,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Available Balance: ₹${balance.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: balance >= grandTotal ? kGreen : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (balance < grandTotal)
                          const Icon(Icons.warning, color: Colors.red, size: 20)
                        else
                          const Icon(Icons.check_circle, color: kGreen, size: 20),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // 6. Action button to pay
              Sora3D.pushButton(
                onTap: () => _placeOrder(grandTotal, items),
                child: const Text('Place Order & Pay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBillRow(String label, double amount, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: kGrey, fontSize: 13),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: isDark ? Colors.white70 : kInk,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
