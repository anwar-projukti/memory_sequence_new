import 'dart:ui';

class ImageData {
  final String? imagePath; // null for emoji items
  final String? emoji;     // null for asset image items
  final Color color;
  final int originalIndex;

  ImageData({
    this.imagePath,
    this.emoji,
    required this.color,
    required this.originalIndex,
  }) : assert(
          imagePath != null || emoji != null,
          'Either imagePath or emoji must be provided',
        );

  bool get isEmoji => emoji != null;
}
