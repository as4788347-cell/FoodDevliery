import 'package:flutter/material.dart';



void main() => runApp(const SoraFoodApp());

// Brand colors
const kOrange = Color(0xFFF4520B);
const kGold = Color(0xFFC79A3B);
const kGreen = Color(0xFF1E8F4E);
const kLightGreen = Color(0xFFDFF2E4);
const kInk = Color(0xFF1C1C1C);
const kGrey = Color(0xFF6E6E6E);
const kChipBorder = Color(0xFFE6E6E6);

class SoraFoodApp extends StatelessWidget {
  const SoraFoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: kOrange),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

// ─────────────────────────── HOME ───────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _vegMode = false;
  int _selectedCategory = 0;
  int _bannerPage = 0;
  int _navIndex = 0;

  final _categories = const [
    ('🍔', 'All'),
    ('🍕', 'Pizza'),
    ('🍛', 'Thali'),
    ('🍚', 'Biryani'),
    ('🍰', 'Cake'),
    ('🌯', 'Rolls'),
  ];

  final _restaurants = const [
    Restaurant(
      name: 'Kebabs & Curries',
      cuisine: 'North Indian, Mughlai',
      rating: 4.2,
      time: '25-30 mins',
      offerTag: '₹40 OFF above ₹349',
      discount: '20% OFF up to ₹120',
      emoji: '🍲',
      color: Color(0xFFE8A13D),
    ),
    Restaurant(
      name: 'Handi Restaurant',
      cuisine: 'North Indian, Thali',
      rating: 4.1,
      time: '20-25 mins',
      offerTag: '₹40 OFF above ₹299',
      discount: '20% OFF up to ₹100',
      emoji: '🍛',
      color: Color(0xFF8A5A44),
    ),
    Restaurant(
      name: 'Doodh Misthan',
      cuisine: 'Sweets, Desserts',
      rating: 4.3,
      time: '25-30 mins',
      offerTag: '₹40 OFF above ₹299',
      discount: '10% OFF up to ₹80',
      emoji: '🍮',
      color: Color(0xFF9C2B2B),
    ),
    Restaurant(
      name: 'Rasoi Thali House',
      cuisine: 'Thali, North Indian',
      rating: 4.4,
      time: '25-30 mins',
      offerTag: '₹40 OFF above ₹349',
      discount: '15% OFF up to ₹90',
      emoji: '🥘',
      color: Color(0xFF3E5641),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            const SizedBox(height: 8),
            _header(),
            const SizedBox(height: 16),
            _searchRow(),
            const SizedBox(height: 16),
            _flashSaleBanner(),
            const SizedBox(height: 20),
            _categoryRow(),
            const SizedBox(height: 16),
            _filterChips(),
            const SizedBox(height: 24),
            _recommendedHeader(),
            const SizedBox(height: 12),
            _restaurantList(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomArea(),
    );
  }

  // ── Header: location · logo · gold pill · wallet · avatar ──

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.location_on, size: 20, color: kInk),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'Todarmal Marg',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: kInk,
                        ),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, size: 20, color: kInk),
                  ],
                ),
                const Text(
                  'Banipark, Kanti Nagar, Bani...',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: kGrey),
                ),
              ],
            ),
          ),
          // Logo
          Column(
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: kInk,
                    letterSpacing: 1,
                  ),
                  children: [
                    TextSpan(text: 'S'),
                    TextSpan(text: 'O', style: TextStyle(color: kOrange)),
                    TextSpan(text: 'RA'),
                  ],
                ),
              ),
              const Text(
                '— FOOD DELIVERY —',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: kOrange,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          // Gold pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFBEEDC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: const [
                Icon(Icons.workspace_premium, size: 14, color: kGold),
                Text(
                  'SORA GOLD',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: kInk,
                  ),
                ),
                Text('₹1',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Wallet
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kChipBorder),
            ),
            child: const Icon(Icons.account_balance_wallet_outlined, size: 20),
          ),
          const SizedBox(width: 8),
          // Avatar
          const CircleAvatar(
            radius: 19,
            backgroundColor: kOrange,
            child: Text(
              'A',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Search bar + Veg mode toggle ──

  Widget _searchRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: kChipBorder),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, color: kInk),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Search "pizza"',
                      style: TextStyle(color: kGrey, fontSize: 15),
                    ),
                  ),
                  Icon(Icons.mic_none, color: kInk),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Row(
                children: const [
                  Icon(Icons.eco, size: 14, color: kGreen),
                  SizedBox(width: 2),
                  Text('Veg\nMode',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          height: 1.1)),
                ],
              ),
              SizedBox(
                height: 26,
                child: Switch(
                  value: _vegMode,
                  activeColor: Colors.white,
                  activeTrackColor: kGreen,
                  onChanged: (v) => setState(() => _vegMode = v),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Flash sale banner carousel ──

  Widget _flashSaleBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: 350,
          child: Stack(
            children: [
              PageView.builder(
                itemCount: 3,
                onPageChanged: (i) => setState(() => _bannerPage = i),
                itemBuilder: (_, i) => _bannerCard(),
              ),
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final active = i == _bannerPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active ? kOrange : Colors.grey.shade400,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bannerCard() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF6E3CC),
            Color(0xFFFAD9BC),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            right: 20,
            top: 20,
            child: Icon(
              Icons.location_on,
              size: 150,
              color: kOrange,
            ),
          ),

          const Positioned(
            right: 20,
            bottom: 40,
            child: Text(
              '🍔🍕🍰',
              style: TextStyle(fontSize: 52),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                    children: [
                      TextSpan(
                        text: 'SORA ',
                        style: TextStyle(color: kInk),
                      ),
                      TextSpan(
                        text: 'GOLD',
                        style: TextStyle(color: kGold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'FLASH',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const Text(
                  'SALE',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: kOrange,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  '₹1 for 3 months',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),

                SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kInk,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Join Gold now'),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // ── Category row ──

  Widget _categoryRow() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 22),
        itemBuilder: (context, i) {
          if (i == _categories.length) {
            return _categoryItem(
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kChipBorder),
                ),
                child: const Icon(Icons.grid_view_rounded, color: kInk),
              ),
              label: 'More',
              selected: false,
              onTap: () {},
            );
          }
          final (emoji, label) = _categories[i];
          return _categoryItem(
            child: Text(emoji, style: const TextStyle(fontSize: 42)),
            label: label,
            selected: _selectedCategory == i,
            onTap: () => setState(() => _selectedCategory = i),
          );
        },
      ),
    );
  }

  Widget _categoryItem({
    required Widget child,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(height: 58, child: Center(child: child)),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: kInk,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 3,
            width: selected ? 36 : 0,
            decoration: BoxDecoration(
              color: kOrange,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  // ── Filter chips ──

  Widget _filterChips() {
    Widget chip(Widget child) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: kChipBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          chip(Row(children: const [
            Icon(Icons.tune, size: 18),
            SizedBox(width: 6),
            Text('Filters', style: TextStyle(fontWeight: FontWeight.w600)),
            Icon(Icons.arrow_drop_down, size: 20),
          ])),
          const SizedBox(width: 10),
          chip(Row(children: const [
            Icon(Icons.bolt, size: 18, color: kGreen),
            SizedBox(width: 6),
            Text('Near & Fast',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ])),
          const SizedBox(width: 10),
          chip(Row(children: const [
            Icon(Icons.eco, size: 18, color: kGreen),
            SizedBox(width: 6),
            Text('No packaging charges',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ])),
          const SizedBox(width: 10),
          chip(Row(children: const [
            Icon(Icons.star, size: 18, color: kInk),
            SizedBox(width: 6),
            Text('Top rated', style: TextStyle(fontWeight: FontWeight.w600)),
          ])),
        ],
      ),
    );
  }

  // ── Recommended section ──

  Widget _recommendedHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'RECOMMENDED FOR YOU',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
              color: kInk,
            ),
          ),
          Text(
            'See all',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: kOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _restaurantList() {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _restaurants.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, i) => RestaurantCard(restaurant: _restaurants[i]),
      ),
    );
  }

  // ── Bottom: quick actions + Order Now + nav bar ──

  Widget _bottomArea() {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 68,
                    decoration: BoxDecoration(
                      border: Border.all(color: kChipBorder),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        _quickAction(
                          const Icon(Icons.delivery_dining,
                              color: kOrange, size: 24),
                          'Delivery',
                          'Now',
                          highlight: true,
                        ),
                        _divider(),
                        _quickAction(
                          const Icon(Icons.local_offer_outlined, size: 22),
                          'Under ₹250',
                          '',
                        ),
                        _divider(),
                        _quickAction(
                          const Icon(Icons.restaurant, size: 22),
                          'Dining',
                          'Book a Table',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Order Now button
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 68,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: kOrange,
                      borderRadius: BorderRadius.circular(34),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shopping_bag,
                            color: Colors.white, size: 22),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  'Order Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                                Icon(Icons.chevron_right,
                                    color: Colors.white, size: 18),
                              ],
                            ),
                            const Text(
                              'Food on your way!',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomNavigationBar(
            currentIndex: _navIndex,
            onTap: (i) => setState(() => _navIndex = i),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: kOrange,
            unselectedItemColor: kInk,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_outlined), label: 'Orders'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border), label: 'Favourites'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAction(Icon icon, String title, String subtitle,
      {bool highlight = false}) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: highlight ? kOrange : kInk,
            ),
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: highlight ? kOrange : kGrey,
              ),
            ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 36, color: kChipBorder);
}

// ─────────────────────── Restaurant card ────────────────────

class Restaurant {
  final String name;
  final String cuisine;
  final double rating;
  final String time;
  final String offerTag;
  final String discount;
  final String emoji; // placeholder — swap for image asset/url
  final Color color;

  const Restaurant({
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.time,
    required this.offerTag,
    required this.discount,
    required this.emoji,
    required this.color,
  });
}

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + overlays
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                // Replace this Container with Image.asset / CachedNetworkImage
                Container(
                  height: 150,
                  width: double.infinity,
                  color: restaurant.color,
                  child: Center(
                    child: Text(restaurant.emoji,
                        style: const TextStyle(fontSize: 56)),
                  ),
                ),
                // Offer tag (top-left)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      restaurant.offerTag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Rating badge (bottom-left)
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star,
                            size: 12, color: Colors.white),
                        const SizedBox(width: 3),
                        Text(
                          restaurant.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            restaurant.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: kInk,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            restaurant.cuisine,
            style: const TextStyle(fontSize: 13, color: kGrey),
          ),
          const SizedBox(height: 6),
          Row(
            children: const [
              Icon(Icons.bolt, size: 15, color: kGreen),
              SizedBox(width: 3),
              Text(
                'Near & Fast',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: kGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            restaurant.time,
            style: const TextStyle(fontSize: 12, color: kGrey),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: kLightGreen,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                restaurant.discount,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: kGreen,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}