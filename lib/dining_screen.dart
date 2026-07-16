import 'package:flutter/material.dart';
import 'main.dart';

// ─────────────────────────── SEVENTH SCREEN: DEDICATED DINING SCREEN ───────────────────────────

class DiningScreen extends StatefulWidget {
  const DiningScreen({super.key});

  @override
  State<DiningScreen> createState() => _DiningScreenState();
}

class _DiningScreenState extends State<DiningScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _diningSpots = [
    {
      'name': 'Sakura Sushi Bar',
      'cuisine': 'Japanese • Fine Dining',
      'location': 'C-Scheme, Jaipur',
      'distance': '1.2 km',
      'rating': 4.5,
      'offer': 'Flat 15% off on table booking',
      'imageUrl': 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=500',
      'colorFallback': Color(0xFFE05B5B),
      'emojiFallback': '🍣',
      'tags': ['Fine Dining', 'Nearest'],
    },
    {
      'name': 'Kebabs & Curries',
      'cuisine': 'North Indian • Mughlai',
      'location': 'Banipark, Jaipur',
      'distance': '0.8 km',
      'rating': 4.2,
      'offer': 'Complimentary mocktail per guest',
      'imageUrl': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=500',
      'colorFallback': Color(0xFFE8A13D),
      'emojiFallback': '🍲',
      'tags': ['Family Dining', 'Nearest'],
    },
    {
      'name': 'The Rooftop Lounge',
      'cuisine': 'Continental • Italian',
      'location': 'Malviya Nagar, Jaipur',
      'distance': '2.5 km',
      'rating': 4.7,
      'offer': 'Happy Hours: 1+1 on drinks',
      'imageUrl': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=500',
      'colorFallback': Color(0xFF3E5641),
      'emojiFallback': '🍸',
      'tags': ['Rooftop', 'Outdoor Seating'],
    },
  ];

  List<Map<String, dynamic>> _filteredSpots = [];

  @override
  void initState() {
    super.initState();
    _filteredSpots = List.from(_diningSpots);
  }

  void _filterDining(String query) {
    setState(() {
      _filteredSpots = _diningSpots.where((spot) {
        final matchesQuery = spot['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
            spot['cuisine'].toString().toLowerCase().contains(query.toLowerCase());
        final matchesFilter = _selectedFilter == 'All' || spot['tags'].contains(_selectedFilter);
        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
      _filterDining(_searchController.text);
    });
  }

  void _showBookingDialog(Map<String, dynamic> spot) {
    String selectedGuests = '2 Guests';
    String selectedDate = 'Today';
    String selectedTime = '07:00 PM';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('Book a Table at', style: TextStyle(color: kGrey, fontSize: 13, fontWeight: FontWeight.w500)),
                  Text(spot['name'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: kInk)),
                  const SizedBox(height: 20),

                  // 1. GUESTS PICKER
                  const Text('NUMBER OF GUESTS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kGrey, letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['2 Guests', '4 Guests', '6 Guests', '8+ Guests'].map((item) {
                      final active = selectedGuests == item;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedGuests = item),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: active ? kOrange : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: active ? kOrange : Colors.transparent),
                          ),
                          child: Text(item, style: TextStyle(color: active ? Colors.white : kInk, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // 2. DATE PICKER
                  const Text('SELECT DATE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kGrey, letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['Today', 'Tomorrow', '13 July'].map((item) {
                      final active = selectedDate == item;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedDate = item),
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 64) / 3,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: active ? kOrange : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: active ? kOrange : Colors.transparent),
                          ),
                          child: Text(item, style: TextStyle(color: active ? Colors.white : kInk, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // 3. TIME SLOT PICKER
                  const Text('SELECT TIME SLOT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: kGrey, letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['07:00 PM', '08:00 PM', '09:00 PM', '10:00 PM'].map((item) {
                      final active = selectedTime == item;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedTime = item),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: active ? kOrange : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: active ? kOrange : Colors.transparent),
                          ),
                          child: Text(item, style: TextStyle(color: active ? Colors.white : kInk, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  // 4. CONFIRM BUTTON
                  SizedBox(
                    height: 54,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close bottom sheet
                        _showSuccessDialog(spot['name'], selectedGuests, selectedDate, selectedTime);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kOrange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      ),
                      child: const Text('Confirm Reservation', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSuccessDialog(String name, String guests, String date, String time) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: kLightGreen, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, color: kGreen, size: 48),
            ),
            const SizedBox(height: 18),
            const Text('Booking Confirmed!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: kInk)),
            const SizedBox(height: 8),
            Text(
              'Your reservation at $name is successfully registered.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: kGrey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: kChipBorder)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Guests:', style: TextStyle(color: kGrey, fontSize: 12)),
                      Text(guests, style: const TextStyle(fontWeight: FontWeight.bold, color: kInk, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Date:', style: TextStyle(color: kGrey, fontSize: 12)),
                      Text(date, style: const TextStyle(fontWeight: FontWeight.bold, color: kInk, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Time Slot:', style: TextStyle(color: kGrey, fontSize: 12)),
                      Text(time, style: const TextStyle(fontWeight: FontWeight.bold, color: kInk, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kInk,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                minimumSize: const Size(double.infinity, 44),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Awesome!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
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
        title: const Text('Dining Out', style: TextStyle(color: kInk, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
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
                      onChanged: _filterDining,
                      decoration: const InputDecoration(
                        hintText: 'Search restaurants, bars, cafes...',
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
                        _filterDining('');
                      },
                    )
                ],
              ),
            ),
          ),

          // Filters list
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['All', 'Nearest', 'Fine Dining', 'Outdoor Seating', 'Family Dining', 'Rooftop'].map((filter) {
                final active = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () => _onFilterSelected(filter),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? kOrange : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: active ? kOrange : kChipBorder.withOpacity(0.3)),
                    ),
                    child: Text(filter, style: TextStyle(color: active ? Colors.white : kGrey, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Results
          Expanded(
            child: _filteredSpots.isEmpty
                ? const Center(
              child: Text('No dining spots match your criteria!', style: TextStyle(color: kGrey)),
            )
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _filteredSpots.length,
              itemBuilder: (context, index) {
                final spot = _filteredSpots[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kChipBorder.withOpacity(0.7)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: Image.network(
                          spot['imageUrl'],
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 160,
                              width: double.infinity,
                              color: spot['colorFallback'],
                              alignment: Alignment.center,
                              child: Text(spot['emojiFallback'], style: const TextStyle(fontSize: 64)),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(spot['name'], style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold, color: kInk)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: kGreen, borderRadius: BorderRadius.circular(6)),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, size: 10, color: Colors.white),
                                      const SizedBox(width: 2),
                                      Text(spot['rating'].toString(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(spot['cuisine'], style: const TextStyle(color: kGrey, fontSize: 12)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 14, color: kGrey),
                                const SizedBox(width: 4),
                                Text('${spot['location']} • ${spot['distance']}', style: const TextStyle(color: kGrey, fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(color: const Color(0xFFFFF2EC), borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  const Icon(Icons.local_offer, size: 14, color: kOrange),
                                  const SizedBox(width: 6),
                                  Text(spot['offer'], style: const TextStyle(color: kOrange, fontSize: 11, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              height: 42,
                              child: ElevatedButton(
                                onPressed: () => _showBookingDialog(spot),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kOrange,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                child: const Text('Book Table', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}