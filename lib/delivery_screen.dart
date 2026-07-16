import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  bool _contactless = true;
  bool _noBell = false;
  bool _leaveAtGate = false;
  final TextEditingController _instructionController = TextEditingController();

  double _riderProgress = 0.0;
  Timer? _timer;
  int _ratingVal = 5;
  final _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startRiderSimulation();
  }

  void _startRiderSimulation() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (!mounted) return;
      if (_riderProgress >= 1.0) {
        _timer?.cancel();
        _onDeliveryArrived();
      } else {
        setState(() {
          _riderProgress = (_riderProgress + 0.07).clamp(0.0, 1.0);
        });
      }
    });
  }

  void _onDeliveryArrived() {
    // 1. Update order status in orders history
    final currentOrders = List<Map<String, dynamic>>.from(SoraAppState.ordersNotifier.value);
    if (currentOrders.isNotEmpty) {
      currentOrders[0]['status'] = 'Delivered';
      currentOrders[0]['time'] = 'Just Now (Delivered)';
      SoraAppState.ordersNotifier.value = currentOrders;
    }

    // 2. Trigger feedback pop-up
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildFeedbackDialog(),
    );
  }

  Widget _buildFeedbackDialog() {
    return StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Center(
            child: Text(
              'Rate your Feast! 🌟',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kInk),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'How was the food quality and rider speed?',
                textAlign: TextAlign.center,
                style: TextStyle(color: kGrey, fontSize: 13),
              ),
              const SizedBox(height: 16),
              
              // Star Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (idx) {
                  final active = idx < _ratingVal;
                  return GestureDetector(
                    onTap: () {
                      setDialogState(() {
                        _ratingVal = idx + 1;
                      });
                    },
                    child: Icon(
                      Icons.star,
                      size: 32,
                      color: active ? kGold : Colors.grey.shade300,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              
              // Review input
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: kChipBorder),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade50,
                ),
                child: TextField(
                  controller: _reviewController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Write feedback (e.g. Delicious food, polite rider)',
                    hintStyle: TextStyle(color: kGrey, fontSize: 12),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 12, color: kInk),
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kOrange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Feedback submitted! Thank you for rating us $_ratingVal stars.'),
                      backgroundColor: kGreen,
                    ),
                  );
                },
                child: const Text('Submit Feedback', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _callRider() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Calling rider Ramesh Kumar (+91 98765 43211)...'),
        backgroundColor: kOrange,
      ),
    );
  }

  void _chatWithRider() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connecting chat with rider...'),
        backgroundColor: kInk,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _instructionController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Dynamic timeline status updates
    final tPlaced = true;
    final tPrepared = _riderProgress >= 0.3;
    final tPicked = _riderProgress >= 0.6;
    final tOut = _riderProgress >= 0.8;
    final tArrived = _riderProgress >= 1.0;

    final int minutesLeft = ((1.0 - _riderProgress) * 12).toInt();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kOrange),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Live Delivery Tracking',
          style: TextStyle(
            color: isDark ? Colors.white : kInk,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Map Illustration Banner with Animated Rider Progress
          LayoutBuilder(
            builder: (context, constraints) {
              final mapWidth = constraints.maxWidth;
              // Simple linear path coordinates for rider emoji
              final startX = 40.0;
              final startY = 40.0;
              final endX = mapWidth - 60.0;
              final endY = 160.0;

              final currentX = startX + (endX - startX) * _riderProgress;
              final currentY = startY + (endY - startY) * _riderProgress;

              return Container(
                height: 200,
                decoration: Sora3D.cardDecoration(isDark: isDark, radius: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      // Stylized Map Drawing Canvas
                      CustomPaint(
                        size: const Size(double.infinity, 200),
                        painter: MapPainter(
                          progress: _riderProgress,
                          isDark: isDark,
                        ),
                      ),
                      
                      // Rider Marker position
                      Positioned(
                        left: currentX - 20,
                        top: currentY - 20,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: kOrange,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1),
                            ],
                          ),
                          child: const Icon(
                            Icons.delivery_dining,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      
                      // Destination Marker pin
                      Positioned(
                        left: endX - 10,
                        top: endY - 30,
                        child: const Icon(Icons.location_on, color: kGreen, size: 28),
                      ),

                      // Source Marker pin
                      Positioned(
                        left: startX,
                        top: startY - 10,
                        child: const Icon(Icons.storefront, color: Colors.indigo, size: 22),
                      ),

                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF121212) : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isDark ? Colors.white12 : kChipBorder),
                          ),
                          child: Text(
                            '📍 Delivery to: Banipark',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : kInk,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // 2. Rider Details Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: Sora3D.cardDecoration(isDark: isDark, radius: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: kLightGreen,
                      child: Text('🚴', style: TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ramesh Kumar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : kInk,
                            ),
                          ),
                          const Text('Sora Delivery Partner • 4.8 ★', style: TextStyle(fontSize: 12, color: kGrey)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone_in_talk, color: kGreen),
                      onPressed: _callRider,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble, color: kOrange),
                      onPressed: _chatWithRider,
                    ),
                  ],
                ),
                const Divider(color: kChipBorder, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Estimated Delivery Time:', style: TextStyle(color: kGrey, fontSize: 13)),
                    Text(
                      minutesLeft > 0 ? '$minutesLeft Mins Left' : 'Arrived at door!',
                      style: const TextStyle(color: kOrange, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. Status Timeline
          const Text('TRACK ORDER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kGrey, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: Sora3D.cardDecoration(isDark: isDark, radius: 20),
            child: Column(
              children: [
                _buildTimelineRow('Order Placed', '07:15 PM', tPlaced, tPlaced && !tPrepared, isDark),
                _buildTimelineLine(tPrepared),
                _buildTimelineRow('Food Prepared', '07:28 PM', tPrepared, tPrepared && !tPicked, isDark),
                _buildTimelineLine(tPicked),
                _buildTimelineRow('Rider Picked Up', '07:35 PM', tPicked, tPicked && !tOut, isDark),
                _buildTimelineLine(tOut),
                _buildTimelineRow('Out for Delivery', 'Just now', tOut, tOut && !tArrived, isDark),
                _buildTimelineLine(tArrived),
                _buildTimelineRow('Arrived at Location', 'Est. 07:48 PM', tArrived, tArrived, isDark),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. Delivery Preferences
          const Text('DELIVERY INSTRUCTIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kGrey, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Container(
            decoration: Sora3D.cardDecoration(isDark: isDark, radius: 20),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Contactless Delivery', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : kInk, fontSize: 14)),
                  subtitle: const Text('Rider will leave the food at your doorstep or gate', style: TextStyle(fontSize: 11, color: kGrey)),
                  value: _contactless,
                  activeColor: Colors.white,
                  activeTrackColor: kOrange,
                  onChanged: (v) => setState(() => _contactless = v),
                ),
                const Divider(color: kChipBorder, height: 1),
                SwitchListTile(
                  title: Text('Do Not Ring Bell', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : kInk, fontSize: 14)),
                  subtitle: const Text('Rider will call or message instead of ringing the bell', style: TextStyle(fontSize: 11, color: kGrey)),
                  value: _noBell,
                  activeColor: Colors.white,
                  activeTrackColor: kOrange,
                  onChanged: (v) => setState(() => _noBell = v),
                ),
                const Divider(color: kChipBorder, height: 1),
                SwitchListTile(
                  title: Text('Leave at the Gate', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : kInk, fontSize: 14)),
                  subtitle: const Text('Food will be handed to the society guard/gatekeeper', style: TextStyle(fontSize: 11, color: kGrey)),
                  value: _leaveAtGate,
                  activeColor: Colors.white,
                  activeTrackColor: kOrange,
                  onChanged: (v) => setState(() => _leaveAtGate = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Custom Instruction Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.white12 : kChipBorder),
            ),
            child: TextField(
              controller: _instructionController,
              decoration: const InputDecoration(
                hintText: 'Add custom note (e.g. Ring bell only once)',
                hintStyle: TextStyle(color: kGrey, fontSize: 13),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 13, color: isDark ? Colors.white : kInk),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTimelineRow(String title, String time, bool completed, bool active, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? kOrange : (completed ? kGreen : Colors.grey.shade300),
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              if (active) BoxShadow(color: kOrange.withOpacity(0.3), blurRadius: 4, spreadRadius: 1),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: active || completed ? FontWeight.bold : FontWeight.w500,
                  color: active ? kOrange : (completed ? (isDark ? Colors.white : kInk) : kGrey),
                ),
              ),
            ],
          ),
        ),
        Text(time, style: const TextStyle(color: kGrey, fontSize: 11)),
      ],
    );
  }

  Widget _buildTimelineLine(bool completed) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 7),
      width: 2.5,
      height: 24,
      color: completed ? kGreen : Colors.grey.shade300,
    );
  }
}

class MapPainter extends CustomPainter {
  final double progress;
  final bool isDark;
  MapPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    // Background mesh drawing lines
    final meshPaint = Paint()
      ..color = isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade200
      ..strokeWidth = 1.0;

    // Draw horizontal grid lines
    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), meshPaint);
    }
    // Draw vertical grid lines
    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), meshPaint);
    }

    // Path route line
    final routePaint = Paint()
      ..color = isDark ? Colors.white10 : Colors.grey.shade300
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final activeRoutePaint = Paint()
      ..color = kOrange
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final startX = 40.0;
    final startY = 40.0;
    final endX = size.width - 60.0;
    final endY = 160.0;

    // Draw route path line
    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), routePaint);

    // Draw active portion of path route line
    final currentX = startX + (endX - startX) * progress;
    final currentY = startY + (endY - startY) * progress;
    canvas.drawLine(Offset(startX, startY), Offset(currentX, currentY), activeRoutePaint);
  }

  @override
  bool shouldRepaint(covariant MapPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
