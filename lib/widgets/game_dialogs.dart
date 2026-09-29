import 'package:flutter/material.dart';
import 'package:memory_sequence/core/app_constants.dart';

class PauseDialog extends StatelessWidget {
  final bool isDark;
  final VoidCallback onResume;
  final VoidCallback onQuit;

  const PauseDialog({
    super.key,
    required this.isDark,
    required this.onResume,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppConstants.kDarkMidBg : Colors.white;
    final textColor = isDark ? Colors.white : AppConstants.kDarkMidBg;
    final subColor = isDark ? Colors.white60 : Colors.black54;

    return Dialog(
      backgroundColor: bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppConstants.kPrimary.withValues(alpha: 0.12),
              ),
              child: const Icon(
                Icons.pause_rounded,
                size: 38,
                color: AppConstants.kPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Game Paused',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Take a breath — your progress is safe',
              style: TextStyle(fontSize: 13, color: subColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onResume,
                icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                label: const Text(
                  'Resume',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.kPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onQuit,
                icon: Icon(Icons.exit_to_app_rounded, color: subColor),
                label: Text(
                  'Quit Game',
                  style: TextStyle(
                    color: subColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.24)
                        : Colors.black.withValues(alpha: 0.15),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuitDialog extends StatelessWidget {
  final bool isDark;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const QuitDialog({
    super.key,
    required this.isDark,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppConstants.kDarkMidBg : Colors.white;
    final textColor = isDark ? Colors.white : AppConstants.kDarkMidBg;
    final subColor = isDark ? Colors.white60 : Colors.black54;

    return Dialog(
      backgroundColor: bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppConstants.kError.withValues(alpha: 0.12),
              ),
              child: const Icon(
                Icons.exit_to_app_rounded,
                size: 36,
                color: AppConstants.kError,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Quit Game?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to quit?\nYour current progress will be lost.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: subColor, height: 1.5),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.24)
                            : Colors.black.withValues(alpha: 0.15),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      'Cancel',
                      style:
                          TextStyle(color: subColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.kError,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Quit',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
