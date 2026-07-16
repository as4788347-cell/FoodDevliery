import 'package:flutter/material.dart';
import 'main.dart';
import 'cart_screen.dart';

class MenuScreen extends StatefulWidget {
  final Restaurant restaurant;
  const MenuScreen({super.key, required this.restaurant});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _isVegOnly = false;

  final List<Map<String, dynamic>> _mockDishes = [
    {
      'name': 'Special Paneer Tikka Pizza',
      'price': 249.0,
      'isVeg': true,
      'rating': 4.6,
      'description': 'Delicious thin crust pizza topped with spicy paneer tikka cubes, onions, capsicum, and premium mozzarella cheese.',
      'imageUrl': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=300',
      'colorFallback': Color(0xFFE8A13D),
      'emojiFallback': '🍕',
    },
    {
      'name': 'Garlic Breadsticks',
      'price': 119.0,
      'isVeg': true,
      'rating': 4.3,
      'description': 'Freshly baked breadsticks infused with garlic butter and herbs, served with spicy cheesy dip.',
      'imageUrl': 'https://images.unsplash.com/photo-1544982503-9f984c14501a?w=300',
      'colorFallback': Color(0xFFC79A3B),
      'emojiFallback': '🥖',
    },
    {
      'name': 'Chicken Peri Peri Wings',
      'price': 199.0,
      'isVeg': false,
      'rating': 4.5,
      'description': 'Spicy grilled chicken wings marinated in peri peri hot pepper sauce.',
      'imageUrl': 'https://images.unsplash.com/photo-1567620832903-9fc6debc209f?w=300',
      'colorFallback': Color(0xFFE05B5B),
      'emojiFallback': '🍗',
    },
    {
      'name': 'Choco Lava Cake',
      'price': 99.0,
      'isVeg': true,
      'rating': 4.8,
      'description': 'Warm chocolate cake with a rich oozing molten chocolate core.',
      'imageUrl': 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=300',
      'colorFallback': Color(0xFF9C2B2B),
      'emojiFallback': '🧁',
    },
    {
      'name': 'Steamed Veg Dumplings',
      'price': 130.0,
      'isVeg': true,
      'rating': 4.4,
      'description': 'Healthy steamed dumplings stuffed with finely minced vegetables and oriental spices, served with chili dip.',
      'imageUrl': 'https://images.unsplash.com/photo-1534422298391-e4f8c172dddb?w=300',
      'colorFallback': Color(0xFF3E5641),
      'emojiFallback': '🥟',
    },
  ];

  List<Map<String, dynamic>> _getFilteredDishes() {
    if (_isVegOnly) {
      return _mockDishes.where((dish) => dish['isVeg'] == true).toList();
    }
    return _mockDishes;
  }

  void _addItemToCart(Map<String, dynamic> dish) {
    final currentCart = Map<String, List<Map<String, dynamic>>>.from(SoraAppState.cartNotifier.value);
    final restName = widget.restaurant.name;

    if (!currentCart.containsKey(restName)) {
      currentCart[restName] = [];
    }

    final list = List<Map<String, dynamic>>.from(currentCart[restName]!);
    final index = list.indexWhere((item) => item['name'] == dish['name']);

    if (index >= 0) {
      list[index]['quantity'] = (list[index]['quantity'] as int) + 1;
    } else {
      list.add({
        'name': dish['name'],
        'price': dish['price'],
        'quantity': 1,
        'imageUrl': dish['imageUrl'],
        'isVeg': dish['isVeg'],
      });
    }

    currentCart[restName] = list;
    SoraAppState.cartNotifier.value = currentCart;
  }

  void _removeItemFromCart(Map<String, dynamic> dish) {
    final currentCart = Map<String, List<Map<String, dynamic>>>.from(SoraAppState.cartNotifier.value);
    final restName = widget.restaurant.name;

    if (!currentCart.containsKey(restName)) return;

    final list = List<Map<String, dynamic>>.from(currentCart[restName]!);
    final index = list.indexWhere((item) => item['name'] == dish['name']);

    if (index >= 0) {
      final currentQty = list[index]['quantity'] as int;
      if (currentQty > 1) {
        list[index]['quantity'] = currentQty - 1;
      } else {
        list.removeAt(index);
      }
    }

    currentCart[restName] = list;
    SoraAppState.cartNotifier.value = currentCart;
  }

  int _getItemQuantity(String dishName) {
    final currentCart = SoraAppState.cartNotifier.value;
    final restName = widget.restaurant.name;

    if (!currentCart.containsKey(restName)) return 0;

    final list = currentCart[restName]!;
    final index = list.indexWhere((item) => item['name'] == dishName);
    if (index >= 0) {
      return list[index]['quantity'] as int;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dishes = _getFilteredDishes();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Sleek Restaurant Hero Header
              SliverAppBar(
                expandedHeight: 220.0,
                pinned: true,
                backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: kOrange, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.restaurant.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: widget.restaurant.colorFallback,
                            alignment: Alignment.center,
                            child: Text(
                              widget.restaurant.emojiFallback,
                              style: const TextStyle(fontSize: 64),
                            ),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.black.withOpacity(0.1),
                              Colors.black.withOpacity(0.6),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.restaurant.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.restaurant.cuisine,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Info Card & Filters Switch
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: kGreen,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star, size: 12, color: Colors.white),
                                    const SizedBox(width: 3),
                                    Text(
                                      widget.restaurant.rating.toStringAsFixed(1),
                                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.restaurant.time,
                                style: const TextStyle(color: kGrey, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFF2EC),
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Text(
                              widget.restaurant.discount,
                              style: const TextStyle(color: kOrange, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24, color: kChipBorder),
                      
                      // Veg mode toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.eco, color: kGreen, size: 18),
                              SizedBox(width: 6),
                              Text(
                                'Veg Only',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ],
                          ),
                          Switch(
                            value: _isVegOnly,
                            activeColor: Colors.white,
                            activeTrackColor: kGreen,
                            onChanged: (val) {
                              setState(() {
                                _isVegOnly = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Dishes List
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final dish = dishes[index];
                    return ValueListenableBuilder<Map<String, List<Map<String, dynamic>>>>(
                      valueListenable: SoraAppState.cartNotifier,
                      builder: (context, cart, child) {
                        final qty = _getItemQuantity(dish['name']);
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: Sora3D.cardDecoration(isDark: isDark, radius: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: dish['isVeg'] ? kGreen : Colors.red,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 6),
                                        if (dish['rating'] >= 4.5)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: kGold.withOpacity(0.12),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              '★ Bestseller',
                                              style: TextStyle(color: kGold, fontSize: 9, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      dish['name'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : kInk,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${dish['price'].toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: kOrange,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      dish['description'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: kGrey,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              
                              // Image and Add button Stack
                              Stack(
                                alignment: Alignment.bottomCenter,
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      dish['imageUrl'],
                                      width: 96,
                                      height: 96,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 96,
                                          height: 96,
                                          color: dish['colorFallback'],
                                          alignment: Alignment.center,
                                          child: Text(
                                            dish['emojiFallback'],
                                            style: const TextStyle(fontSize: 32),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    bottom: -12,
                                    child: Container(
                                      width: 80,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: kOrange, width: 1.2),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.06),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: qty == 0
                                          ? InkWell(
                                              onTap: () => _addItemToCart(dish),
                                              borderRadius: BorderRadius.circular(16),
                                              child: const Center(
                                                child: Text(
                                                  'ADD',
                                                  style: TextStyle(
                                                    color: kOrange,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                GestureDetector(
                                                  onTap: () => _removeItemFromCart(dish),
                                                  child: const Icon(Icons.remove, size: 16, color: kOrange),
                                                ),
                                                Text(
                                                  qty.toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: kOrange,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () => _addItemToCart(dish),
                                                  child: const Icon(Icons.add, size: 16, color: kOrange),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  childCount: dishes.length,
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 120),
              ),
            ],
          ),

          // 4. Floating Cart Bar Overlay
          ValueListenableBuilder<Map<String, List<Map<String, dynamic>>>>(
            valueListenable: SoraAppState.cartNotifier,
            builder: (context, cart, child) {
              final restName = widget.restaurant.name;
              if (!cart.containsKey(restName) || cart[restName]!.isEmpty) {
                return const SizedBox();
              }

              final list = cart[restName]!;
              final totalQty = list.fold<int>(0, (sum, item) => sum + (item['quantity'] as int));
              final totalPrice = list.fold<double>(0, (sum, item) => sum + ((item['price'] as double) * (item['quantity'] as int)));

              return Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: kOrange,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: kOrange.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$totalQty Items | ₹${totalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const Text(
                            'Extra charges may apply',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartScreen(restaurant: widget.restaurant),
                            ),
                          );
                        },
                        child: Row(
                          children: const [
                            Text(
                              'View Cart',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Icon(Icons.chevron_right, color: Colors.white, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
