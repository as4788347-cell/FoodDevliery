import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // OTP controllers
  final _otp1Controller = TextEditingController();
  final _otp2Controller = TextEditingController();
  final _otp3Controller = TextEditingController();
  final _otp4Controller = TextEditingController();

  // Focus nodes to shift focus automatically
  final _otp1Focus = FocusNode();
  final _otp2Focus = FocusNode();
  final _otp3Focus = FocusNode();
  final _otp4Focus = FocusNode();

  bool _isOtpSent = false;
  bool _isLoading = false;
  int _secondsRemaining = 30;
  Timer? _timer;

  void _startTimer() {
    setState(() {
      _secondsRemaining = 30;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _timer?.cancel();
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _sendOtp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate sending OTP SMS
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _isOtpSent = true;
        });
        _startTimer();
        
        // Show demo OTP inside SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demo OTP sent: 1 2 3 4'),
            backgroundColor: kOrange,
            duration: Duration(seconds: 6),
          ),
        );
      });
    }
  }

  void _verifyOtp() {
    final otp = _otp1Controller.text +
        _otp2Controller.text +
        _otp3Controller.text +
        _otp4Controller.text;

    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the full 4-digit OTP code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate OTP verification API call
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      if (otp == '1234') {
        // Successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully authenticated with OTP!'),
            backgroundColor: kGreen,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid OTP code. Please try again!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otp1Controller.dispose();
    _otp2Controller.dispose();
    _otp3Controller.dispose();
    _otp4Controller.dispose();
    _otp1Focus.dispose();
    _otp2Focus.dispose();
    _otp3Focus.dispose();
    _otp4Focus.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Skip / Back buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_isOtpSent)
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: kInk),
                        onPressed: () {
                          setState(() {
                            _isOtpSent = false;
                          });
                        },
                      )
                    else
                      const SizedBox(),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: kGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Logo and Branding
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: kOrange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.restaurant,
                          color: kOrange,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: kInk,
                            letterSpacing: 1.2,
                          ),
                          children: [
                            TextSpan(text: 'S'),
                            TextSpan(text: 'O', style: TextStyle(color: kOrange)),
                            TextSpan(text: 'R'),
                            TextSpan(text: 'A '),
                            TextSpan(text: 'Food', style: TextStyle(color: kOrange)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Your favorite food, delivered fast',
                        style: TextStyle(color: kGrey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Conditional Layout based on OTP status
                if (!_isOtpSent) ...[
                  // PHONE LOGIN SCREEN
                  const Text(
                    'Welcome to SORA Food',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: kInk,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter your phone number to proceed with OTP verification',
                    style: TextStyle(color: kGrey, fontSize: 14),
                  ),
                  const SizedBox(height: 32),

                  // Phone Input Field
                  const Text(
                    'PHONE NUMBER',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: kGrey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: kInk, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                        child: Text(
                          '+91 ',
                          style: TextStyle(
                            color: kInk,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                      hintText: 'Enter 10-digit phone number',
                      hintStyle: const TextStyle(color: kGrey, fontWeight: FontWeight.normal),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: kOrange, width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.red, width: 1.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length != 10 || int.tryParse(value) == null) {
                        return 'Please enter a valid 10-digit number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Get OTP Button
                  Sora3D.pushButton(
                    onTap: _isLoading ? null : _sendOtp,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Send OTP',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                  ),
                ] else ...[
                  // OTP VERIFICATION VIEW
                  const Text(
                    'Verify Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: kInk,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'OTP sent to +91 ${_phoneController.text}',
                        style: const TextStyle(color: kGrey, fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isOtpSent = false;
                          });
                        },
                        child: const Icon(Icons.edit, color: kOrange, size: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 4 OTP Boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _otpTextField(_otp1Controller, _otp1Focus, _otp2Focus, true),
                      _otpTextField(_otp2Controller, _otp2Focus, _otp3Focus, false),
                      _otpTextField(_otp3Controller, _otp3Focus, _otp4Focus, false),
                      _otpTextField(_otp4Controller, _otp4Focus, null, false),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Resend countdown
                  Center(
                    child: _secondsRemaining > 0
                        ? Text(
                            'Resend OTP in ${_secondsRemaining}s',
                            style: const TextStyle(color: kGrey, fontWeight: FontWeight.bold, fontSize: 14),
                          )
                        : TextButton(
                            onPressed: _startTimer,
                            child: const Text(
                              'Resend OTP',
                              style: TextStyle(color: kOrange, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                  ),
                  const SizedBox(height: 28),

                  // Verify Button
                  Sora3D.pushButton(
                    onTap: _isLoading ? null : _verifyOtp,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Verify & Proceed',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                  ),
                ],
                const SizedBox(height: 32),

                // Social Logins Divider
                Row(
                  children: const [
                    Expanded(child: Divider(color: kChipBorder)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: kGrey, fontSize: 12),
                      ),
                    ),
                    Expanded(child: Divider(color: kChipBorder)),
                  ],
                ),
                const SizedBox(height: 24),

                // Social buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton(
                      logo: '🌐',
                      label: 'Google',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Signing in with Google...')),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    _socialButton(
                      logo: '🍎',
                      label: 'Apple',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Signing in with Apple...')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _otpTextField(
    TextEditingController controller,
    FocusNode currentFocus,
    FocusNode? nextFocus,
    bool autoFocus,
  ) {
    return SizedBox(
      width: 64,
      height: 64,
      child: TextFormField(
        controller: controller,
        focusNode: currentFocus,
        autofocus: autoFocus,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kInk),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: kOrange, width: 1.5),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (nextFocus != null) {
              FocusScope.of(context).requestFocus(nextFocus);
            } else {
              currentFocus.unfocus();
            }
          } else {
            // Shift back focus if empty
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  Widget _socialButton({
    required String logo,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: kChipBorder),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(logo, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: kInk,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
