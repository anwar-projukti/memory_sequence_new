import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AppConstants — single source of truth for all magic numbers & named values.
///
/// HOW TO CUSTOMISE:
///  • Timer durations  → edit [kMemoryTimerSeconds] / [kRecallTimerSeconds]
///  • Sequence length  → edit [kSequenceLength]
///  • Theme colours    → edit the colour constants below
/// ─────────────────────────────────────────────────────────────────────────────
class AppConstants {
  AppConstants._();

  // ── Game Settings ────────────────────────────────────────────────────────────
  /// Number of items in each round (both memory and recall phases).
  static const int kSequenceLength = 8;

  /// Seconds the player has to memorise the sequence.
  static const int kMemoryTimerSeconds = 15;

  /// Seconds the player has to recall and submit the sequence.
  static const int kRecallTimerSeconds = 60;

  /// Timer threshold (seconds) at which the countdown turns red in memory phase.
  static const int kMemoryWarningThreshold = 5;

  /// Timer threshold (seconds) at which the countdown turns red in recall phase.
  static const int kRecallWarningThreshold = 10;

  /// Maximum number of leaderboard entries kept on device.
  static const int kLeaderboardMaxEntries = 10;

  // ── Dark-mode palette ────────────────────────────────────────────────────────
  /// Deepest background — used as the scaffold background in dark mode.
  static const Color kDarkBg = Color(0xFF0A0015);

  /// Mid-level background — card & app bar colour in dark mode.
  static const Color kDarkMidBg = Color(0xFF1A0830);

  /// Slightly lighter than [kDarkBg] — used for gradient stops.
  static const Color kDarkDeepBg = Color(0xFF150030);

  // ── Light-mode palette ───────────────────────────────────────────────────────
  /// Scaffold background in light mode.
  static const Color kLightBg = Color(0xFFF8F9FF);

  /// Lavender tint used at the top of light-mode gradients.
  static const Color kLightTopBg = Color(0xFFEDE7F6);

  /// Soft purple tint — secondary gradient stop in light mode.
  static const Color kLightMidBg = Color(0xFFD1C4E9);

  // ── Brand / accent colours ───────────────────────────────────────────────────
  /// Primary purple — main buttons, icons, progress bars, etc.
  static const Color kPrimary = Color(0xFF9C27B0);

  /// Darker purple — gradient end, deep shadow tints.
  static const Color kPrimaryDark = Color(0xFF6A1B9A);

  /// Deepest purple — button text in light mode.
  static const Color kPrimaryDeepest = Color(0xFF4A148C);

  /// Light lavender — used in shader-mask gradient text.
  static const Color kPrimaryLight = Color(0xFFCE93D8);

  // ── Semantic colours ─────────────────────────────────────────────────────────
  /// Success / correct answer highlight.
  static const Color kSuccess = Color(0xFF4CAF50);

  /// Success dark — gradient end for the submit button when ready.
  static const Color kSuccessDark = Color(0xFF2E7D32);

  /// Error / wrong answer highlight.
  static const Color kError = Color(0xFFE53935);

  /// Warning colour (amber) — used on the rewarded-ad hint button.
  static const Color kWarning = Color(0xFFFFB703);

  /// Rewarded-ad button gradient start.
  static const Color kRewardedStart = Color(0xFFFFA000);

  /// Rewarded-ad button gradient end.
  static const Color kRewardedEnd = Color(0xFFFF6F00);

  // ── CategorySelect screen colours ──────────────────────────────────────────
  /// Back-button container fill — dark mode (white overlay).
  static const Color kCatBackBtnDark = Color(0x14FFFFFF); // white 8 %

  /// Back-button container fill — light mode (black overlay).
  static const Color kCatBackBtnLight = Color(0x0F000000); // black 6 %

  /// Back-button border — dark mode.
  static const Color kCatBackBorderDark = Color(0x1AFFFFFF); // white 10 %

  /// Back-button border — light mode.
  static const Color kCatBackBorderLight = Color(0x14000000); // black 8 %

  /// Random-banner icon bubble fill and shuffle icon bg (white 15 %).
  static const Color kCatBannerIconBg = Color(0x26FFFFFF); // white 15 %

  // ── HomePage screen colours ───────────────────────────────────────────────────
  /// Top-bar icon colour — dark mode (white 70 %).\
  static const Color kHomeTopBarIconDark = Color(0xB3FFFFFF); // white 70 %

  /// Best-score card fill — dark mode (white 6 %).\
  static const Color kHomeBestCardDark = Color(0x0FFFFFFF); // white 6 %

  /// Best-score card fill — light mode (white 70 %).\
  static const Color kHomeBestCardLight = Color(0xB3FFFFFF); // white 70 %

  /// Best-score card border — dark mode (white 10 %).\
  static const Color kHomeBestCardBorderDark = Color(0x1AFFFFFF); // white 10 %

  /// Best-score label colour — dark mode (white 60 %).\
  static const Color kHomeBestLabelDark = Color(0x99FFFFFF); // white 60 %

  /// Best-score label colour — light mode (black 50 %).\
  static const Color kHomeBestLabelLight = Color(0x80000000); // black 50 %

  /// Secondary button fill — dark mode (white 7 %).\
  static const Color kHomeSecBtnDark = Color(0x12FFFFFF); // white 7 %

  /// Secondary button fill — light mode (white 75 %).\
  static const Color kHomeSecBtnLight = Color(0xBFFFFFFF); // white 75 %

  /// Secondary button border — dark mode (white 12 %).\
  static const Color kHomeSecBtnBorderDark = Color(0x1FFFFFFF); // white 12 %

  /// Secondary button shadow — dark mode (black 20 %).\
  static const Color kHomeSecBtnShadowDark = Color(0x33000000); // black 20 %

  /// Secondary button shadow — light mode (black 5 %).\
  static const Color kHomeSecBtnShadowLight = Color(0x0D000000); // black 5 %

  /// Secondary button text — dark mode (white 85 %).\
  static const Color kHomeSecBtnTextDark = Color(0xD9FFFFFF); // white 85 %

  // ── Leaderboard screen colours ───────────────────────────────────────────────
  /// Rank #1 — gold.
  static const Color kRankGold = Color(0xFFFFD700);

  /// Rank #1 podium gradient end — deep amber.
  static const Color kRankGoldDark = Color(0xFFFFA000);

  /// Rank #2 — silver.
  static const Color kRankSilver = Color(0xFFB0BEC5);

  /// Rank #2 podium gradient end — darker silver-blue.
  static const Color kRankSilverDark = Color(0xFF78909C);

  /// Rank #3 — bronze.
  static const Color kRankBronze = Color(0xFFCD7F32);

  /// Rank #3 podium gradient end — warm brown.
  static const Color kRankBronzeDark = Color(0xFF8D6E63);

  /// Default rank colour — medium purple.
  static const Color kRankDefault = Color(0xFF7E57C2);

  /// Sub-label colour — dark mode (white 50 %).
  static const Color kLbSubLabelDark = Color(0x80FFFFFF); // white 50 %

  /// Sub-label colour — light mode (black 40 %).
  static const Color kLbSubLabelLight = Color(0x66000000); // black 40 %

  /// Light-mode gradient bottom stop — pure white.
  static const Color kLbGradientLightEnd = Color(0xFFFFFFFF);

  /// List card shadow — dark mode (black 30 %).
  static const Color kLbCardShadowDark = Color(0x4D000000); // black 30 %

  /// List card shadow — light mode (black 6 %).
  static const Color kLbCardShadowLight = Color(0x0F000000); // black 6 %

  /// Empty-state icon overlay (white 30 %).
  static const Color kLbEmptyIconOverlay = Color(0x4DFFFFFF); // white 30 %

  /// Empty-state title — dark mode (white 54 %).
  static const Color kLbEmptyTitleDark = Color(0x8AFFFFFF); // white 54 %

  /// Empty-state title — light mode (black 38 %).
  static const Color kLbEmptyTitleLight = Color(0x61000000); // black 38 %

  /// Empty-state subtitle — dark mode (white 38 %).
  static const Color kLbEmptySubDark = Color(0x61FFFFFF); // white 38 %

  /// Empty-state subtitle — light mode (black 26 %).
  static const Color kLbEmptySubLight = Color(0x42000000); // black 26 %

  // ── How-To-Play screen colours ───────────────────────────────────────────────
  /// Third gradient stop on the dark-mode background (deepest dark violet).
  static const Color kDarkBgDeepViolet = Color(0xFF0D0020);

  /// Step-2 accent — medium purple (between [kPrimary] and [kPrimaryDark]).
  static const Color kStep2Accent = Color(0xFF7B1FA2);

  /// Hero icon gradient start — soft violet bubble top colour.
  static const Color kHeroIconStart = Color(0xFF9B59B6);

  // ── Scoring badge colours ─────────────────────────────────────────────────────
  /// "Keep Trying" badge — muted red.
  static const Color kScoreBadgeRed = Color(0xFFE57373);

  /// "Good Memory" badge — deep amber (high-contrast orange-amber).
  static const Color kScoreBadgeAmber = Color(0xFFF59300);

  /// "Great Job!" badge — soft green.
  static const Color kScoreBadgeGreen = Color(0xFF81C784);

  // ── ResultScreen colours ─────────────────────────────────────────────────────
  /// Dialog barrier scrim (black 65 %).
  static const Color kResultBarrierColor = Color(0xA6000000); // black 65 %

  /// Dialog/page sub-label — dark mode (white 60 %).
  static const Color kResultSubDark = Color(0x99FFFFFF); // white 60 %

  /// Dialog/page sub-label — light mode (black 54 %).
  static const Color kResultSubLight = Color(0x8A000000); // black 54 %

  /// Text-field fill — dark mode (white 7 %).
  static const Color kResultFieldFillDark = Color(0x12FFFFFF); // white 7 %

  /// Text-field fill — light mode (grey 100).
  static const Color kResultFieldFillLight = Color(0xFFF5F5F5); // grey.shade100

  /// Sequence-comparison card shadow — dark mode (black 25 %).
  static const Color kResultCardShadowDark = Color(0x40000000); // black 25 %

  /// Sequence-comparison card shadow — light mode (black 5 %).
  static const Color kResultCardShadowLight = Color(0x0D000000); // black 5 %

  /// Action-button sub text / icon — dark mode (white 70 %).
  static const Color kResultActionSubDark = Color(0xB3FFFFFF); // white 70 %

  /// Action-button sub text / icon — light mode (black 54 %).
  static const Color kResultActionSubLight = Color(0x8A000000); // black 54 %

  /// Outlined button border — dark mode (white 20 %).
  static const Color kResultOutlineBorderDark = Color(0x33FFFFFF); // white 20 %

  /// Outlined button border — light mode (black 15 %).
  static const Color kResultOutlineBorderLight = Color(0x26000000); // black 15 %

  /// Outlined button fill — dark mode (white 6 %).
  static const Color kResultOutlineFillDark = Color(0x0FFFFFFF); // white 6 %

  // ── SettingsScreen colours ────────────────────────────────────────────────────
  /// Cancel button border — dark mode (white 24 %).
  static const Color kSettingsCancelBorderDark = Color(0x3DFFFFFF); // white 24 %

  /// Cancel button border — light mode (black 26 %).
  static const Color kSettingsCancelBorderLight = Color(0x42000000); // black 26 %

  /// Divider colour — dark mode (white 6 %).
  static const Color kSettingsDivDark = Color(0x0FFFFFFF); // white 6 %

  /// Divider colour — light mode (black 5 %).
  static const Color kSettingsDivLight = Color(0x0D000000); // black 5 %

  /// Danger zone — "Reset Best Score" icon orange.
  static const Color kSettingsDangerOrange = Color(0xFFFF7043);

  // ── Gradients ────────────────────────────────────────────────────────────────
  static const LinearGradient kPrimaryGradient = LinearGradient(
    colors: [kPrimary, kPrimaryDark],
  );

  static const LinearGradient kPrimaryTextGradient = LinearGradient(
    colors: [kPrimaryLight, kPrimary],
  );

  static const LinearGradient kSuccessGradient = LinearGradient(
    colors: [kSuccess, kSuccessDark],
  );

  static const LinearGradient kRewardedGradient = LinearGradient(
    colors: [kRewardedStart, kRewardedEnd],
  );
}
