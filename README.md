# Memory Sequence — Flutter App

A challenging and visually rich **memory & cognitive training game** built with Flutter.
Players are shown a sequence of coloured emoji tiles, then must recall and reproduce
the exact order from memory. Categories include Animals, Fruits, Flowers, Birds, and more.

---

## Table of Contents

1. [Features](#features)
2. [Screenshots](#screenshots)
3. [Requirements](#requirements)
4. [Environment Setup](#environment-setup)
5. [Running the Project](#running-the-project)
6. [Project Structure](#project-structure)
7. [Replacing AdMob Ad Unit IDs](#replacing-admob-ad-unit-ids)
8. [Changing the Package Name / Bundle ID](#changing-the-package-name--bundle-id)
9. [Customising Game Constants](#customising-game-constants)
10. [Building for Release](#building-for-release)
11. [Troubleshooting](#troubleshooting)

---

## Features

- 🧠 **Memory Phase** — Memorise a sequence of 8 emoji tiles in 15 seconds
- ✅ **Recall Phase** — Reproduce the correct order in 60 seconds
- 🏆 **Leaderboard** — Top-10 local high-scores stored on device
- 🌙 **Dark / Light Mode** — Toggleable from the home screen
- 📱 **AdMob Integration** — Banner, Interstitial, and Rewarded ads
- 🎨 **9 Emoji Categories** — Animals, Flowers, Fruits, Vegetables, Birds, Trees, Insects, Fish & Sea, Crops
- ⚙️ **Centralised Constants** — Timer durations, sequence length and colours live in one file

---

## Requirements

| Tool | Minimum Version |
|------|----------------|
| Flutter SDK | 3.38.7 or later |
| Dart | 3.10.7 or later |
| Android Studio / Xcode | Latest stable |
| Android API level | 21+ (Android 5.0) |
| iOS deployment target | 13.0+ |

---

## Environment Setup

### 1. Install Flutter

Follow the official guide at <https://docs.flutter.dev/get-started/install>.
Make sure `flutter doctor` reports no critical errors before continuing.

### 2. Clone the Repository

```bash
git clone <YOUR_REPO_URL>
cd Memory-Sequence
```

### 3. Install Dependencies

```bash
flutter pub get
```

---

## Running the Project

### Android

```bash
flutter run                      # debug mode (uses AdMob test IDs automatically)
flutter run --release            # release mode (uses your real Ad Unit IDs)
```

### iOS

```bash
open ios/Runner.xcworkspace      # open in Xcode to select a signing team first
flutter run -d <your_device_id>
```

---

## Project Structure

```
lib/
├── core/
│   └── app_constants.dart       # All magic numbers & theme colours
├── model/
│   ├── game_category.dart       # Category & GameItem definitions
│   └── image_data.dart          # Tile data model
├── screen/
│   ├── home_screen.dart
│   ├── category_select_screen.dart
│   ├── memory_phase_screen.dart
│   ├── recall_phase_screen.dart
│   ├── result_screen.dart
│   ├── leaderboard_screen.dart
│   ├── settings_screen.dart
│   ├── how_to_play_screen.dart
│   └── splash_screen.dart
├── services/
│   ├── ad_service.dart          # AdMob banner / interstitial / rewarded
│   └── game_service.dart        # Score, leaderboard, dark-mode persistence
├── widgets/
│   ├── banner_ad_widget.dart    # Reusable self-loading banner widget
│   └── game_dialogs.dart        # Pause & Quit dialogs
└── main.dart
```

---

## Replacing AdMob Ad Unit IDs

All ad unit IDs are centralised in **`lib/services/ad_service.dart`** in the `AdIds` class.

1. Open `lib/services/ad_service.dart`.
2. Replace the placeholder strings with your real AdMob IDs:

```dart
// ── Android ──────────────────────────────────────────────────────────
static const String _androidBanner        = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
static const String _androidInterstitial  = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
static const String _androidRewarded      = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';

// ── iOS ──────────────────────────────────────────────────────────────
static const String _iosBanner            = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
static const String _iosInterstitial      = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
static const String _iosRewarded          = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
```

> **Note:** In `kDebugMode` the app automatically uses Google's official test IDs,
> so you do not need to change anything to run locally in debug.

You must also add your AdMob **App ID** to the platform manifests:

**Android** — `android/app/src/main/AndroidManifest.xml`

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"/>
```

**iOS** — `ios/Runner/Info.plist`

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX</string>
```

---

## Changing the Package Name / Bundle ID

### Android

1. Open `android/app/build.gradle` and update `applicationId`:

```groovy
defaultConfig {
    applicationId "com.yourcompany.memorysequence"
    ...
}
```

2. Rename the Java/Kotlin package directories under `android/app/src/main/kotlin/`
   to match the new ID, and update the `package` declaration at the top of
   `MainActivity.kt`.

### iOS

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select the **Runner** target → **General** tab.
3. Change the **Bundle Identifier** field to `com.yourcompany.memorysequence`.

---

## Customising Game Constants

All tuneable values are in **`lib/core/app_constants.dart`**:

| Constant | Default | Description |
|----------|---------|-------------|
| `kSequenceLength` | `8` | Number of tiles in each round |
| `kMemoryTimerSeconds` | `15` | Seconds to memorise the sequence |
| `kRecallTimerSeconds` | `60` | Seconds to recall & submit |
| `kMemoryWarningThreshold` | `5` | Timer turns red below this value (memory phase) |
| `kRecallWarningThreshold` | `10` | Timer turns red below this value (recall phase) |
| `kPrimary` | `0xFF9C27B0` | Brand purple — used across buttons & icons |

---

## Building for Release

### Android APK / AAB

```bash
flutter build apk --release
# or for Play Store upload:
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
# Then archive from Xcode: Product → Archive
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `flutter pub get` fails | Make sure Flutter SDK path is in `PATH` and run `flutter doctor` |
| Ads not showing in debug | Expected — debug mode shows Google test ads only |
| Ads not showing in release | Double-check AdMob App ID in `AndroidManifest.xml` / `Info.plist` |
| Build fails on iOS | Run `cd ios && pod install` then rebuild |
| `MobileAds.instance.initialize()` crash | Ensure AdMob App ID is set before calling `runApp()` |

---

## License

Distributed under the terms stated in the **CodeCanyon Regular / Extended License**
purchased with this item. Redistribution of the source code is not permitted.
