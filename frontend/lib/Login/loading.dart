import 'package:flutter/material.dart';
import 'package:tamdansers/services/api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  final _apiService = ApiService();

  @override
  void initState() {
    super.initState();

    // 1. Initialize the animation controller for a 20-second duration
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          // Navigates to the Role Selection screen defined in your routes
          _checkAuthAndNavigate();
        }
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
        case 'student':
          route = '/StudentDashboard';
        case 'parent':
          route = '/ParentDashboard';
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
    _progressController.dispose(); // Clean up memory
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA), // Match the light background
      body: Stack(
        children: [
          // Decorative background icons
          Opacity(
            opacity: 0.1,
            child: Center(
              child: Wrap(
                spacing: 100,
                runSpacing: 150,
                alignment: WrapAlignment.center,
                children: const [
                  Icon(Icons.menu_book, size: 80),
                  Icon(Icons.school, size: 80),
                  Icon(Icons.history_edu, size: 80),
                  Icon(Icons.architecture, size: 80),
                ],
              ),
            ),
          ),

          // Main Content in the center
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // School Logo Box
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.school,
                    size: 60,
                    color: Color(0xFF0D47A1), // Dark Blue color
                  ),
                ),
                const SizedBox(height: 40),
                const SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF0D47A1),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                const Text(
                  "សូមស្វាគមន៍មកកាន់ប្រព័ន្ធគ្រប់\nគ្រងសាលារៀន",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF263238),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "កំពុងដំណើរការ...",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Animated Bottom Progress Bar
          Positioned(
            bottom: 50,
            left: 40,
            right: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: _progressController
                        .value, // Slowly fills from 0 to 1 over 20s
                    backgroundColor: const Color(0xFFE0E0E0),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF0D47A1),
                    ),
                    minHeight: 6,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
