import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark }

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  ThemeNotifier() : super(AppThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('theme') ?? 'light';
    state = savedTheme == 'dark' ? AppThemeMode.dark : AppThemeMode.light;
  }

  Future<void> toggleTheme() async {
    state =
        state == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'theme',
      state == AppThemeMode.dark ? 'dark' : 'light',
    );
  }
}
