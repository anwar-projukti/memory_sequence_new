import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memory_sequence/core/app_constants.dart';
import 'package:memory_sequence/model/image_data.dart';
import 'package:memory_sequence/screen/result_screen.dart';
import 'package:memory_sequence/services/game_service.dart';
import 'package:memory_sequence/widgets/game_dialogs.dart';

class RecallPhase extends StatefulWidget {
  final List<ImageData> correctSequence;

  const RecallPhase({super.key, required this.correctSequence});

  @override
  State<RecallPhase> createState() => _RecallPhaseState();
}

class _RecallPhaseState extends State<RecallPhase> {
  late List<ImageData> shuffledImages;
  List<ImageData> userSequence = [];
  int countdown = AppConstants.kRecallTimerSeconds;
  Timer? timer;
  bool isTimeUp = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    shuffledImages = List<ImageData>.from(widget.correctSequence)..shuffle();
    startCountdown();
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_isPaused) return;
      if (countdown > 0) {
        setState(() => countdown--);
      } else {
        t.cancel();
        setState(() => isTimeUp = true);
      }
    });
  }

  void onImageTap(ImageData image) {
    if (isTimeUp || _isPaused) return;
    setState(() {
      if (userSequence.contains(image)) {
        userSequence.remove(image);
      } else if (userSequence.length < AppConstants.kSequenceLength) {
        userSequence.add(image);
      }
    });
  }

  void submitAnswer() {
    if (userSequence.length < AppConstants.kSequenceLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Please complete all ${AppConstants.kSequenceLength} positions!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    timer?.cancel();
    int correctMatches = 0;
    for (int i = 0; i < userSequence.length; i++) {
      if (i < widget.correctSequence.length &&
          userSequence[i].originalIndex ==
              widget.correctSequence[i].originalIndex) {
        correctMatches++;
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          correctMatches: correctMatches,
          totalImages: widget.correctSequence.length,
          userSequence: userSequence,
          correctSequence: widget.correctSequence,
        ),
      ),
    );
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

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  /// Renders either an emoji or asset image for a tile.
  Widget _buildTileContent(ImageData item, {double padding = 12}) {
    if (item.isEmoji) {
      return Center(
        child: Text(item.emoji!, style: const TextStyle(fontSize: 34)),
      );
    }
    return Padding(
      padding: EdgeInsets.all(padding),
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
          'Recall',
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
            onPressed: isTimeUp ? null : _togglePause,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Timer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
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
                        color: (isTimeUp
                                ? AppConstants.kError
                                : AppConstants.kPrimary)
                            .withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.timer_rounded,
                        size: 24,
                        color: isTimeUp
                            ? AppConstants.kError
                            : AppConstants.kPrimary,
                      ),
                    ),
                    const SizedBox(width: 14),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        isTimeUp
                            ? 'TIME UP!'
                            : _isPaused
                                ? '⏸'
                                : '$countdown',
                        key: ValueKey(isTimeUp
                            ? 'up'
                            : _isPaused
                                ? 'pause'
                                : countdown),
                        style: TextStyle(
                          fontSize: isTimeUp ? 28 : 40,
                          fontWeight: FontWeight.w900,
                          color: isTimeUp
                              ? AppConstants.kError
                              : AppConstants.kPrimary,
                        ),
                      ),
                    ),
                    if (!isTimeUp && !_isPaused) ...[
                      const SizedBox(width: 6),
                      Text('sec',
                          style: TextStyle(fontSize: 16, color: subColor)),
                    ],
                  ],
                ),
                if (!isTimeUp) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: countdown / AppConstants.kRecallTimerSeconds,
                      backgroundColor: (countdown <= AppConstants.kRecallWarningThreshold
                              ? AppConstants.kError
                              : AppConstants.kPrimary)
                          .withValues(alpha: 0.12),
                      valueColor: AlwaysStoppedAnimation<Color>(countdown <= AppConstants.kRecallWarningThreshold
                          ? AppConstants.kError
                          : AppConstants.kPrimary),
                      minHeight: 5,
                    ),
                  ),
                ],
                if (isTimeUp) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Submit your answer now!',
                    style: TextStyle(
                        fontSize: 13,
                        color: AppConstants.kError.withValues(alpha: 0.8)),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          // User sequence row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your sequence',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: userSequence.length == AppConstants.kSequenceLength
                        ? AppConstants.kSuccess
                        : AppConstants.kPrimary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${userSequence.length}/${AppConstants.kSequenceLength}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: userSequence.length == AppConstants.kSequenceLength
                          ? Colors.white
                          : AppConstants.kPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Sequence slots
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSequenceRow(0, 4, cardBg, isDark),
                const SizedBox(height: 8),
                _buildSequenceRow(4, 8, cardBg, isDark),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Shuffled grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: shuffledImages.length,
                itemBuilder: (context, index) {
                  final image = shuffledImages[index];
                  final isSelected = userSequence.contains(image);
                  final selectedIndex = userSequence.indexOf(image);

                  return GestureDetector(
                    onTap: () => onImageTap(image),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isSelected ? 0.3 : 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: image.color,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: image.color.withValues(alpha: isSelected ? 0.15 : 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Center(child: _buildTileContent(image)),
                            if (isSelected)
                              Positioned(
                                top: 7,
                                right: 7,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: image.color, width: 2),
                                  ),
                                  child: Text(
                                    '${selectedIndex + 1}',
                                    style: TextStyle(
                                      color: image.color,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Submit button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: userSequence.length == AppConstants.kSequenceLength
                    ? AppConstants.kSuccessGradient
                    : null,
                color: userSequence.length == AppConstants.kSequenceLength
                    ? null
                    : isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.grey.shade200,
                boxShadow: userSequence.length == AppConstants.kSequenceLength
                    ? [
                        BoxShadow(
                          color: AppConstants.kSuccess.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [],
              ),
              child: ElevatedButton.icon(
                onPressed: userSequence.length == AppConstants.kSequenceLength ? submitAnswer : null,
                icon: Icon(
                  Icons.check_circle_rounded,
                  color: userSequence.length == AppConstants.kSequenceLength ? Colors.white : subColor,
                ),
                label: Text(
                  'Submit Answer',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: userSequence.length == AppConstants.kSequenceLength ? Colors.white : subColor,
                    letterSpacing: 0.3,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  minimumSize: const Size(double.infinity, 0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSequenceRow(int start, int end, Color cardBg, bool isDark) {
    return Row(
      children: List.generate(end - start, (i) {
        final index = start + i;
        final hasItem = index < userSequence.length;
        return Expanded(
          child: Container(
            height: 66,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: hasItem
                  ? userSequence[index].color
                  : isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
              border: hasItem
                  ? null
                  : Border.all(
                      color: isDark ? Colors.white12 : Colors.grey.shade300,
                      width: 1.5,
                    ),
              boxShadow: hasItem
                  ? [
                      BoxShadow(
                        color: userSequence[index].color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: hasItem
                ? Stack(
                    children: [
                      Center(
                        child: _buildTileContent(userSequence[index],
                            padding: 8),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: userSequence[index].color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white24 : Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
        );
      }),
    );
  }
}
