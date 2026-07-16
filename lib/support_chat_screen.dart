import 'package:flutter/material.dart';
import 'main.dart';

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hi Abhishek! I am Sora Assistant. How can I help you today? You can ask about order status, refunds, or check your wallet balance.',
      'isUser': false,
      'time': 'Just Now',
    }
  ];

  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    setState(() {
      _messages.add({
        'text': text,
        'isUser': true,
        'time': 'Just Now',
      });
      _isTyping = true;
    });
    _scrollToBottom();

    // Simulate bot response after 1.2 seconds
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;

      String botReply = '';
      final lowerText = text.toLowerCase();

      if (lowerText.contains('late') || lowerText.contains('status') || lowerText.contains('delivery')) {
        botReply = 'I checked your active order. Rider Ramesh Kumar is currently on the way. He is estimated to arrive at your address in 8 minutes!';
      } else if (lowerText.contains('refund') || lowerText.contains('wallet')) {
        botReply = 'If you are unsatisfied with your order, I can initiate a refund of ₹120.00 directly to your Sora Wallet. Please type "Confirm Refund" to proceed.';
      } else if (lowerText.contains('confirm refund')) {
        // Dynamic refund to wallet!
        final currentBal = SoraAppState.walletBalanceNotifier.value;
        SoraAppState.walletBalanceNotifier.value = currentBal + 120.0;

        botReply = 'Refund of ₹120.00 processed successfully! A credit note is sent to your email. Your new Sora Wallet balance is ₹${SoraAppState.walletBalanceNotifier.value.toStringAsFixed(2)}.';
      } else if (lowerText.contains('hi') || lowerText.contains('hello')) {
        botReply = 'Hello! Hope you are hungry. Let me know if you need help with refunds, delivery tracking, or wallet balances.';
      } else {
        botReply = 'Thank you for reaching out. I am simulating live support. If you want to check order updates, ask "where is my food?", or type "Confirm Refund" to credit your wallet!';
      }

      setState(() {
        _isTyping = false;
        _messages.add({
          'text': botReply,
          'isUser': false,
          'time': 'Just Now',
        });
      });
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFFFF2EC),
              radius: 18,
              child: Text('🤖', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sora Bot Support',
                  style: TextStyle(
                    color: isDark ? Colors.white : kInk,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Text(
                  'Always active to help',
                  style: TextStyle(color: kGreen, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['isUser'] as bool;
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? kOrange
                          : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isUser ? 20 : 0),
                        bottomRight: Radius.circular(isUser ? 0 : 20),
                      ),
                      border: Border.all(
                        color: isUser
                            ? kOrange
                            : (isDark ? Colors.white12 : kChipBorder),
                      ),
                    ),
                    child: Text(
                      msg['text'] as String,
                      style: TextStyle(
                        color: isUser ? Colors.white : (isDark ? Colors.white : kInk),
                        fontSize: 14.5,
                        height: 1.3,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Typing Indicator
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: const [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: kOrange),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Sora Bot is typing...',
                      style: TextStyle(color: kGrey, fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),

          // Input Bar
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).viewInsets.bottom + 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              border: const Border(top: BorderSide(color: kChipBorder, width: 0.8)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF121212) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: isDark ? Colors.white12 : kChipBorder),
                    ),
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Type query (e.g. status, refund)...',
                        hintStyle: TextStyle(color: kGrey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 14.5, color: isDark ? Colors.white : kInk),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: kOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
