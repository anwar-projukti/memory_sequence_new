import 'package:flutter/material.dart';
import 'package:memory_sequence/core/app_constants.dart';
import 'package:memory_sequence/screen/home_screen.dart';
import 'package:memory_sequence/screen/category_select_screen.dart';
import 'package:memory_sequence/model/image_data.dart';
import 'package:memory_sequence/services/ad_service.dart';
import 'package:memory_sequence/services/game_service.dart';
import 'package:memory_sequence/widgets/banner_ad_widget.dart';

class ResultScreen extends StatefulWidget {
  final int correctMatches;
  final int totalImages;
  final List<ImageData> userSequence;
  final List<ImageData> correctSequence;

  const ResultScreen({
    super.key,
    required this.correctMatches,
    required this.totalImages,
    required this.userSequence,
    required this.correctSequence,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  bool? _isNewBest;
  bool _saving = true;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fade = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _scale = Tween<double>(begin: 0.88, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));

    _ctrl.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _saveScore();
    });
  }

  Future<void> _saveScore() async {
    final name = await _askPlayerName();
    if (!mounted) return;
    final isNew = await GameService().saveScore(
      playerName: name,
      score: widget.correctMatches,
      totalImages: widget.totalImages,
    );
    if (mounted) {
      setState(() {
        _isNewBest = isNew;
        _saving = false;
      });
      // Show interstitial after score is saved
      AdService().showInterstitial();
    }
  }

  Future<String> _askPlayerName() async {
    final isDark = GameService().isDarkMode;
    final controller = TextEditingController(text: 'Player');
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      barrierColor: AppConstants.kResultBarrierColor,
      builder: (ctx) {
        final bg = isDark ? AppConstants.kDarkMidBg : Colors.white;
        final textColor = isDark ? Colors.white : AppConstants.kDarkMidBg;
        final subColor = isDark ? AppConstants.kResultSubDark : AppConstants.kResultSubLight;

        return Dialog(
          backgroundColor: bg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🏆', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                Text(
                  'Game Complete!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Enter your name for the leaderboard',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: subColor),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  autofocus: true,
                  maxLength: 20,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    final name = value.trim();
                    Navigator.pop(ctx, name.isEmpty ? 'Player' : name);
                  },
                  style:
                      TextStyle(color: textColor, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Your name',
                    hintStyle: TextStyle(color: subColor),
                    filled: true,
                    fillColor: isDark
                        ? AppConstants.kResultFieldFillDark
                        : AppConstants.kResultFieldFillLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final name = controller.text.trim();
                      Navigator.pop(ctx, name.isEmpty ? 'Player' : name);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.kPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save Score',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return result ?? 'Player';
  }

  // Rewarded ad: user watches ad and gets to see correct sequence animation
  void _watchAdForHint() {
    final isDark = GameService().isDarkMode;
    if (!AdService().isRewardedReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Ad not ready yet, try again shortly.'),
          backgroundColor:
              isDark ? AppConstants.kDarkMidBg : AppConstants.kPrimary,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    AdService().showRewarded(
      onRewarded: () {
        if (!mounted) return;
        _showCorrectSequenceDialog(isDark);
      },
    );
  }

  void _showCorrectSequenceDialog(bool isDark) {
    final bg = isDark ? AppConstants.kDarkMidBg : Colors.white;
    final textColor = isDark ? Colors.white : AppConstants.kDarkMidBg;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎁', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 12),
              Text(
                'Correct Sequence',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textColor),
              ),
              const SizedBox(height: 16),
              _sequenceGrid(widget.correctSequence, null, isDark, bg),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.kPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: const Text('Close',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String get _memoryLevel {
    final p = (widget.correctMatches / widget.totalImages) * 100;
    if (p == 100) return 'Perfect Memory!';
    if (p >= 75) return 'Excellent';
    if (p >= 50) return 'Good Job';
    if (p >= 25) return 'Fair';
    return 'Keep Practicing';
  }

  String get _emoji {
    final p = (widget.correctMatches / widget.totalImages) * 100;
    if (p == 100) return '🏆';
    if (p >= 75) return '🌟';
    if (p >= 50) return '👍';
    if (p >= 25) return '💪';
    return '🎯';
  }

  Color get _levelColor {
    final p = (widget.correctMatches / widget.totalImages) * 100;
    if (p >= 75) return AppConstants.kSuccess;
    if (p >= 50) return AppConstants.kWarning;
    return AppConstants.kError;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = GameService().isDarkMode;
    final bg = isDark ? AppConstants.kDarkBg : AppConstants.kLightBg;
    final cardBg = isDark ? AppConstants.kDarkMidBg : Colors.white;
    final textColor = isDark ? Colors.white : AppConstants.kDarkMidBg;
    final subColor = isDark ? AppConstants.kResultSubDark : AppConstants.kResultSubLight;
    final percentage = (widget.correctMatches / widget.totalImages) * 100;

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [AppConstants.kDarkDeepBg, AppConstants.kDarkBg]
                      : [AppConstants.kLightTopBg, AppConstants.kLbGradientLightEnd],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: _saving
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppConstants.kPrimary,
                        ),
                      )
                    : FadeTransition(
                        opacity: _fade,
                        child: ScaleTransition(
                          scale: _scale,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            child: Column(
                              children: [
                                // Header
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.of(context)
                                          .popUntil((r) => r.isFirst),
                                      child: Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? AppConstants.kCatBackBtnDark
                                              : AppConstants.kCatBackBtnLight,
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Icon(Icons.home_rounded,
                                            color: textColor, size: 22),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Result',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: textColor,
                                      ),
                                    ),
                                    const Spacer(),
                                    const SizedBox(width: 44),
                                  ],
                                ),
                                const SizedBox(height: 28),
                                // Score hero card
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 28, horizontal: 24),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _levelColor.withValues(alpha: isDark ? 0.25 : 0.12),
                                        blurRadius: 28,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Text(_emoji,
                                              style: const TextStyle(
                                                  fontSize: 64)),
                                          if (_isNewBest == true)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                gradient:
                                                    const LinearGradient(
                                                  colors: [
                                                    AppConstants.kRankGold,
                                                    AppConstants.kRankGoldDark,
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppConstants.kRankGold
                                                        .withValues(alpha: 0.4),
                                                    blurRadius: 8,
                                                    offset:
                                                        const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.star_rounded,
                                                      color: Colors.white,
                                                      size: 14),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    'NEW BEST!',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        _memoryLevel,
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w800,
                                          color: _levelColor,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${widget.correctMatches}',
                                            style: TextStyle(
                                              fontSize: 60,
                                              fontWeight: FontWeight.w900,
                                              color: _levelColor,
                                              height: 1,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Text(
                                              ' / ${widget.totalImages}',
                                              style: TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.w500,
                                                color: subColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      // Progress bar
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(6),
                                        child: LinearProgressIndicator(
                                          value: percentage / 100,
                                          backgroundColor:
                                              _levelColor.withValues(alpha: 0.12),
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  _levelColor),
                                          minHeight: 8,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${percentage.toInt()}% Accuracy',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: subColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Sequence comparison
                                Container(
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isDark
                                            ? AppConstants.kResultCardShadowDark
                                            : AppConstants.kResultCardShadowLight,
                                        blurRadius: 16,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.compare_arrows_rounded,
                                              color: subColor, size: 18),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Sequence Comparison',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      Text('Correct:',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: subColor,
                                              fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 8),
                                      _sequenceGrid(
                                          widget.correctSequence,
                                          null,
                                          isDark,
                                          cardBg),
                                      const SizedBox(height: 12),
                                      Text('Your Answer:',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: subColor,
                                              fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 8),
                                      _sequenceGrid(
                                          widget.userSequence,
                                          widget.correctSequence,
                                          isDark,
                                          cardBg),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Rewarded Ad hint button
                                _RewardedHintButton(
                                  isDark: isDark,
                                  onTap: _watchAdForHint,
                                ),
                                const SizedBox(height: 14),
                                // Action buttons
                                Row(
                                  children: [
                                    Expanded(
                                      child: _ActionButton(
                                        isDark: isDark,
                                        label: 'Play Again',
                                        icon: Icons.refresh_rounded,
                                        gradient: const LinearGradient(
                                          colors: [
                                            AppConstants.kPrimary,
                                            AppConstants.kPrimaryDark
                                          ],
                                        ),
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const CategorySelectScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _ActionButton(
                                        isDark: isDark,
                                        label: 'Home',
                                        icon: Icons.home_rounded,
                                        isOutlined: true,
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                              builder: (_) => const HomePage(),
                                            ),
                                            (route) => false,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
          // ── Banner Ad ────────────────────────────────
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
  }

  Widget _sequenceGrid(
    List<ImageData> sequence,
    List<ImageData>? compareWith,
    bool isDark,
    Color cardBg,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1,
      ),
      itemCount: AppConstants.kSequenceLength,
      itemBuilder: (context, index) {
        if (index >= sequence.length) return const SizedBox();
        final item = sequence[index];
        final isCorrect = compareWith == null ||
            (index < compareWith.length &&
                item.originalIndex == compareWith[index].originalIndex);

        return Container(
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(10),
            border: compareWith != null
                ? Border.all(
                    color: isCorrect
                        ? AppConstants.kSuccess
                        : AppConstants.kError,
                    width: 2,
                  )
                : null,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: item.isEmoji
                    ? Text(item.emoji!, style: const TextStyle(fontSize: 28))
                    : Padding(
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(item.imagePath!, fit: BoxFit.contain),
                      ),
              ),
              Positioned(
                bottom: 3,
                right: 3,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: item.color,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (compareWith != null)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: isCorrect
                          ? AppConstants.kSuccess
                          : AppConstants.kError,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCorrect
                          ? Icons.check_rounded
                          : Icons.close_rounded,
                      color: Colors.white,
                      size: 9,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ──────────────────────────────────────────────────────
// Rewarded hint button
// ──────────────────────────────────────────────────────
class _RewardedHintButton extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;

  const _RewardedHintButton({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          gradient: AppConstants.kRewardedGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppConstants.kRewardedStart.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle_fill_rounded,
                color: Colors.white, size: 22),
            const SizedBox(width: 10),
            const Flexible(
              child: Text(
                'Watch Ad → View Correct Sequence',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// Action button
// ──────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final bool isDark;
  final String label;
  final IconData icon;
  final LinearGradient? gradient;
  final bool isOutlined;
  final VoidCallback onTap;

  const _ActionButton({
    required this.isDark,
    required this.label,
    required this.icon,
    this.gradient,
    this.isOutlined = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final subColor = isDark ? AppConstants.kResultActionSubDark : AppConstants.kResultActionSubLight;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          gradient: isOutlined ? null : gradient,
          borderRadius: BorderRadius.circular(16),
          border: isOutlined
              ? Border.all(
                  color: isDark
                      ? AppConstants.kResultOutlineBorderDark
                      : AppConstants.kResultOutlineBorderLight,
                  width: 1.5,
                )
              : null,
          color: isOutlined
              ? (isDark
                  ? AppConstants.kResultOutlineFillDark
                  : Colors.white)
              : null,
          boxShadow: isOutlined
              ? []
              : [
                  BoxShadow(
                    color: AppConstants.kPrimary.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isOutlined ? subColor : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isOutlined ? subColor : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}