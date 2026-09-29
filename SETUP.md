# Memory Sequence — Setup & Configuration Guide

> **Flutter Version:** 3.38.7 • Dart 3.10.7 • DevTools 2.51.1  
> **Version:** 1.0.0+1  
> **Platforms:** Android & iOS

---

## Table of Contents

1. [App Overview](#1-app-overview)
2. [App Features](#2-app-features)
3. [How to Play](#3-how-to-play)
4. [UI & User Experience](#4-ui--user-experience)
5. [What Is Included](#5-what-is-included)
6. [Requirements & Environment Setup](#6-requirements--environment-setup)
7. [Google AdMob Integration](#7-google-admob-integration)
8. [Android Release Signing Setup](#8-android-release-signing-setup)
9. [Build Release APK / App Bundle](#9-build-release-apk--app-bundle)
10. [iOS Release Build](#10-ios-release-build)
11. [Run in Development (Test Ads)](#11-run-in-development-test-ads)
12. [Change App Icon (Android & iOS)](#12-change-app-icon-android--ios)
13. [Change Package Name](#13-change-package-name)
14. [Platform Support](#14-platform-support)
15. [Support](#15-support)
16. [Troubleshooting / FAQ](#16-troubleshooting--faq)
17. [Changelog](#17-changelog)

---

## 1. App Overview

**Memory Sequence** is a premium cognitive memory game built with Flutter. Players memorize a sequence of 8 branded images displayed in a grid, then recall the exact order from memory. The game tracks best scores, maintains a top-10 leaderboard, and features full Google AdMob monetization with Banner, Interstitial, and Rewarded ad formats.

---

## 2. App Features

### Core Gameplay Features
- 🧠 **Sequence Memory Challenge** — Memorize 8 randomly shuffled images in a 4×4 grid
- ⏱️ **Dual-Phase Timer** — 15-second memorization timer + 60-second recall timer
- ✅ **Accuracy Scoring** — Score calculated by exact positional match (0–8 correct)
- 📊 **Performance Feedback** — Color-coded result levels: Perfect Memory, Excellent, Good Job, Fair, Keep Practicing
- 🃏 **Sequence Comparison** — Side-by-side correct vs. user answer grid with ✓/✗ indicators
- 🔀 **Random Shuffle** — Images and colors are uniquely shuffled each round

### Google AdMob Integration
- 📢 **Banner Ad** — Displayed at the bottom of Home Screen and Result Screen
- 💥 **Interstitial Ad** — Full-screen ad shown after every game result is saved
- 🎁 **Rewarded Ad** — User can optionally watch an ad on the Result Screen to reveal the correct sequence animation
- 🔁 **Auto-reload** — Ads automatically reload after being shown or dismissed
- 🧪 **Test Mode** — Google's official test ad IDs are used automatically in `kDebugMode` — no config required to run locally

### Leaderboard & Score Tracking
- ⭐ **Best Score Card** — Displayed on the Home Screen, persisted via SharedPreferences
- 🏆 **Top-10 Leaderboard** — Sorted by score, with player name, date, and accuracy percentage
- 📝 **Player Name Dialog** — Prompts for a name after each game to save to the leaderboard
- 💡 **New Best Badge** — Gold "NEW BEST!" badge shown on the Result Screen when a new high score is set

### Game State Management
- ⏸️ **Pause / Resume** — Available during both Memorize and Recall phases
- 🚪 **Quit Confirmation Dialog** — Prompted when pressing close or quit, prevents accidental exit
- 🌙 **Dark / Light Mode** — Global toggle, persisted across sessions

---

## 3. How to Play

### Step 1 — Launch the Game
Open the app. The **Home Screen** shows your current best score and two navigation options: **Leaderboard** and **Settings**.

### Step 2 — Start a Game
Tap **Play Now** to begin.

### Step 3 — Memorize Phase (15 Seconds)
- A 4×4 grid of **8 images** appears, each numbered 1–8
- **Remember the order** (position 1 to 8) carefully
- A countdown timer shows how much time remains; it turns red when ≤ 5 seconds
- You can **Pause** the timer at any time, or **Close** to quit

### Step 4 — Recall Phase (60 Seconds)
- The images are **shuffled** into a new random order
- Tap each image **in the order you memorized** (1 → 8)
- Your selected sequence fills the slot row at the top
- Tap a selected image again to **deselect** it
- When all 8 slots are filled, the **Submit Answer** button activates (turns green)
- You can also submit when time runs out

### Step 5 — Results
- Your score (e.g. **6 / 8**) with accuracy percentage is displayed
- A comparison grid shows the **Correct** sequence vs. **Your Answer** (green ✓ or red ✗ per position)
- If you set a new best score, a gold **NEW BEST!** badge appears
- **Watch Ad → View Correct Sequence** button lets you watch a Rewarded ad to see the correct order highlighted
- Tap **Play Again** to restart immediately, or **Home** to return to the Home Screen

### Scoring Levels
| Accuracy | Level |
|---|---|
| 100% (8/8) | 🏆 Perfect Memory! |
| 75%+ (6–7/8) | 🌟 Excellent |
| 50%+ (4–5/8) | 👍 Good Job |
| 25%+ (2–3/8) | 💪 Fair |
| < 25% (0–1/8) | 🎯 Keep Practicing |

---

## 4. UI & User Experience

| Feature | Detail |
|---|---|
| **Theme** | Dark Mode (default) with full Light Mode support |
| **Color Palette** | Deep purple (`#0A0015` bg, `#9C27B0` accent) with gradient glows |
| **Typography** | Flutter Material font with bold weight hierarchy |
| **Animations** | Glowing brain icon pulse, staggered fade-slide entrance, scale-in result card |
| **Micro-interactions** | Button press scale (0.96×), animated countdown switcher |
| **Splash Screen** | Animated gradient splash with logo before home screen |
| **Responsive** | Adapts to all phone screen sizes with safe area support |
| **Accessibility** | High-contrast text, clear icon labels, large tap targets |

---

## 5. What Is Included

```
Memory-Sequence/
├── lib/
│   ├── main.dart                       # App entry point, AdMob init
│   ├── model/
│   │   ├── game_category.dart          # Game category model & category list
│   │   └── image_data.dart             # Image data model
│   ├── screen/
│   │   ├── splash_screen.dart          # Animated splash screen
│   │   ├── home_screen.dart            # Home with best score & navigation
│   │   ├── category_select_screen.dart # Category selection screen
│   │   ├── how_to_play_screen.dart     # How to play instructions screen
│   │   ├── memory_phase_screen.dart    # Memorize phase (15s countdown)
│   │   ├── recall_phase_screen.dart    # Recall phase (60s, tap to sort)
│   │   ├── result_screen.dart          # Score, comparison, rewarded ad
│   │   ├── leaderboard_screen.dart     # Top-10 leaderboard
│   │   └── settings_screen.dart        # Dark mode toggle, reset options
│   ├── services/
│   │   ├── ad_service.dart             # AdMob singleton (banner/interstitial/rewarded)
│   │   └── game_service.dart           # Score, leaderboard, dark mode (SharedPrefs)
│   └── widgets/
│       ├── banner_ad_widget.dart       # Reusable banner widget
│       └── game_dialogs.dart           # Pause & Quit confirmation dialogs
├── assets/                             # Category image assets
│   │                                   # Categories: animal, flower, fruits,
│   │                                   # vegetable, birds, trees, insects,
│   │                                   # fish & sea, crops
├── android/                            # Android-specific config
├── ios/                                # iOS-specific config
├── pubspec.yaml                        # Dependencies
├── SETUP.md                            # This guide
└── CHANGELOG.md                        # Version history
```

**Dependencies:**
| Package | Version | Purpose |
|---|---|---|
| `google_mobile_ads` | ^7.0.0 | AdMob Banner, Interstitial, Rewarded |
| `shared_preferences` | ^2.3.2 | Persist scores, leaderboard, settings |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |

---

## 6. Requirements & Environment Setup

### Flutter & Dart
```bash
flutter --version
# Flutter 3.38.7 • Dart 3.10.7 • DevTools 2.51.1
```

Ensure Flutter is installed and the stable channel is active:
```bash
flutter channel stable
flutter upgrade
```

### Open & Install

After purchasing the source code, extract the package and open the project folder:

```bash
# 1. Open the project in your IDE (VS Code / Android Studio)
# 2. Clean any previous build artifacts
flutter clean

# 3. Fetch all dependencies
flutter pub get

# 4. Run the app on a connected device or emulator
flutter run
```

### Verify Setup
```bash
flutter doctor -v
```
All checks should pass for Android and/or iOS.

---

## 7. Google AdMob Integration

### Step 1 — Create an AdMob Account
1. Go to [https://admob.google.com](https://admob.google.com) and sign in
2. Create a new app for both Android and iOS
3. Note your **App ID** (format: `ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX`)
4. Create three Ad Units per platform: **Banner**, **Interstitial**, **Rewarded**
5. Note each **Ad Unit ID** (format: `ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX`)

---

### Step 2 — Set App ID in Android Manifest

Open `android/app/src/main/AndroidManifest.xml` and replace the test App ID:

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"/>
<!--                  ↑ Replace with your real Android AdMob App ID ↑ -->
```

---

### Step 3 — Set App ID in iOS Info.plist

Open `ios/Runner/Info.plist` and add (or replace) inside `<dict>`:

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX</string>
<!--           ↑ Replace with your real iOS AdMob App ID ↑ -->
```

Also add SKAdNetworkIdentifiers for iOS 14+ compliance:
```xml
<key>SKAdNetworkItems</key>
<array>
  <dict>
    <key>SKAdNetworkIdentifier</key>
    <string>cstr6suwn9.skadnetwork</string>
  </dict>
</array>
```

---

### Step 4 — Set Ad Unit IDs in Code

Open `lib/services/ad_service.dart` and replace the placeholder IDs:

```dart
class AdIds {
  // ── Android ──────────────────────────────────────
  static const String _androidBanner      = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String _androidInterstitial = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String _androidRewarded    = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';

  // ── iOS ──────────────────────────────────────────
  static const String _iosBanner          = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String _iosInterstitial    = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
  static const String _iosRewarded        = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
}
```

> ⚠️ **Important:** Never commit real Ad Unit IDs to a public repository.  
> Test IDs are used automatically when `kDebugMode == true` — no changes needed for development.

---

### Run in Development (Test Ads)

When running in debug mode (`flutter run`), the app automatically uses Google's official **test Ad Unit IDs**:

| Ad Type | Test ID |
|---|---|
| Banner | `ca-app-pub-3940256099942544/6300978111` |
| Interstitial | `ca-app-pub-3940256099942544/1033173712` |
| Rewarded | `ca-app-pub-3940256099942544/5224354917` |

The test App ID used in `AndroidManifest.xml` is: `ca-app-pub-3940256099942544~3347511713`

These are Google's official test IDs and **will always serve test ads** — safe to run without an AdMob account.

```bash
flutter run
```

---

## 8. Android Release Signing Setup

### Step 1 — Generate a Keystore

Run this command once to create your signing keystore:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

Fill in the prompts (name, organization, country, etc.) and choose a strong password.

> ⚠️ **Keep your keystore file safe!** Losing it means you cannot update your app on the Play Store.

---

### Step 2 — Create `key.properties`

Create the file `android/key.properties` (this file is gitignored by default):

```properties
storePassword=<your_keystore_password>
keyPassword=<your_key_password>
keyAlias=upload
storeFile=<absolute_path_to>/upload-keystore.jks
```

Example (macOS):
```properties
storePassword=MyStorePass123
keyPassword=MyKeyPass123
keyAlias=upload
storeFile=/Users/yourname/upload-keystore.jks
```

> ✅ Verify `android/.gitignore` contains `key.properties` to prevent accidental commits.

---

### Step 3 — Configure Signing in `build.gradle.kts`

Open `android/app/build.gradle.kts` and add the following sections:

**At the top**, before `android {`:

```kotlin
import java.util.Properties
import java.io.FileInputStream

val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties()
if (keyPropertiesFile.exists()) {
    keyProperties.load(FileInputStream(keyPropertiesFile))
}
```

**Inside `android {`**, add the signing config:

```kotlin
signingConfigs {
    create("release") {
        keyAlias     = keyProperties["keyAlias"] as String
        keyPassword  = keyProperties["keyPassword"] as String
        storeFile    = file(keyProperties["storeFile"] as String)
        storePassword = keyProperties["storePassword"] as String
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
        isMinifyEnabled = true
        isShrinkResources = true
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
}
```

---

## 9. Build Release APK / App Bundle

### Release APK (direct install / testing)

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Release App Bundle (Google Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

> ✅ Upload the `.aab` file to Google Play Console for production distribution.

---

## 10. iOS Release Build

### Prerequisites
- macOS with Xcode 15+ installed
- An Apple Developer account ($99/year)
- App registered in [App Store Connect](https://appstoreconnect.apple.com)

### Step 1 — Open in Xcode
```bash
open ios/Runner.xcworkspace
```

### Step 2 — Configure Signing
1. In Xcode, select the **Runner** target
2. Go to **Signing & Capabilities**
3. Select your **Team** (Apple Developer account)
4. Set **Bundle Identifier** to your package name (e.g. `com.yourcompany.memorysequence`)
5. Ensure **Automatically manage signing** is checked

### Step 3 — Update Version (if needed)
In `pubspec.yaml`:
```yaml
version: 1.0.0+1
#        ↑     ↑
#        |     Build number (CFBundleVersion)
#        Version name (CFBundleShortVersionString)
```

### Step 4 — Archive & Upload
```bash
flutter build ipa --release
```

Or use Xcode: **Product → Archive → Distribute App → App Store Connect**

> ✅ After upload, submit for review in App Store Connect.

---

## 12. Change App Icon (Android & iOS)

### Recommended Tool: `flutter_launcher_icons`

**Step 1** — Add to `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"  # Your square icon (1024×1024 px recommended)
  min_sdk_android: 21
  adaptive_icon_background: "#9C27B0"     # Android adaptive background color
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"
```

**Step 2** — Place your icon at the specified path.

**Step 3** — Run:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

### Manual Method

**Android:**
- Replace all files in `android/app/src/main/res/mipmap-*/ic_launcher.png`
- Sizes needed: `mdpi` (48×48), `hdpi` (72×72), `xhdpi` (96×96), `xxhdpi` (144×144), `xxxhdpi` (192×192)

**iOS:**
- Open Xcode → `Runner` → `Assets.xcassets` → `AppIcon`
- Drag and drop your icons into each slot (sizes 20pt – 1024pt)

---

## 13. Change Package Name

### Android

Open `android/app/build.gradle.kts` and update:
```kotlin
android {
    defaultConfig {
        applicationId = "com.yourcompany.memorysequence"  // ← Change this
    }
}
```

Also rename the directory structure in `android/app/src/main/kotlin/` to match your new package.

Update `AndroidManifest.xml`:
```xml
<manifest package="com.yourcompany.memorysequence">
```

### iOS

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Runner** target → **General** tab
3. Change **Bundle Identifier** to `com.yourcompany.memorysequence`

### pubspec.yaml

The `name` field in `pubspec.yaml` is the Dart package name (used in imports). Update it and all `package:memory_sequence/...` import paths throughout the codebase:

```yaml
name: your_new_package_name
```

Then run `dart fix --apply` or use your IDE's rename refactoring to update all imports at once.

---

## 14. Platform Support

| Platform | Status |
|---|---|
| Android | ✅ Fully supported (API 21+) |
| iOS | ✅ Fully supported (iOS 13+) |
| Web | ❌ Not supported (google_mobile_ads is mobile-only) |
| macOS / Windows / Linux | ❌ Not supported |

---

## 15. Support

For questions, customization requests, or bug reports:

- 👤 **Developer:** [hitaish_i](https://codecanyon.net/user/hitaish_i) on CodeCanyon
- 📧 Contact the author via the CodeCanyon item page
- 🐛 Please include your Flutter version (`flutter --version`) and the full error log
- 📱 Specify the device/OS version where the issue occurs

---

## 16. Troubleshooting / FAQ

### ❓ The app runs but ads are not showing
- **Cause:** You are running in release mode without real Ad Unit IDs, or the AdMob account is not yet approved.
- **Fix:** In debug mode (`flutter run`), test ads are served automatically — no action needed. For release, ensure you have replaced all placeholder IDs in `lib/services/ad_service.dart` with your real IDs from the AdMob console. New AdMob accounts may take up to 24 hours to start serving ads.

---

### ❓ `flutter pub get` fails with dependency conflicts
- **Cause:** Mismatch between your local Flutter/Dart SDK version and the package constraints.
- **Fix:**
  ```bash
  flutter clean
  flutter channel stable
  flutter upgrade
  flutter pub get
  ```
  Ensure you are on **Flutter 3.38.7 / Dart 3.10.7** or a compatible stable release.

---

### ❓ Build fails with `Keystore file not found`
- **Cause:** The `android/key.properties` file is missing or the path to the `.jks` file is incorrect.
- **Fix:** Re-create `android/key.properties` as described in [Section 8](#8-android-release-signing-setup) and verify the `storeFile` path is absolute and the file exists at that location.

---

### ❓ iOS build fails with `No signing certificate` or provisioning profile error
- **Cause:** Xcode signing is not configured correctly.
- **Fix:**
  1. Open `ios/Runner.xcworkspace` in Xcode.
  2. Select the **Runner** target → **Signing & Capabilities**.
  3. Choose your **Team** and ensure **Automatically manage signing** is checked.
  4. If the issue persists, go to **Xcode → Preferences → Accounts** and re-download your provisioning profiles.

---

### ❓ The leaderboard does not save scores between app sessions
- **Cause:** `SharedPreferences` may not have been initialized before the first write.
- **Fix:** Ensure `WidgetsFlutterBinding.ensureInitialized()` is called before any async calls in `main.dart`. Run `flutter clean && flutter pub get && flutter run` to rule out stale build artifacts.

---

### ❓ The app icon did not change after running `flutter_launcher_icons`
- **Cause:** The old icon may still be cached in the build directory.
- **Fix:**
  ```bash
  flutter clean
  flutter pub get
  flutter pub run flutter_launcher_icons
  flutter run
  ```
  On iOS, also uninstall the app from the simulator/device before re-running.

---

### ❓ `flutter doctor` reports issues with Android licenses
- **Fix:**
  ```bash
  flutter doctor --android-licenses
  ```
  Accept all licenses when prompted.

---

### ❓ Game images are not loading / appear broken
- **Cause:** Asset paths may be incorrect or the assets are not listed in `pubspec.yaml`.
- **Fix:** Open `pubspec.yaml` and confirm the `assets/` directory is correctly declared under the `flutter:` key:
  ```yaml
  flutter:
    assets:
      - assets/
  ```
  Then run `flutter pub get` and `flutter run`.

---

### ❓ I changed the package name but imports are broken
- **Fix:** After updating `name` in `pubspec.yaml`, run:
  ```bash
  dart fix --apply
  ```
  Or use your IDE's **Rename** refactoring to update all `package:memory_sequence/...` imports across the project automatically.

---

### ❓ AdMob `APPLICATION_ID` error on Android startup (`Tag: Ads`, `IllegalStateException`)
- **Cause:** The AdMob App ID in `AndroidManifest.xml` does not match the one registered in your AdMob console.
- **Fix:** Double-check the value of `com.google.android.gms.ads.APPLICATION_ID` in `android/app/src/main/AndroidManifest.xml` and ensure it exactly matches your AdMob **App ID** (not Ad Unit ID).

---

## 17. Changelog

All notable changes to **Memory Sequence** are documented here.  
This project follows [Semantic Versioning](https://semver.org/) (`MAJOR.MINOR.PATCH+BUILD`).

---

### [1.0.0+1] — 2026-04-28 — Initial Release

#### 🎉 Added
- **Core Gameplay** — 4×4 image grid with 15-second memorize phase and 60-second recall phase
- **9 Image Categories** — Animal, Flower, Fruits, Vegetable, Birds, Trees, Insects, Fish & Sea, Crops
- **Dual-Phase Timer** — Countdown timers with red warning at ≤ 5 seconds
- **Accuracy Scoring** — Exact positional match scoring (0–8) with five performance levels
- **Sequence Comparison Screen** — Side-by-side correct vs. user answer grid with ✓/✗ indicators
- **Top-10 Leaderboard** — Sorted by score, persisted via `SharedPreferences`
- **Player Name Dialog** — Prompts for a name after each game session
- **New Best Badge** — Gold "NEW BEST!" badge on the Result Screen
- **Google AdMob Integration** — Banner, Interstitial, and Rewarded ad formats
- **Test Ad Mode** — Official Google test IDs used automatically in `kDebugMode`
- **Pause / Resume** — Available in both Memorize and Recall phases
- **Quit Confirmation Dialog** — Prevents accidental exit mid-game
- **Dark / Light Mode Toggle** — Persisted across sessions via `SharedPreferences`
- **Animated Splash Screen** — Gradient splash with logo before Home Screen
- **Category Selection Screen** — Choose from 9 themed image sets before each round
- **How to Play Screen** — Step-by-step in-app instructions
- **Settings Screen** — Dark mode toggle and score/leaderboard reset options
- **Android Support** — API 21+ (Android 5.0 Lollipop and above)
- **iOS Support** — iOS 13 and above
- **Full AdMob Setup Guide** — Documented in `SETUP.md`
- **Android Release Signing Guide** — Keystore generation and `build.gradle.kts` configuration
- **iOS Release Build Guide** — Xcode signing and App Store Connect upload steps

#### 🔧 Technical
- Flutter 3.38.7 / Dart 3.10.7
- `google_mobile_ads: ^7.0.0` for AdMob
- `shared_preferences: ^2.3.2` for local persistence
- `cupertino_icons: ^1.0.8` for iOS-style icons
- `AdService` singleton with auto-reload after each ad dismissal
- `GameService` singleton managing scores, leaderboard, and theme preference

---

*Memory Sequence — Developed by **hitaish_i** — © 2026. All rights reserved.*
