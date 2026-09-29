import 'package:flutter/material.dart';
import 'package:memory_sequence/core/app_constants.dart';
import 'package:memory_sequence/screen/category_select_screen.dart';
import 'package:memory_sequence/screen/how_to_play_screen.dart';
import 'package:memory_sequence/screen/leaderboard_screen.dart';
import 'package:memory_sequence/screen/settings_screen.dart';
import 'package:memory_sequence/services/game_service.dart';
import 'package:memory_sequence/widgets/banner_ad_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _service = GameService();
  late AnimationController _iconCtrl;
  late AnimationController _staggerCtrl;
  late Animation<double> _iconScale;
  late Animation<double> _iconGlow;

  @override
  void initState() {
    super.initState();

    _iconCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _iconScale = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _iconCtrl, curve: Curves.easeInOut),
    );
    _iconGlow = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _iconCtrl, curve: Curves.easeInOut),
    );

  }

  @override
  void dispose() {
    _iconCtrl.dispose();
    _staggerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _service,
      builder: (context, _) {
        final isDark = _service.isDarkMode;
        final bgColors = isDark
            ? [AppConstants.kDarkBg, AppConstants.kDarkDeepBg, AppConstants.kDarkBgDeepViolet]
            : [AppConstants.kLightTopBg, AppConstants.kLightMidBg, AppConstants.kLightTopBg];

        final textColor = isDark ? Colors.white : AppConstants.kDarkMidBg;
        final subColor = isDark
            ? Colors.white.withValues(alpha: 0.55)
            : AppConstants.kPrimaryDark.withValues(alpha: 0.7);

        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: bgColors,
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        // Top bar with settings icon
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Dark mode quick toggle
                              _TopBarButton(
                                isDark: isDark,
                                icon: isDark
                                    ? Icons.light_mode_rounded
                                    : Icons.dark_mode_rounded,
                                onTap: () => _service.toggleDarkMode(),
                              ),
                              // Leaderboard shortcut
                              _TopBarButton(
                                isDark: isDark,
                                icon: Icons.leaderboard_rounded,
                                onTap: () => Navigator.push(
                                  context,
                                  _slideRoute(const LeaderboardScreen()),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(flex: 2),
                        // Glowing brain icon
                        AnimatedBuilder(
                          animation: _iconCtrl,
                          builder: (context, _) => Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer glow
                              Container(
                                width: 180 * _iconScale.value,
                                height: 180 * _iconScale.value,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      AppConstants.kPrimary
                                          .withValues(alpha: 0.3 * _iconGlow.value),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              // Ring
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppConstants.kPrimaryLight
                                        .withValues(alpha: 0.35 * _iconGlow.value),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              // Icon
                              Container(
                                width: 96,
                                height: 96,
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
                                          .withValues(alpha: 0.55 * _iconGlow.value),
                                      blurRadius: 28,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.psychology_rounded,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Title
                        _FadeSlide(
                          controller: _staggerCtrl,
                          delay: 0.0,
                          child: Text(
                            'Memory',
                            style: TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.w900,
                              color: textColor,
                              height: 1.0,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        _FadeSlide(
                          controller: _staggerCtrl,
                          delay: 0.1,
                          child: ShaderMask(
                            shaderCallback: (bounds) =>
                                AppConstants.kPrimaryTextGradient.createShader(bounds),
                            child: const Text(
                              'SEQUENCE',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 7,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _FadeSlide(
                          controller: _staggerCtrl,
                          delay: 0.15,
                          child: Text(
                            'Train your cognitive power',
                            style: TextStyle(
                              fontSize: 14,
                              color: subColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Best score card
                        _FadeSlide(
                          controller: _staggerCtrl,
                          delay: 0.25,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 36),
                            child: _BestScoreCard(
                                isDark: isDark, bestScore: _service.bestScore),
                          ),
                        ),
                        const Spacer(flex: 2),
                        // Buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: Column(
                            children: [
                              _FadeSlide(
                                controller: _staggerCtrl,
                                delay: 0.35,
                                child: _PrimaryButton(
                                  isDark: isDark,
                                  label: 'Play Now',
                                  icon: Icons.play_arrow_rounded,
                                  gradient: AppConstants.kPrimaryGradient,
                                  onTap: () => Navigator.push(
                                    context,
                                    _slideRoute(const CategorySelectScreen()),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              _FadeSlide(
                                controller: _staggerCtrl,
                                delay: 0.45,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _SecondaryButton(
                                        isDark: isDark,
                                        label: 'Leaderboard',
                                        icon: Icons.leaderboard_rounded,
                                        onTap: () => Navigator.push(
                                          context,
                                          _slideRoute(const LeaderboardScreen()),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _SecondaryButton(
                                        isDark: isDark,
                                        label: 'Settings',
                                        icon: Icons.settings_rounded,
                                        onTap: () => Navigator.push(
                                          context,
                                          _slideRoute(const SettingsScreen()),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              _FadeSlide(
                                controller: _staggerCtrl,
                                delay: 0.55,
                                child: _SecondaryButton(
                                  isDark: isDark,
                                  label: 'How to Play',
                                  icon: Icons.help_outline_rounded,
                                  onTap: () => Navigator.push(
                                    context,
                                    _slideRoute(const HowToPlayScreen()),
                                  ),
                                  fullWidth: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              // ── Banner Ad at bottom ──────────────────────
              SafeArea(
                top: false,
                child: Container(
                  color: isDark ? AppConstants.kDarkBg : AppConstants.kLightBg,
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: const BannerAdWidget(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  PageRouteBuilder _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, a, __) => page,
      transitionsBuilder: (_, anim, __, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}

class _TopBarButton extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final VoidCallback onTap;

  const _TopBarButton({
    required this.isDark,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDark
              ? AppConstants.kCatBackBtnDark
              : AppConstants.kCatBackBtnLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? AppConstants.kCatBackBorderDark
                : AppConstants.kCatBackBorderLight,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: isDark ? AppConstants.kHomeTopBarIconDark : AppConstants.kPrimaryDark,
          size: 22,
        ),
      ),
    );
  }
}

class _BestScoreCard extends StatelessWidget {
  final bool isDark;
  final int bestScore;

  const _BestScoreCard({required this.isDark, required this.bestScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: isDark
            ? AppConstants.kHomeBestCardDark
            : AppConstants.kHomeBestCardLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppConstants.kHomeBestCardBorderDark
              : AppConstants.kPrimary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.kPrimary
                .withValues(alpha: isDark ? 0.12 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('⭐', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Text(
            'Best Score',
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppConstants.kHomeBestLabelDark
                  : AppConstants.kHomeBestLabelLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          ShaderMask(
            shaderCallback: (bounds) =>
                AppConstants.kPrimaryTextGradient.createShader(bounds),
            child: Text(
              '$bestScore / ${AppConstants.kSequenceLength}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final bool isDark;
  final String label;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.isDark,
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppConstants.kPrimary.withValues(alpha: 0.45),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: Colors.white, size: 26),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatefulWidget {
  final bool isDark;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool fullWidth;

  const _SecondaryButton({
    required this.isDark,
    required this.label,
    required this.icon,
    required this.onTap,
    this.fullWidth = false,
  });

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(
          scale: _scale.value,
          child: child,
        ),
        child: Container(
          height: 56,
          width: widget.fullWidth ? double.infinity : null,
          decoration: BoxDecoration(
            color: widget.isDark
                ? AppConstants.kHomeSecBtnDark
                : AppConstants.kHomeSecBtnLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isDark
                  ? AppConstants.kHomeSecBtnBorderDark
                  : AppConstants.kPrimary.withValues(alpha: 0.25),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isDark
                    ? AppConstants.kHomeSecBtnShadowDark
                    : AppConstants.kHomeSecBtnShadowLight,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: widget.fullWidth
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      color: AppConstants.kPrimary,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: widget.isDark
                            ? AppConstants.kHomeSecBtnTextDark
                            : AppConstants.kPrimaryDeepest,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      color: AppConstants.kPrimary,
                      size: 22,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: widget.isDark
                            ? AppConstants.kHomeSecBtnTextDark
                            : AppConstants.kPrimaryDeepest,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _FadeSlide extends StatelessWidget {
  final AnimationController controller;
  final double delay;
  final Widget child;

  const _FadeSlide({
    required this.controller,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final start = delay;
    final end = (delay + 0.5).clamp(0.0, 1.0);

    final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );

    final slideAnim = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Opacity(
        opacity: fadeAnim.value,
        child: Transform.translate(
          offset: Offset(0, slideAnim.value),
          child: child,
        ),
      ),
    );
  }
}
