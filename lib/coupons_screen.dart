import 'package:flutter/material.dart';
import 'main.dart';

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});
  // hello testing
  static const List<Map<String, dynamic>> couponList = [
    {
      'code': 'GOLD50',
      'discountPercent': 50,
      'description': '50% OFF on order above ₹199',
      'details': 'Maximum discount up to ₹150. Applicable on all restaurants.',
      'emoji': '🎟️',
      'minAmount': 199.0,
      'maxDiscount': 150.0,
    },
    {
      'code': 'SORAFREE',
      'discountPercent': 100,
      'description': '100% Free Delivery & Packing',
      'details': 'Zero delivery fees on orders above ₹149.',
      'emoji': '🚚',
      'minAmount': 149.0,
      'maxDiscount': 80.0,
    },
    {
      'code': 'PIZZA20',
      'discountPercent': 20,
      'description': '20% OFF on Italian cravings',
      'details': 'Maximum discount up to ₹100. Applicable on Italian dishes.',
      'emoji': '🍕',
      'minAmount': 100.0,
      'maxDiscount': 100.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          'Apply Coupon',
          style: TextStyle(
            color: isDark ? Colors.white : kInk,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: couponList.length,
        itemBuilder: (context, index) {
          final coupon = couponList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? Colors.white12 : kChipBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: kOrange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          coupon['emoji'],
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: kOrange,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                coupon['code'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              coupon['description'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : kInk,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Return selected coupon
                          Navigator.pop(context, coupon);
                        },
                        style: TextButton.styleFrom(foregroundColor: kOrange),
                        child: const Text(
                          'APPLY',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: kChipBorder),
                  Text(
                    coupon['details'],
                    style: const TextStyle(color: kGrey, fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
