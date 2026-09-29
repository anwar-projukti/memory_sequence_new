import 'package:flutter/material.dart';
import 'package:memory_sequence/core/app_constants.dart';
import 'package:memory_sequence/services/game_service.dart';

class HowToPlayScreen extends StatefulWidget {
  const HowToPlayScreen({super.key});

  @override
  State<HowToPlayScreen> createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerCtrl;
  late AnimationController _staggerCtrl;
  late Animation<double> _headerScale;
  late Animation<double> _headerGlow;

  @override
  void initState() {
    super.initState();

    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _headerScale = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _headerCtrl, curve: Curves.easeInOut),
    );
    _headerGlow = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _headerCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _staggerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = GameService().isDarkMode;
    final bgColors = isDark
        ? [
            AppConstants.kDarkBg,
            AppConstants.kDarkDeepBg,
            AppConstants.kDarkBgDeepViolet,
          ]
        : [
            AppConstants.kLightTopBg,
            AppConstants.kLightMidBg,
            AppConstants.kLightTopBg,
          ];

    final textColor = isDark ? Colors.white : AppConstants.kDarkMidBg;
    final subColor = isDark
        ? Colors.white.withValues(alpha: 0.55)
        : AppConstants.kPrimaryDark.withValues(alpha: 0.7);
    final cardBg = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.white.withValues(alpha: 0.75);
    final cardBorder = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : AppConstants.kPrimary.withValues(alpha: 0.15);

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
            children: [
              // ── AppBar ──────────────────────────────────
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
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.black.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.10)
                                : Colors.black.withValues(alpha: 0.08),
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
                          'How to Play',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Master memory in 3 simple steps',
                          style: TextStyle(fontSize: 12, color: subColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Scrollable content ───────────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  child: Column(
                    children: [
                      // Hero brain illustration
                      _FadeSlide(
                        controller: _staggerCtrl,
                        delay: 0.0,
                        child: _HeroBanner(
                          headerCtrl: _headerCtrl,
                          headerScale: _headerScale,
                          headerGlow: _headerGlow,
                          isDark: isDark,
                          textColor: textColor,
                          subColor: subColor,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Step cards
                      _FadeSlide(
                        controller: _staggerCtrl,
                        delay: 0.15,
                        child: _StepCard(
                          step: 1,
                          emoji: '🎯',
                          title: 'Pick a Category',
                          description:
                              'Choose from Animals, Fruits, Vehicles, Flags, Sports and many more themes — or hit Random for a surprise challenge!',
                          accentColor: AppConstants.kPrimary,
                          isDark: isDark,
                          cardBg: cardBg,
                          cardBorder: cardBorder,
                          textColor: textColor,
                          subColor: subColor,
                        ),
                      ),

                      const SizedBox(height: 14),

                      _FadeSlide(
                        controller: _staggerCtrl,
                        delay: 0.25,
                        child: _StepCard(
                          step: 2,
                          emoji: '👁️',
                          title: 'Memorize the Sequence',
                          description:
                              'A grid of ${AppConstants.kSequenceLength} items appears with numbered positions. Study the order carefully — you have only ${AppConstants.kMemoryTimerSeconds} seconds before the challenge begins!',
                          accentColor: AppConstants.kStep2Accent,
                          isDark: isDark,
                          cardBg: cardBg,
                          cardBorder: cardBorder,
                          textColor: textColor,
                          subColor: subColor,
                        ),
                      ),

                      const SizedBox(height: 14),

                      _FadeSlide(
                        controller: _staggerCtrl,
                        delay: 0.35,
                        child: _StepCard(
                          step: 3,
                          emoji: '🧠',
                          title: 'Recall the Order',
                          description:
                              'Tap the items in the exact same order you memorized them. Each correct tap scores a point — get all ${AppConstants.kSequenceLength} right for a perfect score!',
                          accentColor: AppConstants.kPrimaryDark,
                          isDark: isDark,
                          cardBg: cardBg,
                          cardBorder: cardBorder,
                          textColor: textColor,
                          subColor: subColor,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Tips & tricks section
                      _FadeSlide(
                        controller: _staggerCtrl,
                        delay: 0.45,
                        child: _TipsSection(
                          isDark: isDark,
                          textColor: textColor,
                          subColor: subColor,
                          cardBg: cardBg,
                          cardBorder: cardBorder,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Scoring section
                      _FadeSlide(
                        controller: _staggerCtrl,
                        delay: 0.55,
                        child: _ScoringSection(
                          isDark: isDark,
                          textColor: textColor,
                          subColor: subColor,
                          cardBg: cardBg,
                          cardBorder: cardBorder,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Hero banner with animated brain icon
// ─────────────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  final AnimationController headerCtrl;
  final Animation<double> headerScale;
  final Animation<double> headerGlow;
  final bool isDark;
  final Color textColor;
  final Color subColor;

  const _HeroBanner({
    required this.headerCtrl,
    required this.headerScale,
    required this.headerGlow,
    required this.isDark,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppConstants.kPrimary.withValues(alpha: 0.18),
                  AppConstants.kPrimaryDark.withValues(alpha: 0.10),
                ]
              : [
                  AppConstants.kPrimary.withValues(alpha: 0.10),
                  AppConstants.kPrimaryLight.withValues(alpha: 0.15),
                ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppConstants.kPrimary.withValues(alpha: isDark ? 0.30 : 0.20),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Animated brain icon
          AnimatedBuilder(
            animation: headerCtrl,
            builder: (context, _) => Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ring
                Container(
                  width: 140 * headerScale.value,
                  height: 140 * headerScale.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppConstants.kPrimary
                            .withValues(alpha: 0.25 * headerGlow.value),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Inner ring
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppConstants.kPrimaryLight
                          .withValues(alpha: 0.35 * headerGlow.value),
                      width: 1.5,
                    ),
                  ),
                ),
                // Icon bubble
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppConstants.kHeroIconStart,
                        AppConstants.kPrimaryDark,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.kPrimary
                            .withValues(alpha: 0.55 * headerGlow.value),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
                    size: 38,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Train Your Memory',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: textColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Memory Sequence challenges you to recall\nthe exact order of items. The more you play,\nthe sharper your mind becomes!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: subColor,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Individual step card
// ─────────────────────────────────────────────────────
class _StepCard extends StatelessWidget {
  final int step;
  final String emoji;
  final String title;
  final String description;
  final Color accentColor;
  final bool isDark;
  final Color cardBg;
  final Color cardBorder;
  final Color textColor;
  final Color subColor;

  const _StepCard({
    required this.step,
    required this.emoji,
    required this.title,
    required this.description,
    required this.accentColor,
    required this.isDark,
    required this.cardBg,
    required this.cardBorder,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: isDark ? 0.12 : 0.07),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number badge + emoji
          Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accentColor.withValues(alpha: 0.9),
                      accentColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'STEP $step',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 18),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: subColor,
                    height: 1.5,
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

// ─────────────────────────────────────────────────────
// Tips & Tricks section
// ─────────────────────────────────────────────────────
class _TipsSection extends StatelessWidget {
  final bool isDark;
  final Color textColor;
  final Color subColor;
  final Color cardBg;
  final Color cardBorder;

  const _TipsSection({
    required this.isDark,
    required this.textColor,
    required this.subColor,
    required this.cardBg,
    required this.cardBorder,
  });

  @override
  Widget build(BuildContext context) {
    final tips = [
      ('💡', 'Group items into chunks', 'Try to group 2–3 items together to make them easier to remember.'),
      ('🔢', 'Use numbered positions', 'Each item shows its position number — use it as a mental hook.'),
      ('🔄', 'Repeat out loud', 'Silently saying the order in your head reinforces memory.'),
      ('⏱️', 'Don\'t rush', 'You have ${AppConstants.kMemoryTimerSeconds} seconds — spend a few extra seconds at the start for a solid mental picture.'),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppConstants.kPrimary.withValues(alpha: isDark ? 0.10 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.kPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.lightbulb_rounded,
                  color: AppConstants.kPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Pro Tips',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tip.$1, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip.$2,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tip.$3,
                          style: TextStyle(
                            fontSize: 12,
                            color: subColor,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Scoring section
// ─────────────────────────────────────────────────────
class _ScoringSection extends StatelessWidget {
  final bool isDark;
  final Color textColor;
  final Color subColor;
  final Color cardBg;
  final Color cardBorder;

  const _ScoringSection({
    required this.isDark,
    required this.textColor,
    required this.subColor,
    required this.cardBg,
    required this.cardBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.kPrimary.withValues(alpha: isDark ? 0.18 : 0.08),
            AppConstants.kPrimaryDark.withValues(alpha: isDark ? 0.10 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppConstants.kPrimary.withValues(alpha: isDark ? 0.30 : 0.18),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.kPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: AppConstants.kPrimaryLight,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Scoring',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ScoreRow(
            emoji: '⭐',
            label: '1–${(AppConstants.kSequenceLength * 0.375).floor()} correct',
            badge: 'Keep Trying',
            badgeColor: AppConstants.kScoreBadgeRed,
            isDark: isDark,
            textColor: textColor,
            subColor: subColor,
          ),
          const SizedBox(height: 10),
          _ScoreRow(
            emoji: '⭐⭐',
            label: '${(AppConstants.kSequenceLength * 0.375).floor() + 1}–${(AppConstants.kSequenceLength * 0.75).floor()} correct',
            badge: 'Good Memory',
            badgeColor: AppConstants.kScoreBadgeAmber,
            isDark: isDark,
            textColor: textColor,
            subColor: subColor,
          ),
          const SizedBox(height: 10),
          _ScoreRow(
            emoji: '⭐⭐⭐',
            label: '${(AppConstants.kSequenceLength * 0.75).floor() + 1}–${AppConstants.kSequenceLength - 1} correct',
            badge: 'Great Job!',
            badgeColor: AppConstants.kScoreBadgeGreen,
            isDark: isDark,
            textColor: textColor,
            subColor: subColor,
          ),
          const SizedBox(height: 10),
          _ScoreRow(
            emoji: '🏆',
            label: '${AppConstants.kSequenceLength} / ${AppConstants.kSequenceLength} correct',
            badge: 'Perfect!',
            badgeColor: AppConstants.kPrimary,
            isDark: isDark,
            textColor: textColor,
            subColor: subColor,
          ),
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String badge;
  final Color badgeColor;
  final bool isDark;
  final Color textColor;
  final Color subColor;

  const _ScoreRow({
    required this.emoji,
    required this.label,
    required this.badge,
    required this.badgeColor,
    required this.isDark,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(emoji, style: const TextStyle(fontSize: 16)),
        ),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: badgeColor.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: badgeColor.withValues(alpha: 0.35), width: 1),
          ),
          child: Text(
            badge,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: badgeColor,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────
// Fade + slide entrance animation
// ─────────────────────────────────────────────────────
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
    final slideAnim = Tween<double>(begin: 24.0, end: 0.0).animate(
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
