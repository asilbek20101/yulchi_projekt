import 'package:flutter/material.dart';

import 'package:meta_ai_projekt/page/app_settings.dart';
import 'package:meta_ai_projekt/page1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeMode,
      builder: (context, themeMode, child) {
        return ValueListenableBuilder<String>(
          valueListenable: appLanguage,
          builder: (context, language, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              theme: ThemeData(
                brightness: Brightness.light,
                useMaterial3: true,
                scaffoldBackgroundColor: const Color(0xFFF5F7F6),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF20D99A),
                  brightness: Brightness.light,
                ),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                ),
                inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                  fillColor: Color(0xFFF0F3F1),
                ),
                bottomSheetTheme: const BottomSheetThemeData(
                  backgroundColor: Colors.white,
                ),
                dialogTheme: const DialogThemeData(
                  backgroundColor: Colors.white,
                ),
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                useMaterial3: true,
                scaffoldBackgroundColor: const Color(0xFF050806),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF20D99A),
                  brightness: Brightness.dark,
                ),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF050806),
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                  fillColor: Color(0xFF101713),
                ),
                bottomSheetTheme: const BottomSheetThemeData(
                  backgroundColor: Color(0xFF0D1411),
                ),
                dialogTheme: const DialogThemeData(
                  backgroundColor: Color(0xFF0D1411),
                ),
              ),
              home: const Page1(),
            );
          },
        );
      },
    );
  }
}
