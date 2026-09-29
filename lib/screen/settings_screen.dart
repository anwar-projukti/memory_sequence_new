import 'package:flutter/material.dart';
import 'package:memory_sequence/core/app_constants.dart';
import 'package:memory_sequence/services/game_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _service = GameService();

  Future<void> _confirmReset({required String title, required String body, required VoidCallback onConfirm}) async {
    final isDark = _service.isDarkMode;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: isDark ? AppConstants.kDarkMidBg : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppConstants.kDarkMidBg,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppConstants.kResultSubDark : AppConstants.kResultSubLight,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: isDark
                              ? AppConstants.kSettingsCancelBorderDark
                              : AppConstants.kSettingsCancelBorderLight,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: isDark ? AppConstants.kResultActionSubDark : AppConstants.kResultSubLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.kError,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed == true) onConfirm();
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
        final subColor = isDark ? AppConstants.kLbSubLabelDark : AppConstants.kLbSubLabelLight;
        final divColor = isDark ? AppConstants.kSettingsDivDark : AppConstants.kSettingsDivLight;

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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              color: isDark ? AppConstants.kCatBackBtnDark : AppConstants.kCatBackBtnLight,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(Icons.arrow_back_ios_new_rounded, color: textColor, size: 18),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Settings',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: textColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Sections
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionLabel('Appearance', subColor),
                          const SizedBox(height: 10),
                          _SettingsCard(
                            isDark: isDark,
                            cardBg: cardBg,
                            children: [
                              _ToggleRow(
                                icon: Icons.dark_mode_rounded,
                                iconColor: AppConstants.kPrimary,
                                label: 'Dark Mode',
                                subLabel: isDark ? 'On' : 'Off',
                                textColor: textColor,
                                subColor: subColor,
                                value: isDark,
                                onChanged: (_) => _service.toggleDarkMode(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _sectionLabel('Game Data', subColor),
                          const SizedBox(height: 10),
                          _SettingsCard(
                            isDark: isDark,
                            cardBg: cardBg,
                            children: [
                              _InfoRow(
                                icon: Icons.star_rounded,
                                iconColor: AppConstants.kRankGold,
                                label: 'Best Score',
                                value: '${_service.bestScore} / ${AppConstants.kSequenceLength}',
                                textColor: textColor,
                                subColor: subColor,
                              ),
                              Divider(color: divColor, height: 1),
                              _InfoRow(
                                icon: Icons.format_list_numbered_rounded,
                                iconColor: AppConstants.kSuccess,
                                label: 'Leaderboard Entries',
                                value: '${_service.leaderboard.length} / ${AppConstants.kLeaderboardMaxEntries}',
                                textColor: textColor,
                                subColor: subColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _sectionLabel('Danger Zone', subColor),
                          const SizedBox(height: 10),
                          _SettingsCard(
                            isDark: isDark,
                            cardBg: cardBg,
                            children: [
                              _ActionRow(
                                icon: Icons.emoji_events_outlined,
                                iconColor: AppConstants.kSettingsDangerOrange,
                                label: 'Reset Best Score',
                                subLabel: 'Set best score back to 0',
                                textColor: textColor,
                                subColor: subColor,
                                onTap: () => _confirmReset(
                                  title: 'Reset Best Score?',
                                  body: 'Your best score will be permanently deleted.',
                                  onConfirm: _service.resetBestScore,
                                ),
                              ),
                              Divider(color: divColor, height: 1),
                              _ActionRow(
                                icon: Icons.delete_outline_rounded,
                                iconColor: AppConstants.kError,
                                label: 'Clear Leaderboard',
                                subLabel: 'Remove all leaderboard entries',
                                textColor: textColor,
                                subColor: subColor,
                                onTap: () => _confirmReset(
                                  title: 'Clear Leaderboard?',
                                  body: 'All leaderboard entries will be permanently removed.',
                                  onConfirm: _service.clearLeaderboard,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Center(
                            child: Text('Memory Sequence v1.0.0', style: TextStyle(fontSize: 12, color: subColor)),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
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

  Widget _sectionLabel(String text, Color color) => Text(
    text.toUpperCase(),
    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color, letterSpacing: 1.5),
  );
}

class _SettingsCard extends StatelessWidget {
  final bool isDark;
  final Color cardBg;
  final List<Widget> children;

  const _SettingsCard({required this.isDark, required this.cardBg, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppConstants.kLbCardShadowDark : AppConstants.kLbCardShadowLight,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(children: children),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subLabel;
  final Color textColor;
  final Color subColor;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subLabel,
    required this.textColor,
    required this.subColor,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textColor),
                ),
                Text(subLabel, style: TextStyle(fontSize: 12, color: subColor)),
              ],
            ),
          ),
          Switch.adaptive(value: value, onChanged: onChanged, activeThumbColor: AppConstants.kPrimary),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color textColor;
  final Color subColor;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: textColor),
            ),
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppConstants.kPrimary),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subLabel;
  final Color textColor;
  final Color subColor;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subLabel,
    required this.textColor,
    required this.subColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: iconColor),
                  ),
                  Text(subLabel, style: TextStyle(fontSize: 12, color: subColor)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: subColor),
          ],
        ),
      ),
    );
  }
}
