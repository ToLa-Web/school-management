import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tamdansers/services/api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Main entrance animation
  late AnimationController _entranceController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<double> _subtitleFade;
  late Animation<double> _loaderFade;

  // Pulsing glow ring
  late AnimationController _pulseController;
  late Animation<double> _pulseScale;
  late Animation<double> _pulseOpacity;

  // Rotating orbit ring
  late AnimationController _orbitController;

  // Floating particles
  late AnimationController _particleController;

  // Shimmer on title
  late AnimationController _shimmerController;
  late Animation<double> _shimmerSlide;

  // Progress dot animation
  late AnimationController _dotsController;

  final _apiService = ApiService();
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _generateParticles();

    // ── Entrance ──────────────────────────────────────────────
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );
    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
      ),
    );
    _titleSlide = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.7, curve: Curves.easeOutCubic),
      ),
    );
    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.7, curve: Curves.easeOut),
      ),
    );
    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.55, 0.85, curve: Curves.easeOut),
      ),
    );
    _loaderFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
      ),
    );
    _entranceController.forward();

    // ── Pulse glow ────────────────────────────────────────────
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseScale = Tween<double>(begin: 1.0, end: 1.28).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseOpacity = Tween<double>(begin: 0.55, end: 0.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // ── Orbit ring ────────────────────────────────────────────
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // ── Particles ─────────────────────────────────────────────
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // ── Shimmer ───────────────────────────────────────────────
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _shimmerSlide = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // ── Dots loader ───────────────────────────────────────────
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Auth check
    Future.delayed(const Duration(milliseconds: 4500), () {
      if (mounted) _checkAuthAndNavigate();
    });
  }

  void _generateParticles() {
    final rng = math.Random(42);
    for (int i = 0; i < 18; i++) {
      _particles.add(
        _Particle(
          x: rng.nextDouble(),
          y: rng.nextDouble(),
          radius: rng.nextDouble() * 5 + 2,
          speed: rng.nextDouble() * 0.3 + 0.1,
          phase: rng.nextDouble(),
          opacity: rng.nextDouble() * 0.35 + 0.08,
        ),
      );
    }
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
        default:
          route = '/RoleSelection';
      }
      Navigator.pushNamedAndRemoveUntil(context, route, (r) => false);
    } else {
      Navigator.pushReplacementNamed(context, '/RoleSelection');
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    _orbitController.dispose();
    _particleController.dispose();
    _shimmerController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Rich dark-blue gradient background ──────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0A0E27),
                  Color(0xFF0D1B4B),
                  Color(0xFF0A2558),
                  Color(0xFF061838),
                ],
                stops: [0.0, 0.35, 0.65, 1.0],
              ),
            ),
          ),

          // ── Radial glow behind logo ──────────────────────────
          Positioned.fill(
            child: Align(
              alignment: const Alignment(0, -0.12),
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (_, __) => Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF4F8EF7).withValues(alpha: 0.18),
                        const Color(0xFF1A3A8F).withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Floating particles ───────────────────────────────
          AnimatedBuilder(
            animation: _particleController,
            builder: (_, __) {
              return CustomPaint(
                size: size,
                painter: _ParticlePainter(
                  particles: _particles,
                  progress: _particleController.value,
                ),
              );
            },
          ),

          // ── Top-right decorative arc ─────────────────────────
          Positioned(
            top: -100,
            right: -100,
            child: AnimatedBuilder(
              animation: _orbitController,
              builder: (_, __) => Transform.rotate(
                angle: _orbitController.value * 2 * math.pi * 0.08,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF4F8EF7).withValues(alpha: 0.12),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: -140,
            right: -140,
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF4F8EF7).withValues(alpha: 0.06),
                  width: 1,
                ),
              ),
            ),
          ),

          // ── Bottom-left decorative arc ───────────────────────
          Positioned(
            bottom: -80,
            left: -80,
            child: AnimatedBuilder(
              animation: _orbitController,
              builder: (_, __) => Transform.rotate(
                angle: -_orbitController.value * 2 * math.pi * 0.06,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.1),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Main content ─────────────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Logo with pulse + orbit ──────────────────
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _entranceController,
                    _pulseController,
                    _orbitController,
                  ]),
                  builder: (_, __) {
                    return FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: SizedBox(
                          width: 160,
                          height: 160,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer pulse ring
                              Transform.scale(
                                scale: _pulseScale.value,
                                child: Opacity(
                                  opacity: _pulseOpacity.value,
                                  child: Container(
                                    width: 148,
                                    height: 148,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF4F8EF7),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Orbit dashes ring (rotating)
                              Transform.rotate(
                                angle: _orbitController.value * 2 * math.pi,
                                child: CustomPaint(
                                  size: const Size(140, 140),
                                  painter: _DashedCirclePainter(
                                    color: const Color(
                                      0xFF38BDF8,
                                    ).withValues(alpha: 0.7),
                                    strokeWidth: 1.8,
                                    dashCount: 12,
                                  ),
                                ),
                              ),
                              // 3 orbiting dots
                              ...List.generate(3, (i) {
                                final angle =
                                    _orbitController.value * 2 * math.pi +
                                    (i * 2 * math.pi / 3);
                                return Transform.translate(
                                  offset: Offset(
                                    56 * math.cos(angle),
                                    56 * math.sin(angle),
                                  ),
                                  child: Container(
                                    width: i == 0 ? 10 : 7,
                                    height: i == 0 ? 10 : 7,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: i == 0
                                          ? const Color(0xFF38BDF8)
                                          : const Color(
                                              0xFF4F8EF7,
                                            ).withValues(alpha: 0.7),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF38BDF8,
                                          ).withValues(alpha: 0.8),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              // Inner glow ring
                              Container(
                                width: 108,
                                height: 108,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      const Color(
                                        0xFF4F8EF7,
                                      ).withValues(alpha: 0.25),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              // Logo circle
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF4F8EF7),
                                      Color(0xFF1565C0),
                                      Color(0xFF0D47A1),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF4F8EF7,
                                      ).withValues(alpha: 0.5),
                                      blurRadius: 32,
                                      spreadRadius: 4,
                                      offset: const Offset(0, 8),
                                    ),
                                    BoxShadow(
                                      color: const Color(
                                        0xFF38BDF8,
                                      ).withValues(alpha: 0.3),
                                      blurRadius: 20,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.school_rounded,
                                  size: 52,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 44),

                // ── Title with shimmer ───────────────────────
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _entranceController,
                    _shimmerController,
                  ]),
                  builder: (_, __) {
                    return FadeTransition(
                      opacity: _titleFade,
                      child: Transform.translate(
                        offset: Offset(0, _titleSlide.value),
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: const [
                                Color(0xFFE3F2FD),
                                Colors.white,
                                Color(0xFF90CAF9),
                                Colors.white,
                                Color(0xFFE3F2FD),
                              ],
                              stops: [
                                0.0,
                                (_shimmerSlide.value - 0.4).clamp(0.0, 1.0),
                                _shimmerSlide.value.clamp(0.0, 1.0),
                                (_shimmerSlide.value + 0.4).clamp(0.0, 1.0),
                                1.0,
                              ],
                            ).createShader(bounds);
                          },
                          child: const Text(
                            'EduManage',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 2.5,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

                // ── Tagline ──────────────────────────────────
                FadeTransition(
                  opacity: _subtitleFade,
                  child: Column(
                    children: [
                      // Divider with dots
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 28,
                            height: 1.5,
                            color: const Color(
                              0xFF38BDF8,
                            ).withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF38BDF8),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'SCHOOL MANAGEMENT SYSTEM',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF90CAF9),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 3.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF38BDF8),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 28,
                            height: 1.5,
                            color: const Color(
                              0xFF38BDF8,
                            ).withValues(alpha: 0.5),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Text(
                        'Empowering Education, Simplifying Management',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.55),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 64),

                // ── Animated dots loader ─────────────────────
                FadeTransition(
                  opacity: _loaderFade,
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _dotsController,
                        builder: (_, __) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(4, (i) {
                              final t = (_dotsController.value - i * 0.18)
                                  .clamp(0.0, 1.0);
                              final wave = math.sin(t * math.pi);
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                width: 9 + wave * 3,
                                height: 9 + wave * 3,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.lerp(
                                    const Color(
                                      0xFF4F8EF7,
                                    ).withValues(alpha: 0.4),
                                    const Color(0xFF38BDF8),
                                    wave,
                                  ),
                                  boxShadow: wave > 0.5
                                      ? [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF38BDF8,
                                            ).withValues(alpha: wave * 0.6),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : null,
                                ),
                              );
                            }),
                          );
                        },
                      ),

                      const SizedBox(height: 18),

                      Text(
                        'Preparing your experience...',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.4),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Version badge (bottom center) ────────────────────
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _loaderFade,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                  child: Text(
                    'v1.0.0  •  RUPP Team',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.3),
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Particle model
// ─────────────────────────────────────────────────────────────────────────────
class _Particle {
  final double x;
  final double y;
  final double radius;
  final double speed;
  final double phase;
  final double opacity;

  const _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.phase,
    required this.opacity,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Particle painter
// ─────────────────────────────────────────────────────────────────────────────
class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  const _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (progress * p.speed + p.phase) % 1.0;
      final dy = -t * size.height * 0.55;
      final dx = math.sin(t * math.pi * 2 + p.phase * 6) * 22;
      final opacity = p.opacity * (1 - math.pow(t, 2.0)).toDouble();

      final paint = Paint()
        ..color = const Color(0xFF38BDF8).withValues(alpha: opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(
        Offset(p.x * size.width + dx, p.y * size.height + dy),
        p.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────────────────────────────────────
// Dashed orbit circle painter
// ─────────────────────────────────────────────────────────────────────────────
class _DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int dashCount;

  const _DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final dashAngle = math.pi / dashCount;
    final gapAngle = dashAngle * 0.55;

    for (int i = 0; i < dashCount; i++) {
      final start = i * (dashAngle + gapAngle);
      final end = start + dashAngle;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        end - start,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
