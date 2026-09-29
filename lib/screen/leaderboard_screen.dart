import 'package:flutter/material.dart';
import 'package:memory_sequence/core/app_constants.dart';
import 'package:memory_sequence/services/game_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final _service = GameService();

  String _medal(int rank) {
    if (rank == 0) return '🥇';
    if (rank == 1) return '🥈';
    if (rank == 2) return '🥉';
    return '${rank + 1}';
  }

  Color _rankColor(int rank) {
    if (rank == 0) return AppConstants.kRankGold;
    if (rank == 1) return AppConstants.kRankSilver;
    if (rank == 2) return AppConstants.kRankBronze;
    return AppConstants.kRankDefault;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _service,
      builder: (context, _) {
        final isDark = _service.isDarkMode;
        final bg = isDark ? AppConstants.kDarkBg : AppConstants.kLightBg;
        final cardBg = isDark ? AppConstants.kDarkMidBg : Colors.white;
        final textColor = isDark ? Colors.white : AppConstants.kDarkMidBg;
        final subColor = isDark
            ? AppConstants.kLbSubLabelDark
            : AppConstants.kLbSubLabelLight;

        final entries = _service.leaderboard;

        return Scaffold(
      backgroundColor: bg,
      body: Container(
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
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
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
                        ),
                        child: Icon(Icons.arrow_back_ios_new_rounded,
                            color: textColor, size: 18),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Leaderboard',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                      ),
                    ),
                    const Spacer(),
                    const Text('🏆', style: TextStyle(fontSize: 28)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Top ${entries.length} players',
                  style: TextStyle(fontSize: 13, color: subColor),
                ),
              ),
              const SizedBox(height: 20),
              // Top 3 podium
              if (entries.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _TopThree(entries: entries, isDark: isDark),
                ),
              const SizedBox(height: 20),
              // Remaining list
              Expanded(
                child: entries.isEmpty
                    ? _EmptyState(isDark: isDark)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: entries.length > 3 ? entries.length - 3 : 0,
                        itemBuilder: (context, index) {
                          final rank = index + 3;
                          final e = entries[rank];
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: Duration(milliseconds: 300 + index * 60),
                            curve: Curves.easeOut,
                            builder: (context, value, child) => Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(30 * (1 - value), 0),
                                child: child,
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: cardBg,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark
                                        ? AppConstants.kLbCardShadowDark
                                        : AppConstants.kLbCardShadowLight,
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: _rankColor(rank).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _medal(rank),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: _rankColor(rank),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.playerName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: textColor,
                                          ),
                                        ),
                                        Text(
                                          _formatDate(e.date),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: subColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${e.score}/${e.totalImages}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                          color: AppConstants.kPrimary,
                                        ),
                                      ),
                                      Text(
                                        '${e.percentage.toInt()}%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: subColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day} ${_monthName(d.month)} ${d.year}';

  String _monthName(int m) => [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m - 1];
}

class _TopThree extends StatelessWidget {
  final List<LeaderboardEntry> entries;
  final bool isDark;

  const _TopThree({required this.entries, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : AppConstants.kDarkMidBg;

    Widget podiumCard(int rank, double height) {
      if (rank >= entries.length) return const SizedBox.shrink();
      final e = entries[rank];
      final colors = [
        [AppConstants.kRankGold, AppConstants.kRankGoldDark],
        [AppConstants.kRankSilver, AppConstants.kRankSilverDark],
        [AppConstants.kRankBronze, AppConstants.kRankBronzeDark],
      ];
      return Expanded(
        flex: rank == 0 ? 5 : 4,
        child: Column(
          children: [
            Text(
              rank == 0 ? '🥇' : rank == 1 ? '🥈' : '🥉',
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 6),
            Text(
              e.playerName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${e.score}/${e.totalImages}',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: colors[rank],
                  ).createShader(const Rect.fromLTWH(0, 0, 80, 20)),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colors[rank][0].withValues(alpha: 0.9),
                    colors[rank][1].withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors[rank][0].withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${e.percentage.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        podiumCard(1, 70),
        const SizedBox(width: 8),
        podiumCard(0, 100),
        const SizedBox(width: 8),
        podiumCard(2, 55),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;
  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🎮',
              style:
                  TextStyle(fontSize: 64, color: AppConstants.kLbEmptyIconOverlay)),
          const SizedBox(height: 16),
          Text(
            'No scores yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? AppConstants.kLbEmptyTitleDark : AppConstants.kLbEmptyTitleLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Play a game to get on the board!',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppConstants.kLbEmptySubDark : AppConstants.kLbEmptySubLight,
            ),
          ),
        ],
      ),
    );
  }
}
