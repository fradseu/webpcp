// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomTheme {
  // Tema Light (macOS Catalina style)
  static final ThemeData lightTheme = ThemeData(
    splashColor: Color.fromARGB(255, 85, 57, 112),
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: const Color(0xFF007AFF), // Azul do macOS
    scaffoldBackgroundColor: const Color(
      0xFFF5F5F7,
    ), // Cinza muito claro do macOS
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white.withOpacity(0.7), // Translúcido
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF007AFF), // Azul do macOS
      secondary: Color(0xFF34C759), // Verde do macOS
      surface: Colors.white,
      background: Color(0xFFF5F5F7),
      error: Color(0xFFFF3B30), // Vermelho do macOS
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      onTertiary: Color(0xFFADBAC7),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3), // Bordas mais arredondadas
      ),
      color: Colors.white.withOpacity(0.7), // Efeito translúcido
      surfaceTintColor: Colors.transparent,
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      buttonColor: const Color(0xFF007AFF),
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007AFF),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        elevation: 0, // Sem sombra como no macOS
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF007AFF),
        textStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF007AFF),
        side: const BorderSide(color: Color(0xFF007AFF)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(color: Color(0xFFC6C6C8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(color: Color(0xFFC6C6C8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(color: Color(0xFF007AFF), width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(color: Color(0xFFFF3B30)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(color: Color(0xFFFF3B30), width: 1),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.7),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF007AFF);
        }
        return const Color(0xFFC6C6C8);
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF007AFF);
        }
        return const Color(0xFFC6C6C8);
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF007AFF);
        }
        return Colors.white;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF007AFF).withOpacity(0.3);
        }
        return const Color(0xFFC6C6C8);
      }),
      trackOutlineColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF007AFF);
        }
        return const Color(0xFFC6C6C8);
      }),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Color(0xFF007AFF),
      unselectedLabelColor: Color(0xFF8E8E93),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2, color: Color(0xFF007AFF)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFC6C6C8),
      thickness: 0.5,
      space: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF007AFF),
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white.withOpacity(0.7),
      selectedItemColor: const Color(0xFF007AFF),
      unselectedItemColor: const Color(0xFF8E8E93),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF48484A),
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      elevation: 0,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Colors.white.withOpacity(0.95),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
        side: BorderSide(color: Colors.grey.shade200, width: 0.5),
      ),
      textStyle: const TextStyle(color: Colors.black),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: const Color(0xFF48484A),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: const TextStyle(color: Colors.white),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFE5E5EA),
      disabledColor: const Color(0xFFC6C6C8),
      selectedColor: const Color(0xFF007AFF),
      secondarySelectedColor: const Color(0xFF007AFF),
      labelStyle: const TextStyle(color: Colors.black),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      brightness: Brightness.light,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFF007AFF),
      linearTrackColor: Color(0xFFE5E5EA),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.black),
      displayMedium: TextStyle(color: Colors.black),
      displaySmall: TextStyle(color: Colors.black),
      headlineMedium: TextStyle(color: Colors.black),
      headlineSmall: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black),
      titleSmall: TextStyle(color: Colors.black),
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Color(0xFF8E8E93)),
      labelLarge: TextStyle(color: Colors.black),
      labelSmall: TextStyle(color: Color(0xFF8E8E93)),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white.withOpacity(0.95),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: const TextStyle(color: Colors.black),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      iconColor: const Color(0xFF007AFF),
      textColor: Colors.black,
    ),
  );

  // Tema Dark (baseado no GitHub Dark Dimmed)
  static final ThemeData darkTheme = ThemeData(
    splashColor: Color.fromARGB(255, 183, 136, 226),
    brightness: Brightness.dark,
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: const Color(0xFF1C2128), // GitHub Dark Dimmed bg
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF22272E), // GitHub Dark Dimmed header
      foregroundColor: const Color(0xFFADBAC7), // GitHub text secondary
      elevation: 1,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFADBAC7),
      ),
      iconTheme: const IconThemeData(color: Color(0xFFADBAC7)),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF6CB6FF), // GitHub blue
      secondary: Color(0xFFF69D50), // GitHub orange
      surface: Color(0xFF22272E), // GitHub Dark Dimmed surface
      background: Color(0xFF1C2128), // GitHub Dark Dimmed bg
      error: Color(0xFFF47067), // GitHub red
      onPrimary: Color(0xFF22272E),
      onSecondary: Color(0xFF22272E),
      onSurface: Color(0xFFADBAC7), // GitHub text secondary
      onBackground: Color(0xFFADBAC7),
      onError: Color(0xFF22272E),
      onTertiary: Color(0xFF444C56),
    ),
    cardTheme: CardTheme(
      elevation: 1,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color.fromARGB(
        255,
        65,
        69,
        87,
      ), // GitHub Dark Dimmed surface
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      buttonColor: const Color(0xFF6CB6FF), // GitHub blue
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6CB6FF), // GitHub blue
        foregroundColor: const Color(0xFF22272E),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF6CB6FF), // GitHub blue
        textStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF6CB6FF), // GitHub blue
        side: const BorderSide(color: Color(0xFF6CB6FF)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(color: Color(0xFF444C56)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(color: Color(0xFF444C56)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(color: Color(0xFF6CB6FF), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(color: Color(0xFFF47067)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(color: Color(0xFFF47067), width: 2),
      ),
      filled: true,
      fillColor: const Color(0xFF22272E),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      hintStyle: const TextStyle(
        color: Color(0xFF768390),
      ), // GitHub text tertiary
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF6CB6FF); // GitHub blue
        }
        return const Color(0xFF444C56); // GitHub border
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF6CB6FF); // GitHub blue
        }
        return const Color(0xFF444C56); // GitHub border
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF6CB6FF); // GitHub blue
        }
        return const Color(0xFF768390); // GitHub text tertiary
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF6CB6FF).withOpacity(0.5);
        }
        return const Color(0xFF444C56).withOpacity(0.5);
      }),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Color(0xFF6CB6FF), // GitHub blue
      unselectedLabelColor: Color(0xFF768390), // GitHub text tertiary
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2, color: Color(0xFF6CB6FF)),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF444C56), // GitHub border
      thickness: 1,
      space: 1,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF6CB6FF), // GitHub blue
      foregroundColor: Color(0xFF22272E),
      elevation: 4,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF22272E), // GitHub Dark Dimmed surface
      selectedItemColor: Color(0xFF6CB6FF), // GitHub blue
      unselectedItemColor: Color(0xFF768390), // GitHub text tertiary
      elevation: 2,
      type: BottomNavigationBarType.fixed,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF444C56),
      contentTextStyle: const TextStyle(color: Color(0xFFADBAC7)),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: const Color(0xFF22272E),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
        side: const BorderSide(color: Color(0xFF444C56)),
      ),
      textStyle: const TextStyle(color: Color(0xFFADBAC7)),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: const Color(0xFF444C56),
        borderRadius: BorderRadius.circular(4),
      ),
      textStyle: const TextStyle(color: Color(0xFFADBAC7)),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF2D333B),
      disabledColor: const Color(0xFF444C56),
      selectedColor: const Color(0xFF6CB6FF),
      secondarySelectedColor: const Color(0xFF6CB6FF),
      labelStyle: const TextStyle(color: Color(0xFFADBAC7)),
      secondaryLabelStyle: const TextStyle(color: Color(0xFF22272E)),
      brightness: Brightness.dark,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFF6CB6FF), // GitHub blue
      linearTrackColor: Color(0xFF444C56), // GitHub border
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color(0xFFADBAC7)),
      displayMedium: TextStyle(color: Color(0xFFADBAC7)),
      displaySmall: TextStyle(color: Color(0xFFADBAC7)),
      headlineMedium: TextStyle(color: Color(0xFFADBAC7)),
      headlineSmall: TextStyle(color: Color(0xFFADBAC7)),
      titleLarge: TextStyle(color: Color(0xFFADBAC7)),
      titleMedium: TextStyle(color: Color(0xFFADBAC7)),
      titleSmall: TextStyle(color: Color(0xFFADBAC7)),
      bodyLarge: TextStyle(color: Color(0xFFADBAC7)),
      bodyMedium: TextStyle(color: Color(0xFFADBAC7)),
      bodySmall: TextStyle(color: Color(0xFF768390)), // GitHub text tertiary
      labelLarge: TextStyle(color: Color(0xFFADBAC7)),
      labelSmall: TextStyle(color: Color(0xFF768390)),
    ),
  );
}
