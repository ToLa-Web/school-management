
import 'package:flutter/material.dart';
import 'package:tamdansers/services/api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final _apiService = ApiService();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // Start authentication check after short delay (feels more natural)
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _checkAuthAndNavigate();
      }
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    await _apiService.loadTokens();
    if (!mounted) return;

    if (_apiService.isAuthenticated()) {
      final role = await _apiService.getUserRole();
      if (!mounted) return;

      String route;
      switch (role) {
        case 'teacher':
          route = '/TeacherDashboard';
          break;
        case 'student':
          route = '/StudentDashboard';
          break;
        case 'parent':
          route = '/ParentDashboard';
          break;
        default:
          route = '/RoleSelection';
      }
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    } else {
      Navigator.pushReplacementNamed(context, '/RoleSelection');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8fafc),
      body: Stack(
        children: [
          // === Modern subtle background gradient + floating shapes ===
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFe0f2fe),
                  Color(0xFFf0f9ff),
                  Color(0xFFe0f7fa),
                ],
              ),
            ),
          ),

          // Decorative subtle floating education icons
          Positioned(
            top: -60,
            right: -60,
            child: Opacity(
              opacity: 0.07,
              child: Icon(
                Icons.school_rounded,
                size: 220,
                color: Colors.blue[900],
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -40,
            child: Opacity(
              opacity: 0.06,
              child: Transform.rotate(
                angle: 0.4,
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 180,
                  color: Colors.teal[700],
                ),
              ),
            ),
          ),

          // === Main centered content ===
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo / Brand mark with modern glass effect
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0288D1), Color(0xFF0277BD)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.35),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // App name / Welcome message
                    const Text(
                      "Tam Dansers",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0D47A1),
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "School Management System",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Modern loading indicator
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF0288D1),
                        ),
                        backgroundColor: Colors.blue.withValues(alpha: 0.15),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Translated & polished welcome text
                    const Text(
                      "Welcome to the School Management System",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF263238),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Preparing your experience...",
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Optional: Very subtle bottom wave / accent
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.4,
              child: CustomPaint(
                size: const Size(double.infinity, 120),
                painter: _WavePainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple wave painter for modern bottom accent
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0288D1)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.6);

    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.3,
      size.width * 0.5,
      size.height * 0.55,
    );

    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.8,
      size.width,
      size.height * 0.45,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
