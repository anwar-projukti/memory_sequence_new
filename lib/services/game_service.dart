import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:memory_sequence/core/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardEntry {
  final String playerName;
  final int score;
  final int totalImages;
  final DateTime date;

  LeaderboardEntry({
    required this.playerName,
    required this.score,
    required this.totalImages,
    required this.date,
  });

  double get percentage => (score / totalImages) * 100;

  Map<String, dynamic> toJson() => {
        'playerName': playerName,
        'score': score,
        'totalImages': totalImages,
        'date': date.toIso8601String(),
      };

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      LeaderboardEntry(
        playerName: json['playerName'] as String,
        score: json['score'] as int,
        totalImages: json['totalImages'] as int,
        date: DateTime.parse(json['date'] as String),
      );
}

class GameService extends ChangeNotifier {
  static final GameService _instance = GameService._internal();
  factory GameService() => _instance;
  GameService._internal();

  static const _keyBestScore = 'best_score';
  static const _keyDarkMode = 'dark_mode';
  static const _keyLeaderboard = 'leaderboard';

  int _bestScore = 0;
  bool _isDarkMode = true;
  List<LeaderboardEntry> _leaderboard = [];

  int get bestScore => _bestScore;
  bool get isDarkMode => _isDarkMode;
  List<LeaderboardEntry> get leaderboard => List.unmodifiable(_leaderboard);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _bestScore = prefs.getInt(_keyBestScore) ?? 0;
    _isDarkMode = prefs.getBool(_keyDarkMode) ?? true;
    final raw = prefs.getString(_keyLeaderboard);
    if (raw != null) {
      final List<dynamic> list = jsonDecode(raw);
      _leaderboard = list
          .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    notifyListeners();
  }

  Future<bool> saveScore({
    required String playerName,
    required int score,
    required int totalImages,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    bool isNewBest = false;

    if (score > _bestScore) {
      _bestScore = score;
      isNewBest = true;
      await prefs.setInt(_keyBestScore, _bestScore);
    }

    final entry = LeaderboardEntry(
      playerName: playerName,
      score: score,
      totalImages: totalImages,
      date: DateTime.now(),
    );

    _leaderboard.add(entry);
    _leaderboard.sort((a, b) => b.score.compareTo(a.score));
    if (_leaderboard.length > AppConstants.kLeaderboardMaxEntries) {
      _leaderboard = _leaderboard.sublist(0, AppConstants.kLeaderboardMaxEntries);
    }

    await prefs.setString(
        _keyLeaderboard, jsonEncode(_leaderboard.map((e) => e.toJson()).toList()));

    notifyListeners();
    return isNewBest;
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, _isDarkMode);
    notifyListeners();
  }

  Future<void> resetBestScore() async {
    _bestScore = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyBestScore, 0);
    notifyListeners();
  }

  Future<void> clearLeaderboard() async {
    _leaderboard = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLeaderboard);
    notifyListeners();
  }
}
