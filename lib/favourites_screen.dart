import 'package:flutter/material.dart';

void main() => runApp(const SoraFoodApp());

// Brand colors matching the image
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
      title: 'Sora Food Delivery',
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

// ─────────────────────────── RESTAURANT MODEL ───────────────────────────

class Restaurant {
  final String name;
  final String cuisine;
  final double rating;
  final String time;
  final String offerTag;
  final String discount;
  final String imageUrl;
  final String emojiFallback;
  final Color colorFallback;

  const Restaurant({
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.time,
    required this.offerTag,
    required this.discount,
    required this.imageUrl,
    required this.emojiFallback,
    required this.colorFallback,
  });
}

// Global list of restaurants
const List<Restaurant> kRestaurants = [
  Restaurant(
    name: 'Kebabs & Curries',
    cuisine: 'North Indian, Mughlai',
    rating: 4.2,
    time: '25-30 mins',
    offerTag: '₹40 OFF above ₹349',
    discount: '20% OFF up to ₹120',
    imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=500',
    emojiFallback: '🍲',
    colorFallback: Color(0xFFE8A13D),
  ),
  Restaurant(
    name: 'Handi Restaurant',
    cuisine: 'North Indian, Thali',
    rating: 4.1,
    time: '20-25 mins',
    offerTag: '₹40 OFF above ₹299',
    discount: '20% OFF up to ₹100',
    imageUrl: 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=500',
    emojiFallback: '🍛',
    colorFallback: Color(0xFF8A5A44),
  ),
  Restaurant(
    name: 'Doodh Misthan',
    cuisine: 'Sweets, Desserts',
    rating: 4.3,
    time: '25-30 mins',
    offerTag: '₹40 OFF above ₹299',
    discount: '10% OFF up to ₹80',
    imageUrl: 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=500',
    emojiFallback: '🍮',
    colorFallback: Color(0xFF9C2B2B),
  ),
  Restaurant(
    name: 'Rasoi Thali House',
    cuisine: 'Thali, North Indian, Pizza',
    rating: 4.4,
    time: '25-30 mins',
    offerTag: '₹40 OFF above ₹349',
    discount: '15% OFF up to ₹90',
    imageUrl: 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=500',
    emojiFallback: '🥘',
    colorFallback: Color(0xFF3E5641),
  ),
];

// ─────────────────────────── HOME SCREEN ───────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _vegMode = false;
  int _selectedCategory = 0;
  int _bannerPage = 0;

  final List<(String, String, String)> _categories = const [
    ('🍔', 'All', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=150'),
    ('🍕', 'Pizza', 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=150'),
    ('🍛', 'Thali', 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=150'),
    ('🍚', 'Biryani', 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=150'),
    ('🍰', 'Cake', 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=150'),
    ('🌯', 'Rolls', 'https://images.unsplash.com/photo-1626700051175-6518c4793f4f?w=150'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.only(bottom: 120),
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
            _floatingActionDeck(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
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
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: kInk),
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
          Column(
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: kInk, letterSpacing: 1),
                  children: [
                    TextSpan(text: 'S'),
                    TextSpan(text: 'O', style: TextStyle(color: kOrange)),
                    TextSpan(text: 'RA'),
                  ],
                ),
              ),
              const Text(
                '— FOOD DELIVERY —',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: kOrange, letterSpacing: 1.2),
              ),
            ],
          ),
          const SizedBox(width: 10),
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
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: kInk),
                ),
                Text('₹1', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(width: 8),
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
          const CircleAvatar(
            radius: 19,
            backgroundColor: kOrange,
            child: Text(
              'A',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
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
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Row(
                children: const [
                  Icon(Icons.eco, size: 14, color: kGreen),
                  SizedBox(width: 2),
                  Text('Veg\nMode', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, height: 1.1)),
                ],
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 24,
                width: 38,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Switch(
                    value: _vegMode,
                    activeColor: Colors.white,
                    activeTrackColor: kGreen,
                    onChanged: (v) => setState(() => _vegMode = v),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _flashSaleBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: 190,
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
          colors: [Color(0xFFFFF2E6), Color(0xFFFFDCC7), Color(0xFFFFCCAC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            right: 0,
            top: -10,
            child: Opacity(
              opacity: 0.12,
              child: Icon(Icons.location_on, size: 180, color: kOrange),
            ),
          ),
          Positioned(
            right: 16,
            top: 12,
            bottom: 12,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=300',
                fit: BoxFit.cover,
                width: 140,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 140,
                    color: Colors.orange.shade100,
                    alignment: Alignment.center,
                    child: const Text('🍕🍔', style: TextStyle(fontSize: 48)),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Text('SORA ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: kInk)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(color: kGold, borderRadius: BorderRadius.circular(4)),
                      child: const Text('GOLD', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text('FLASH SALE', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: kInk, height: 1.0)),
                const SizedBox(height: 6),
                const Text('₹1 for 3 months', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: kInk)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 38,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kInk,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Join Gold now', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded, size: 12),
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

  Widget _categoryRow() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          if (i == _categories.length) {
            return _categoryItem(
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kChipBorder),
                  color: Colors.grey.shade50,
                ),
                child: const Icon(Icons.grid_view_rounded, color: kInk),
              ),
              label: 'More',
              selected: false,
              onTap: () {},
            );
          }
          final (emoji, label, imageUrl) = _categories[i];
          return _categoryItem(
            child: ClipOval(
              child: Image.network(
                imageUrl,
                width: 58,
                height: 58,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 58,
                    height: 58,
                    color: Colors.grey.shade100,
                    alignment: Alignment.center,
                    child: Text(emoji, style: const TextStyle(fontSize: 28)),
                  );
                },
              ),
            ),
            label: label,
            selected: _selectedCategory == i,
            onTap: () {
              setState(() {
                _selectedCategory = i;
                if (label != 'All') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  SearchScreen(initialQuery: label)),
                  );
                }
              });
            },
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
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: selected ? kOrange : kChipBorder, width: selected ? 2 : 1),
            ),
            child: child,
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: kInk)),
          if (selected) ...[
            const SizedBox(height: 2),
            Container(height: 2.5, width: 24, decoration: BoxDecoration(color: kOrange, borderRadius: BorderRadius.circular(2))),
          ]
        ],
      ),
    );
  }

  Widget _filterChips() {
    Widget chip(Widget child) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(border: Border.all(color: kChipBorder), borderRadius: BorderRadius.circular(16)),
      child: child,
    );

    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          chip(Row(children: const [
            Icon(Icons.tune, size: 16),
            SizedBox(width: 4),
            Text('Filters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Icon(Icons.arrow_drop_down, size: 16),
          ])),
          const SizedBox(width: 8),
          chip(Row(children: const [
            Icon(Icons.bolt, size: 16, color: kGreen),
            SizedBox(width: 4),
            Text('Near & Fast', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ])),
          const SizedBox(width: 8),
          chip(Row(children: const [
            Icon(Icons.eco, size: 16, color: kGreen),
            SizedBox(width: 4),
            Text('No packaging charges', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ])),
          const SizedBox(width: 8),
          chip(Row(children: const [
            Icon(Icons.star, size: 16, color: kInk),
            SizedBox(width: 4),
            Text('Top rated', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ])),
        ],
      ),
    );
  }

  Widget _recommendedHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text('RECOMMENDED FOR YOU', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 0.5, color: kInk)),
          Text('See all', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kOrange)),
        ],
      ),
    );
  }

  Widget _restaurantList() {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: kRestaurants.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, i) => RestaurantCard(restaurant: kRestaurants[i]),
      ),
    );
  }

  Widget _floatingActionDeck() {
    return Positioned(
      bottom: 12,
      left: 12,
      right: 12,
      child: Row(
        children: [
          Expanded(
            flex: 13,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4)),
                ],
                border: Border.all(color: kChipBorder.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  _quickActionItem(const Icon(Icons.delivery_dining, color: kOrange, size: 20), 'Delivery', 'Now', highlight: true),
                  _deckDivider(),
                  _quickActionItem(const Icon(Icons.local_offer_outlined, size: 18), 'Under ₹250', ''),
                  _deckDivider(),
                  _quickActionItem(const Icon(Icons.restaurant, size: 18), 'Dining', 'Book Table'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 9,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrdersScreen()),
                );
              },
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: kOrange,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(color: kOrange.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag, color: Colors.white, size: 20),
                    const SizedBox(width: 6),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text('Order Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
                            Icon(Icons.chevron_right, color: Colors.white, size: 16),
                          ],
                        ),
                        const Text('Food on your way!', style: TextStyle(color: Colors.white70, fontSize: 9)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActionItem(Icon icon, String title, String subtitle, {bool highlight = false}) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 1),
          Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: highlight ? kOrange : kInk)),
          if (subtitle.isNotEmpty)
            Text(subtitle, style: TextStyle(fontSize: 8, color: highlight ? kOrange : kGrey)),
        ],
      ),
    );
  }

  Widget _deckDivider() => Container(width: 1, height: 28, color: kChipBorder);

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (i) {
        if (i == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchScreen()),
          );
        } else if (i == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrdersScreen()),
          );
        } else if (i == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavouritesScreen()),
          );
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: kOrange,
      unselectedItemColor: kInk,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favourites'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}

// ─────────────────────────── SECOND SCREEN: DEDICATED SEARCH SCREEN ───────────────────────────

class SearchScreen extends StatefulWidget {
  final String? initialQuery;
  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Restaurant> _filteredRestaurants = [];

  final List<String> _recentSearches = ['Biryani', 'Pizza', 'Burgers', 'Noodles', 'Cake'];

  final List<(String, String, String)> _popularCategories = const [
    ('🍕', 'Pizza', 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=200'),
    ('🍔', 'Burger', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200'),
    ('🍛', 'Biryani', 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=200'),
    ('🍰', 'Cake', 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=200'),
    ('🍜', 'Chinese', 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=200'),
    ('🍱', 'North Indian', 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=200'),
    ('🫓', 'South Indian', 'https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=200'),
    ('🌯', 'Rolls', 'https://images.unsplash.com/photo-1626700051175-6518c4793f4f?w=200'),
  ];

  final List<Map<String, dynamic>> _trendingRestaurants = const [
    {
      'name': 'Kebabs & Curries',
      'cuisine': 'North Indian • Mughlai',
      'rating': 4.2,
      'time': '25-30 mins',
      'imageUrl': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=300',
      'colorFallback': Color(0xFFE8A13D),
      'emojiFallback': '🍲',
    },
    {
      'name': 'Sakura Sushi Bar',
      'cuisine': 'Japanese • Seafood',
      'rating': 4.5,
      'time': '35-40 mins',
      'imageUrl': 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=300',
      'colorFallback': Color(0xFFE05B5B),
      'emojiFallback': '🍣',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredRestaurants = List.from(kRestaurants);
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      _filterRestaurants(widget.initialQuery!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRestaurants(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredRestaurants = List.from(kRestaurants);
      } else {
        _filteredRestaurants = kRestaurants
            .where((r) =>
        r.name.toLowerCase().contains(query.toLowerCase()) ||
            r.cuisine.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kOrange),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Search Food',
          style: TextStyle(color: kInk, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_outlined, color: kOrange),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.grey.shade200, width: 1.2),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: kInk, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterRestaurants,
                      onSubmitted: _filterRestaurants,
                      decoration: const InputDecoration(
                        hintText: 'Search for dishes or restaurants',
                        hintStyle: TextStyle(color: kGrey, fontSize: 15),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(color: kInk, fontSize: 15),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.clear, color: kInk, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        _filterRestaurants('');
                      },
                    )
                  else
                    const Icon(Icons.mic, color: kOrange, size: 22),
                ],
              ),
            ),
          ),
          Expanded(
            child: _searchController.text.isEmpty
                ? _buildSuggestionsView()
                : _buildResultsView(),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _buildSuggestionsView() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 8),
        _buildRecentSearchesSection(),
        const SizedBox(height: 8),
        _buildPopularCategoriesSection(),
        const SizedBox(height: 12),
        _buildTrendingNearYouSection(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRecentSearchesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Recent Searches', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kInk)),
        ),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _recentSearches.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final search = _recentSearches[index];
              return InkWell(
                onTap: () {
                  _searchController.text = search;
                  _filterRestaurants(search);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF2EC),
                    border: Border.all(color: kOrange.withOpacity(0.3), width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 14, color: kOrange),
                      const SizedBox(width: 4),
                      Text(search, style: const TextStyle(color: kOrange, fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Popular Categories', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kInk)),
              Text('See all', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kOrange)),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: _popularCategories.length,
          itemBuilder: (context, index) {
            final (emoji, label, imageUrl) = _popularCategories[index];
            return InkWell(
              onTap: () {
                _searchController.text = label;
                _filterRestaurants(label);
              },
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 3)),
                      ],
                      border: Border.all(color: Colors.grey.shade100, width: 1),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Text(emoji, style: const TextStyle(fontSize: 30)));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kInk), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTrendingNearYouSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text('Trending Near You', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kInk)),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _trendingRestaurants.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final rest = _trendingRestaurants[index];
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kChipBorder.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      rest['imageUrl'],
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 72,
                          height: 72,
                          color: rest['colorFallback'],
                          alignment: Alignment.center,
                          child: Text(rest['emojiFallback'], style: const TextStyle(fontSize: 32)),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rest['name'], style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: kInk)),
                        const SizedBox(height: 2),
                        Text(rest['cuisine'], style: const TextStyle(fontSize: 11.5, color: kGrey)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: kGreen, borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, size: 10, color: Colors.white),
                                  const SizedBox(width: 2),
                                  Text(rest['rating'].toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(width: 3, height: 3, decoration: const BoxDecoration(color: kGrey, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Text(rest['time'], style: const TextStyle(fontSize: 11, color: kGrey, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: kLightGreen, borderRadius: BorderRadius.circular(8), border: Border.all(color: kGreen.withOpacity(0.2))),
                        child: const Text('20% OFF up to ₹120', style: TextStyle(color: kGreen, fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFFFF2E6), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: const [
                            Icon(Icons.bolt, size: 11, color: kOrange),
                            SizedBox(width: 2),
                            Text('Near & Fast', style: TextStyle(color: kOrange, fontSize: 9, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildResultsView() {
    if (_filteredRestaurants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.search_off, size: 56, color: kGrey),
            SizedBox(height: 12),
            Text('No match found!', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kGrey)),
            SizedBox(height: 4),
            Text('Try searching something else', style: TextStyle(fontSize: 12, color: kGrey)),
          ],
        ),
      );
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: _filteredRestaurants.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, i) {
        final rest = _filteredRestaurants[i];
        return InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  rest.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: rest.colorFallback,
                      alignment: Alignment.center,
                      child: Text(rest.emojiFallback, style: const TextStyle(fontSize: 36)),
                    );
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rest.name, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold, color: kInk)),
                    const SizedBox(height: 2),
                    Text(rest.cuisine, style: const TextStyle(fontSize: 12, color: kGrey)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: kGold),
                        const SizedBox(width: 2),
                        Text(rest.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kInk)),
                        const SizedBox(width: 12),
                        const Icon(Icons.access_time_filled, size: 14, color: kGrey),
                        const SizedBox(width: 2),
                        Text(rest.time, style: const TextStyle(fontSize: 12, color: kGrey)),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: kGrey),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1, // Search tab active
      onTap: (i) {
        if (i == 0) {
          Navigator.pop(context);
        } else if (i == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrdersScreen()),
          );
        } else if (i == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FavouritesScreen()),
          );
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: kOrange,
      unselectedItemColor: kInk,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favourites'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}

// ─────────────────────────── THIRD SCREEN: DEDICATED ORDERS SCREEN ───────────────────────────

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final List<Map<String, dynamic>> _pastOrders = const [
    {
      'restaurant': 'Kebabs & Curries',
      'date': 'Yesterday, 08:30 PM',
      'items': '1x Chicken Biryani, 2x Garlic Naan',
      'price': '₹490',
      'rating': 4.0,
      'imageUrl': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=300',
    },
    {
      'restaurant': 'Doodh Misthan',
      'date': '10 July 2026, 04:15 PM',
      'items': '1x Rasgulla Pack, 1x Kesar Peda',
      'price': '₹320',
      'rating': 5.0,
      'imageUrl': 'https://images.unsplash.com/photo-1587314168485-3236d6710814?w=300',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kOrange),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: kInk, letterSpacing: 1),
                children: [
                  TextSpan(text: 'S'),
                  TextSpan(text: 'O', style: TextStyle(color: kOrange)),
                  TextSpan(text: 'RA'),
                ],
              ),
            ),
            const Text(
              '— FOOD DELIVERY —',
              style: TextStyle(fontSize: 7, fontWeight: FontWeight.w800, color: kOrange, letterSpacing: 1.0),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: kOrange),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const Text(
            'ACTIVE ORDER',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kGrey, letterSpacing: 0.5),
          ),
          const SizedBox(height: 10),
          _buildActiveOrderCard(),
          const SizedBox(height: 24),
          const Text(
            'PAST ORDERS',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kGrey, letterSpacing: 0.5),
          ),
          const SizedBox(height: 12),
          ..._pastOrders.map((order) => _buildPastOrderCard(order)).toList(),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _buildActiveOrderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kChipBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=150',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Sakura Sushi Bar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kInk)),
                    Text('1x Spicy Salmon Roll, 1x Tuna Nigiri', style: TextStyle(fontSize: 12, color: kGrey), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const Text('Total: ₹540', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kInk)),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 14.0), child: Divider(color: kChipBorder, height: 1)),
          Row(
            children: const [
              Icon(Icons.restaurant, color: kGreen, size: 18),
              SizedBox(width: 8),
              Text('Preparing your food...', style: TextStyle(color: kGreen, fontWeight: FontWeight.bold, fontSize: 13)),
              Spacer(),
              Text('20 mins left', style: TextStyle(color: kGrey, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildProgressStep(true),
              _buildProgressLine(true),
              _buildProgressStep(true),
              _buildProgressLine(false),
              _buildProgressStep(false),
              _buildProgressLine(false),
              _buildProgressStep(false),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Accepted', style: TextStyle(fontSize: 10, color: kInk, fontWeight: FontWeight.bold)),
              Text('Preparing', style: TextStyle(fontSize: 10, color: kInk, fontWeight: FontWeight.bold)),
              Text('On the Way', style: TextStyle(fontSize: 10, color: kGrey)),
              Text('Delivered', style: TextStyle(fontSize: 10, color: kGrey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(bool active) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? kOrange : Colors.grey.shade300,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          if (active) BoxShadow(color: kOrange.withOpacity(0.3), blurRadius: 4, spreadRadius: 1),
        ],
      ),
    );
  }

  Widget _buildProgressLine(bool active) {
    return Expanded(
      child: Container(height: 3, color: active ? kOrange : Colors.grey.shade300),
    );
  }

  Widget _buildPastOrderCard(Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kChipBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(order['imageUrl'], width: 50, height: 50, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order['restaurant'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kInk)),
                    Text(order['date'], style: const TextStyle(fontSize: 11, color: kGrey)),
                    const SizedBox(height: 4),
                    Text(order['items'], style: const TextStyle(fontSize: 12, color: kGrey), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Text(order['price'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kInk)),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12.0), child: Divider(color: kChipBorder, height: 1)),
          Row(
            children: [
              Row(
                children: List.generate(5, (starIdx) {
                  final active = starIdx < order['rating'].toInt();
                  return Icon(Icons.star, size: 14, color: active ? kGold : Colors.grey.shade300);
                }),
              ),
              const Spacer(),
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kOrange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Order Again', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 2, // Orders tab active
      onTap: (i) {
        if (i == 0) {
          Navigator.popUntil(context, (route) => route.isFirst);
        } else if (i == 1) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
        } else if (i == 3) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FavouritesScreen()));
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: kOrange,
      unselectedItemColor: kInk,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favourites'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}

// ─────────────────────────── FOURTH SCREEN: DEDICATED FAVOURITES SCREEN ───────────────────────────

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  int _activeSubTab = 0; // 0 for Restaurants, 1 for Dishes
  final TextEditingController _searchController = TextEditingController();

  // Master Mock Data - Restaurants
  final List<Restaurant> _allFavoriteRestaurants = [
    kRestaurants[0], // Kebabs & Curries
    kRestaurants[1], // Handi Restaurant
  ];

  // Master Mock Data - Dishes
  final List<Map<String, dynamic>> _allFavoriteDishes = const [
    {
      'name': 'Special Paneer Tikka Pizza',
      'restaurant': 'Rasoi Thali House',
      'price': '₹249',
      'rating': 4.4,
      'imageUrl': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=300',
    },
    {
      'name': 'Special Veg Thali',
      'restaurant': 'Handi Restaurant',
      'price': '₹199',
      'rating': 4.1,
      'imageUrl': 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=300',
    }
  ];

  // Filtered lists shown in UI
  List<Restaurant> _filteredRestaurants = [];
  List<Map<String, dynamic>> _filteredDishes = [];

  @override
  void initState() {
    super.initState();
    _filteredRestaurants = List.from(_allFavoriteRestaurants);
    _filteredDishes = List.from(_allFavoriteDishes);
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredRestaurants = List.from(_allFavoriteRestaurants);
        _filteredDishes = List.from(_allFavoriteDishes);
      } else {
        final lowercaseQuery = query.toLowerCase();

        // Filter Restaurants
        _filteredRestaurants = _allFavoriteRestaurants.where((rest) {
          return rest.name.toLowerCase().contains(lowercaseQuery) ||
              rest.cuisine.toLowerCase().contains(lowercaseQuery);
        }).toList();

        // Filter Dishes
        _filteredDishes = _allFavoriteDishes.where((dish) {
          return dish['name'].toString().toLowerCase().contains(lowercaseQuery) ||
              dish['restaurant'].toString().toLowerCase().contains(lowercaseQuery);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kOrange),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Favourites',
          style: TextStyle(
            color: kInk,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Styled permanent search bar below AppBar (exactly like in the mockup image)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.grey.shade200, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: kInk, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: const InputDecoration(
                        hintText: 'Search favorites...',
                        hintStyle: TextStyle(color: kGrey, fontSize: 15),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(color: kInk, fontSize: 15),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.clear, color: kInk, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  else
                    const Icon(Icons.mic, color: kOrange, size: 22),
                ],
              ),
            ),
          ),
          // Sub-tabs switch (Restaurants / Dishes)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              children: [
                _buildSubTab(0, 'Restaurants'),
                const SizedBox(width: 10),
                _buildSubTab(1, 'Dishes'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Grid view list of favorited items
          Expanded(
            child: _activeSubTab == 0
                ? _buildFavoriteRestaurantsGrid()
                : _buildFavoriteDishesGrid(),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _buildSubTab(int index, String label) {
    final active = _activeSubTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeSubTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: active ? kOrange : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : kGrey,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteRestaurantsGrid() {
    if (_filteredRestaurants.isEmpty) {
      return const Center(
        child: Text(
          'No matching favourite restaurants!',
          style: TextStyle(color: kGrey, fontSize: 14),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 16,
        childAspectRatio: 0.70,
      ),
      itemCount: _filteredRestaurants.length,
      itemBuilder: (context, index) {
        final rest = _filteredRestaurants[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  Image.network(
                    rest.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: kGreen, borderRadius: BorderRadius.circular(6)),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 10, color: Colors.white),
                          const SizedBox(width: 2),
                          Text(
                            rest.rating.toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite, size: 16, color: kOrange),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(rest.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kInk)),
            Text(rest.cuisine, style: const TextStyle(fontSize: 11, color: kGrey), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 12, color: kGrey),
                const SizedBox(width: 3),
                Text(rest.time, style: const TextStyle(fontSize: 11, color: kGrey)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildFavoriteDishesGrid() {
    if (_filteredDishes.isEmpty) {
      return const Center(
        child: Text(
          'No matching favourite dishes!',
          style: TextStyle(color: kGrey, fontSize: 14),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 16,
        childAspectRatio: 0.70,
      ),
      itemCount: _filteredDishes.length,
      itemBuilder: (context, index) {
        final dish = _filteredDishes[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  Image.network(
                    dish['imageUrl'],
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite, size: 16, color: kOrange),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(dish['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kInk), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(dish['restaurant'], style: const TextStyle(fontSize: 11, color: kGrey)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dish['price'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: kOrange)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(border: Border.all(color: kOrange), borderRadius: BorderRadius.circular(12)),
                  child: const Text('ADD', style: TextStyle(color: kOrange, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 3, // Favourites tab active
      onTap: (i) {
        if (i == 0) {
          Navigator.popUntil(context, (route) => route.isFirst);
        } else if (i == 1) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
        } else if (i == 2) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OrdersScreen()));
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: kOrange,
      unselectedItemColor: kInk,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favourites'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}

// ─────────────────────── RESTAURANT CARD WIDGET ────────────────────

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
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                Image.network(
                  restaurant.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 140,
                      width: double.infinity,
                      color: restaurant.colorFallback,
                      alignment: Alignment.center,
                      child: Text(restaurant.emojiFallback, style: const TextStyle(fontSize: 56)),
                    );
                  },
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.65), borderRadius: BorderRadius.circular(8)),
                    child: Text(restaurant.offerTag, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: kGreen, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 12, color: Colors.white),
                        const SizedBox(width: 3),
                        Text(restaurant.rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(restaurant.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kInk)),
          const SizedBox(height: 2),
          Text(restaurant.cuisine, style: const TextStyle(fontSize: 12, color: kGrey), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Row(
            children: const [
              Icon(Icons.bolt, size: 15, color: kGreen),
              SizedBox(width: 3),
              Text('Near & Fast', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kGreen)),
            ],
          ),
          const SizedBox(height: 2),
          Text(restaurant.time, style: const TextStyle(fontSize: 12, color: kGrey)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(color: kLightGreen, borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text(restaurant.discount, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kGreen))),
          ),
        ],
      ),
    );
  }
}