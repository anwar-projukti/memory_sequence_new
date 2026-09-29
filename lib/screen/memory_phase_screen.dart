import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memory_sequence/core/app_constants.dart';
import 'package:memory_sequence/model/game_category.dart';
import 'package:memory_sequence/model/image_data.dart';
import 'package:memory_sequence/screen/recall_phase_screen.dart';
import 'package:memory_sequence/services/game_service.dart';
import 'package:memory_sequence/widgets/game_dialogs.dart';

class MemoryPhase extends StatefulWidget {
  final GameCategory? category;
  const MemoryPhase({super.key, this.category});

  @override
  State<MemoryPhase> createState() => _MemoryPhaseState();
}

class _MemoryPhaseState extends State<MemoryPhase> {
  late List<ImageData> imageSequence;
  int countdown = AppConstants.kMemoryTimerSeconds;
  Timer? timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    final cat = widget.category ?? GameCategory.all.first;
    imageSequence = cat.buildImageSequence();
    startCountdown();
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_isPaused) return;
      if (countdown > 0) {
        setState(() => countdown--);
      } else {
        t.cancel();
        navigateToRecallPhase();
      }
    });
  }

  void _togglePause() {
    setState(() => _isPaused = !_isPaused);
    if (_isPaused) _showPauseDialog();
  }

  void _showPauseDialog() {
    final isDark = GameService().isDarkMode;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (ctx) => PauseDialog(
        isDark: isDark,
        onResume: () {
          Navigator.pop(ctx);
          setState(() => _isPaused = false);
        },
        onQuit: () {
          Navigator.pop(ctx);
          _doQuit();
        },
      ),
    );
  }

  void _doQuit() {
    final isDark = GameService().isDarkMode;
    showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (ctx) => QuitDialog(
        isDark: isDark,
        onConfirm: () => Navigator.pop(ctx, true),
        onCancel: () => Navigator.pop(ctx, false),
      ),
    ).then((confirmed) {
      if (!mounted) return;
      if (confirmed == true) {
        timer?.cancel();
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        setState(() => _isPaused = false);
      }
    });
  }

  void _onCloseButton() {
    _isPaused = true;
    timer?.cancel();
    final isDark = GameService().isDarkMode;
    showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (ctx) => QuitDialog(
        isDark: isDark,
        onConfirm: () => Navigator.pop(ctx, true),
        onCancel: () => Navigator.pop(ctx, false),
      ),
    ).then((confirmed) {
      if (!mounted) return;
      if (confirmed == true) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        // Resume: restart a fresh timer continuing from current countdown value
        setState(() => _isPaused = false);
        startCountdown();
      }
    });
  }

  void navigateToRecallPhase() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RecallPhase(correctSequence: imageSequence),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  /// Renders either an emoji or an asset image inside the card.
  Widget _buildTileContent(ImageData item) {
    if (item.isEmoji) {
      return Center(
        child: Text(
          item.emoji!,
          style: const TextStyle(fontSize: 38),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Image.asset(item.imagePath!, fit: BoxFit.contain),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = GameService().isDarkMode;
    final bg = isDark ? AppConstants.kDarkBg : AppConstants.kLightBg;
    final cardBg = isDark ? AppConstants.kDarkMidBg : Colors.white;
    final textColor = isDark ? Colors.white : AppConstants.kDarkMidBg;
    final subColor = isDark ? Colors.white60 : Colors.black54;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? AppConstants.kDarkDeepBg : Colors.white,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Memorize',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: textColor,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: textColor),
          onPressed: _onCloseButton,
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isPaused
                  ? Icons.play_circle_rounded
                  : Icons.pause_circle_rounded,
              color: AppConstants.kPrimary,
              size: 30,
            ),
            onPressed: _togglePause,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Timer section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cardBg,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppConstants.kPrimary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.remove_red_eye_rounded,
                          color: AppConstants.kPrimary, size: 24),
                    ),
                    const SizedBox(width: 14),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _isPaused ? '⏸' : '$countdown',
                        key: ValueKey(_isPaused ? 'paused' : countdown),
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: countdown <= AppConstants.kMemoryWarningThreshold && !_isPaused
                              ? AppConstants.kError
                              : AppConstants.kPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (!_isPaused)
                      Text(
                        'sec',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: subColor,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: countdown / AppConstants.kMemoryTimerSeconds,
                    backgroundColor:
                        AppConstants.kPrimary.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      countdown <= AppConstants.kMemoryWarningThreshold
                          ? AppConstants.kError
                          : AppConstants.kPrimary,
                    ),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 16, color: subColor),
                const SizedBox(width: 6),
                Text(
                  'Remember the sequence carefully',
                  style: TextStyle(
                    fontSize: 14,
                    color: subColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: imageSequence.length,
                itemBuilder: (context, index) {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _isPaused ? 0.1 : 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: imageSequence[index].color,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: imageSequence[index].color.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: _buildTileContent(imageSequence[index]),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: imageSequence[index].color,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
