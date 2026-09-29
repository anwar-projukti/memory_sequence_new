import 'dart:math';

import 'package:flutter/material.dart';
import 'package:memory_sequence/core/app_constants.dart';
import 'package:memory_sequence/model/game_category.dart';
import 'package:memory_sequence/screen/memory_phase_screen.dart';
import 'package:memory_sequence/services/game_service.dart';

class CategorySelectScreen extends StatefulWidget {
  const CategorySelectScreen({super.key});

  @override
  State<CategorySelectScreen> createState() => _CategorySelectScreenState();
}

class _CategorySelectScreenState extends State<CategorySelectScreen>
    with TickerProviderStateMixin {
  late AnimationController _staggerCtrl;

  @override
  void initState() {
    super.initState();
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _staggerCtrl.dispose();
    super.dispose();
  }

  void _startGame(GameCategory category) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a, __) => MemoryPhase(category: category),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  void _startRandom() {
    final random = GameCategory.all[Random().nextInt(GameCategory.all.length)];
    _startGame(random);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = GameService().isDarkMode;
    final bgColors = isDark
        ? [AppConstants.kDarkBg, AppConstants.kDarkDeepBg, AppConstants.kDarkBgDeepViolet]
        : [AppConstants.kLightTopBg, AppConstants.kLightMidBg, AppConstants.kLightTopBg];
    final textColor = isDark ? Colors.white : AppConstants.kDarkMidBg;
    final subColor = isDark
        ? Colors.white.withValues(alpha: 0.55)
        : AppConstants.kPrimaryDark.withValues(alpha: 0.7);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: bgColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
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
                          ),
                        ),
                        child: Icon(Icons.arrow_back_rounded,
                            color: textColor, size: 22),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Choose Category',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Pick a theme to challenge your memory',
                          style: TextStyle(fontSize: 12, color: subColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Random play banner ─────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _RandomBanner(isDark: isDark, onTap: _startRandom),
              ),
              const SizedBox(height: 20),

              // ── Category grid ─────────────────────────────
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: GameCategory.all.length,
                  itemBuilder: (context, index) {
                    final category = GameCategory.all[index];
                    final delay = (index * 0.07).clamp(0.0, 0.9);
                    return _CategoryCard(
                      category: category,
                      isDark: isDark,
                      controller: _staggerCtrl,
                      delay: delay,
                      onTap: () => _startGame(category),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// Random banner
// ──────────────────────────────────────────────────────
class _RandomBanner extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;

  const _RandomBanner({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppConstants.kPrimary, AppConstants.kPrimaryDark],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppConstants.kPrimary.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppConstants.kCatBannerIconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text('🎲', style: TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Random Category',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Surprise me — pick any category',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppConstants.kCatBannerIconBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shuffle_rounded,
                  color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// Category card
// ──────────────────────────────────────────────────────
class _CategoryCard extends StatefulWidget {
  final GameCategory category;
  final bool isDark;
  final AnimationController controller;
  final double delay;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.isDark,
    required this.controller,
    required this.delay,
    required this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _pressScale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _pressScale = Tween<double>(begin: 1.0, end: 0.94)
        .animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final start = widget.delay;
    final end = (widget.delay + 0.45).clamp(0.0, 1.0);

    final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
    final slideAnim = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (_, child) => Opacity(
        opacity: fadeAnim.value,
        child: Transform.translate(
          offset: Offset(0, slideAnim.value),
          child: child,
        ),
      ),
      child: GestureDetector(
        onTapDown: (_) => _pressCtrl.forward(),
        onTapUp: (_) {
          _pressCtrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _pressCtrl.reverse(),
        child: AnimatedBuilder(
          animation: _pressScale,
          builder: (_, child) =>
              Transform.scale(scale: _pressScale.value, child: child),
          child: Container(
            decoration: BoxDecoration(
              color: widget.isDark
                  ? widget.category.themeColor.withValues(alpha: 0.14)
                  : widget.category.themeColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: widget.category.themeColor.withValues(alpha: widget.isDark ? 0.35 : 0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.category.themeColor
                      .withValues(alpha: widget.isDark ? 0.20 : 0.10),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Emoji icon bubble
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.category.themeColor.withValues(alpha: 0.9),
                        widget.category.themeColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: widget.category.themeColor.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.category.icon,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.category.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: widget.isDark ? Colors.white : AppConstants.kDarkMidBg,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: widget.category.themeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${AppConstants.kSequenceLength} items',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: widget.category.themeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
