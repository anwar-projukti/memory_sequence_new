import 'package:flutter/material.dart';
import 'package:memory_sequence/core/app_constants.dart';
import 'package:memory_sequence/model/image_data.dart';

/// Represents a single game item - either an emoji or an asset image path.
class GameItem {
  final String? assetPath;
  final String? emoji;

  const GameItem.asset(String path)
      : assetPath = path,
        emoji = null;

  const GameItem.fromEmoji(String e)
      : emoji = e,
        assetPath = null;

  bool get isEmoji => emoji != null;
}

/// Defines a playable category for the Memory Sequence game.
class GameCategory {
  final String id;
  final String name;
  final String icon;        // Emoji used as the category card icon
  final Color themeColor;   // Primary accent colour for this category
  final List<GameItem> items;

  const GameCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.themeColor,
    required this.items,
  });

  /// All available categories.
  static const List<GameCategory> all = [
    GameCategory(
      id: 'animals',
      name: 'Animals',
      icon: '🐘',
      themeColor: Color(0xFF795548),
      items: [
        GameItem.fromEmoji('🐘'),
        GameItem.fromEmoji('🦁'),
        GameItem.fromEmoji('🐯'),
        GameItem.fromEmoji('🦊'),
        GameItem.fromEmoji('🐺'),
        GameItem.fromEmoji('🦝'),
        GameItem.fromEmoji('🐼'),
        GameItem.fromEmoji('🐨'),
      ],
    ),
    GameCategory(
      id: 'flowers',
      name: 'Flowers',
      icon: '🌸',
      themeColor: Color(0xFFE91E63),
      items: [
        GameItem.fromEmoji('🌸'),
        GameItem.fromEmoji('🌺'),
        GameItem.fromEmoji('🌻'),
        GameItem.fromEmoji('🌹'),
        GameItem.fromEmoji('🌷'),
        GameItem.fromEmoji('💐'),
        GameItem.fromEmoji('🌼'),
        GameItem.fromEmoji('🪷'),
      ],
    ),
    GameCategory(
      id: 'fruits',
      name: 'Fruits',
      icon: '🍎',
      themeColor: Color(0xFFF44336),
      items: [
        GameItem.fromEmoji('🍎'),
        GameItem.fromEmoji('🍊'),
        GameItem.fromEmoji('🍋'),
        GameItem.fromEmoji('🍇'),
        GameItem.fromEmoji('🍓'),
        GameItem.fromEmoji('🥭'),
        GameItem.fromEmoji('🍍'),
        GameItem.fromEmoji('🍑'),
      ],
    ),
    GameCategory(
      id: 'vegetables',
      name: 'Vegetables',
      icon: '🥕',
      themeColor: Color(0xFF4CAF50),
      items: [
        GameItem.fromEmoji('🥕'),
        GameItem.fromEmoji('🌽'),
        GameItem.fromEmoji('🥦'),
        GameItem.fromEmoji('🥑'),
        GameItem.fromEmoji('🍆'),
        GameItem.fromEmoji('🧅'),
        GameItem.fromEmoji('🥔'),
        GameItem.fromEmoji('🌶️'),
      ],
    ),
    GameCategory(
      id: 'birds',
      name: 'Birds',
      icon: '🦜',
      themeColor: Color(0xFF03A9F4),
      items: [
        GameItem.fromEmoji('🦜'),
        GameItem.fromEmoji('🦅'),
        GameItem.fromEmoji('🦆'),
        GameItem.fromEmoji('🦢'),
        GameItem.fromEmoji('🦩'),
        GameItem.fromEmoji('🦚'),
        GameItem.fromEmoji('🐦'),
        GameItem.fromEmoji('🦉'),
      ],
    ),
    GameCategory(
      id: 'trees',
      name: 'Trees',
      icon: '🌳',
      themeColor: Color(0xFF2E7D32),
      items: [
        GameItem.fromEmoji('🌳'),
        GameItem.fromEmoji('🌴'),
        GameItem.fromEmoji('🌵'),
        GameItem.fromEmoji('🎋'),
        GameItem.fromEmoji('🌲'),
        GameItem.fromEmoji('🎄'),
        GameItem.fromEmoji('🪴'),
        GameItem.fromEmoji('🍀'),
      ],
    ),
    GameCategory(
      id: 'insects',
      name: 'Insects',
      icon: '🦋',
      themeColor: Color(0xFFFF9800),
      items: [
        GameItem.fromEmoji('🦋'),
        GameItem.fromEmoji('🐝'),
        GameItem.fromEmoji('🐛'),
        GameItem.fromEmoji('🐞'),
        GameItem.fromEmoji('🦗'),
        GameItem.fromEmoji('🪲'),
        GameItem.fromEmoji('🦟'),
        GameItem.fromEmoji('🐜'),
      ],
    ),
    GameCategory(
      id: 'fish',
      name: 'Fish & Sea',
      icon: '🐟',
      themeColor: Color(0xFF0288D1),
      items: [
        GameItem.fromEmoji('🐟'),
        GameItem.fromEmoji('🐠'),
        GameItem.fromEmoji('🐡'),
        GameItem.fromEmoji('🦈'),
        GameItem.fromEmoji('🐙'),
        GameItem.fromEmoji('🦑'),
        GameItem.fromEmoji('🦞'),
        GameItem.fromEmoji('🦀'),
      ],
    ),
    GameCategory(
      id: 'crops',
      name: 'Crops',
      icon: '🌾',
      themeColor: Color(0xFFF9A825),
      items: [
        GameItem.fromEmoji('🌾'),  // rice / wheat sheaf
        GameItem.fromEmoji('🌽'),  // corn
        GameItem.fromEmoji('🫘'),  // beans
        GameItem.fromEmoji('🥜'),  // groundnut / peanut
        GameItem.fromEmoji('🌱'),  // seedling
        GameItem.fromEmoji('🧄'),  // garlic
        GameItem.fromEmoji('🫚'),  // olive oil / sunflower
        GameItem.fromEmoji('🍞'),  // bread (wheat product)
      ],
    ),
  ];

  /// Build the shuffled [ImageData] list for gameplay from this category.
  List<ImageData> buildImageSequence() {
    // Tile background colours per category
    final baseColors = [
      themeColor,
      themeColor.withValues(alpha: 0.85),
      Color.lerp(themeColor, Colors.white, 0.25)!,
      Color.lerp(themeColor, Colors.black, 0.15)!,
      Color.lerp(themeColor, const Color(0xFFFFFFFF), 0.40)!,
      Color.lerp(themeColor, const Color(0xFF000000), 0.25)!,
      themeColor.withValues(alpha: 0.75),
      Color.lerp(themeColor, Colors.purple, 0.3)!,
    ];

    final shuffledItems = List<GameItem>.from(items)..shuffle();
    final shuffledColors = List<Color>.from(baseColors)..shuffle();

    return List.generate(AppConstants.kSequenceLength, (index) {
      final item = shuffledItems[index];
      return ImageData(
        imagePath: item.assetPath,
        emoji: item.emoji,
        color: shuffledColors[index],
        originalIndex: index,
      );
    });
  }
}
