import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memory_sequence/core/app_constants.dart';
import 'package:memory_sequence/screen/splash_screen.dart';
import 'package:memory_sequence/services/ad_service.dart';
import 'package:memory_sequence/services/game_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Initialize AdMob SDK before the app starts
  await AdService().initialize();
  runApp(const MemoryGameApp());
}

class MemoryGameApp extends StatelessWidget {
  const MemoryGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: GameService(),
      builder: (context, _) {
        final isDark = GameService().isDarkMode;
        return MaterialApp(
          title: 'Memory Sequence',
          debugShowCheckedModeBanner: false,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: AppConstants.kPrimary,
            fontFamily: 'sans-serif',
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: AppConstants.kPrimary,
            fontFamily: 'sans-serif',
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
