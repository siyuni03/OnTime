import 'package:flutter/material.dart';

class OnTimeColors {
  OnTimeColors._();

  // 메인 배경색
  static const Color background = Color(0xFFF8F5EF);

  // 메인 갈색
  static const Color primary = Color(0xFF8B5E3C);

  // 진한 갈색
  static const Color darkBrown = Color(0xFF5C4033);

  // 카드
  static const Color card = Color(0xFFFFFFFF);

  // 테두리
  static const Color border = Color(0xFFE5DED5);

  // 보조 텍스트
  static const Color secondaryText = Color(0xFF8A8178);

  // 녹색 체크
  static const Color checkGreen = Color(0xFF6B8E62);
  static const Color green = checkGreen;
}

class OnTimeTheme {
  OnTimeTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    scaffoldBackgroundColor: OnTimeColors.background,

    colorScheme: ColorScheme.fromSeed(
      seedColor: OnTimeColors.primary,
      brightness: Brightness.light,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: OnTimeColors.background,
      foregroundColor: OnTimeColors.darkBrown,
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: const CardThemeData(
      color: OnTimeColors.card,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),

    dividerTheme: const DividerThemeData(
      color: OnTimeColors.border,
      thickness: 1,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: OnTimeColors.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: OnTimeColors.border,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: OnTimeColors.border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: OnTimeColors.primary,
          width: 1.5,
        ),
      ),
    ),
  );
}