import 'package:flutter/material.dart';
import 'package:memory_sequence/core/app_constants.dart';
import 'package:memory_sequence/screen/home_screen.dart';
import 'package:memory_sequence/services/game_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late AnimationController _particleController;
  late AnimationController _slideController;

  late Animation<double> _pulseAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _slideAnim;
  late Animation<double> _particleAnim;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _pulseAnim = Tween<double>(begin: 0.9, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnim = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );

    _particleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    // Stagger the animations
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });

    // Navigate after splash
    Future.delayed(const Duration(milliseconds: 3200), () async {
      if (mounted) {
        await GameService().init();
        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, a, __) => const HomePage(),
              transitionsBuilder: (_, anim, __, child) => FadeTransition(
                opacity: anim,
                child: child,
              ),
              transitionDuration: const Duration(milliseconds: 600),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _particleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppConstants.kDarkBg,
              AppConstants.kDarkDeepBg,
              AppConstants.kDarkBgDeepViolet,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Floating particles
            AnimatedBuilder(
              animation: _particleAnim,
              builder: (context, _) => CustomPaint(
                painter: _ParticlePainter(_particleAnim.value),
                size: Size.infinite,
              ),
            ),
            // Glow orb behind icon
            Center(
              child: AnimatedBuilder(
                animation: _pulseAnim,
                builder: (context, child) => Container(
                  width: 220 * _pulseAnim.value,
                  height: 220 * _pulseAnim.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppConstants.kPrimary.withValues(alpha: 0.35),
                        AppConstants.kPrimaryDark.withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  // Icon with rings
                  AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (context, _) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer ring
                          Container(
                            width: 160 * _pulseAnim.value,
                            height: 160 * _pulseAnim.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppConstants.kPrimary.withValues(alpha: 0.25),
                                width: 1.5,
                              ),
                            ),
                          ),
                          // Mid ring
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppConstants.kPrimaryLight.withValues(alpha: 0.4),
                                width: 1.5,
                              ),
                            ),
                          ),
                          // Icon container
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [AppConstants.kHeroIconStart, AppConstants.kPrimaryDark],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppConstants.kPrimary
                                      .withValues(alpha: 0.6),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.psychology_rounded,
                              size: 46,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                  // Title
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: AnimatedBuilder(
                      animation: _slideAnim,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, _slideAnim.value),
                        child: child,
                      ),
                      child: const Text(
                        'Memory',
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 2,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: AnimatedBuilder(
                      animation: _slideAnim,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, _slideAnim.value),
                        child: child,
                      ),
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [AppConstants.kPrimaryLight, AppConstants.kPrimary],
                        ).createShader(bounds),
                        child: const Text(
                          'SEQUENCE',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 8,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Text(
                      'Train your cognitive power',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withValues(alpha: 0.5),
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  // Loading dots
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: _LoadingDots(),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final value =
                (((_ctrl.value - delay) % 1.0 + 1.0) % 1.0);
            final opacity = value < 0.5 ? value * 2 : (1 - value) * 2;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppConstants.kPrimary.withValues(alpha: opacity.clamp(0.2, 1.0)),
              ),
            );
          }),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  final List<_Particle> _particles;

  _ParticlePainter(this.progress)
      : _particles = List.generate(30, (i) => _Particle(i));

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final p in _particles) {
      final t = (progress + p.offset) % 1.0;
      final x = p.x * size.width;
      final y = size.height - (t * size.height * 1.2) + p.startY * size.height * 0.2;
      final opacity = t < 0.2
          ? t / 0.2
          : t > 0.8
              ? (1 - t) / 0.2
              : 1.0;
      paint.color = AppConstants.kPrimary.withValues(alpha: opacity * p.alpha);
      canvas.drawCircle(Offset(x, y % size.height), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}

class _Particle {
  final double x;
  final double startY;
  final double offset;
  final double radius;
  final double alpha;

  _Particle(int seed)
      : x = (seed * 37 % 100) / 100,
        startY = (seed * 53 % 100) / 100,
        offset = (seed * 17 % 100) / 100,
        radius = 1.0 + (seed % 3),
        alpha = 0.15 + (seed % 5) * 0.06;
}
