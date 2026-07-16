import 'package:flutter/material.dart';
import 'main.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoadingGps = false;

  final List<Map<String, String>> _savedLocations = [
    {
      'title': 'Home',
      'address': 'Todarmal Marg, Banipark, Jaipur',
      'short': 'Banipark',
      'icon': '🏠',
    },
    {
      'title': 'Work',
      'address': '5th Floor, Apex Tower, Lalkothi, Jaipur',
      'short': 'Lalkothi',
      'icon': '💼',
    },
    {
      'title': 'Gym',
      'address': 'Fit Life Gym, Vaishali Nagar, Jaipur',
      'short': 'Vaishali Nagar',
      'icon': '🏋️',
    },
  ];

  List<Map<String, String>> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _filteredLocations = List.from(_savedLocations);
  }

  void _onSearchChanged(String query) {
    setState(() {
      _filteredLocations = _savedLocations
          .where((loc) =>
              loc['title']!.toLowerCase().contains(query.toLowerCase()) ||
              loc['address']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _simulateGpsFetch() {
    setState(() {
      _isLoadingGps = true;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _isLoadingGps = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('GPS Location fetched: C-Scheme, Jaipur'),
          backgroundColor: kGreen,
        ),
      );

      // Return short location name to HomeScreen
      Navigator.pop(context, 'C-Scheme');
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
        title: const Text('Select Location', style: TextStyle(color: kInk, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Search Location Box
          Container(
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
                    onChanged: _onSearchChanged,
                    decoration: const InputDecoration(
                      hintText: 'Search for area, street name...',
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
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 2. Use Current Location Row
          InkWell(
            onTap: _isLoadingGps ? null : _simulateGpsFetch,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: kChipBorder),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _isLoadingGps
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: kGreen),
                        )
                      : const Icon(Icons.gps_fixed, color: kGreen, size: 20),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Use current location', style: TextStyle(color: kGreen, fontWeight: FontWeight.bold, fontSize: 14.5)),
                        SizedBox(height: 2),
                        Text('Using GPS to fetch active address', style: TextStyle(color: kGrey, fontSize: 11)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: kGrey, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // 3. Saved Addresses Section
          const Text('SAVED ADDRESSES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kGrey, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kChipBorder),
            ),
            child: _filteredLocations.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: Text('No matching locations found', style: TextStyle(color: kGrey))),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredLocations.length,
                    separatorBuilder: (_, __) => const Divider(color: kChipBorder, height: 1),
                    itemBuilder: (context, index) {
                      final item = _filteredLocations[index];
                      return ListTile(
                        onTap: () {
                          // Return selected address name to HomeScreen
                          Navigator.pop(context, item['short']);
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFFFF2EC),
                          child: Text(item['icon']!, style: const TextStyle(fontSize: 18)),
                        ),
                        title: Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold, color: kInk, fontSize: 14.5)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(item['address']!, style: const TextStyle(color: kGrey, fontSize: 12)),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: kGrey, size: 16),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
