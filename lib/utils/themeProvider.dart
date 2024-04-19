import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeProvider, bool>((ref) {
  return ThemeProvider(ref.read);
});

final languageProvider = StateNotifierProvider<LanguageProvider, String>((ref) {
  return LanguageProvider(ref.read);
});
class ThemeProvider extends StateNotifier<bool> {
  final read;

  ThemeProvider(this.read) : super(false) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('isDarkMode') ?? false;
  }

  Future<void> toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = !state;
    await prefs.setBool('isDarkMode', state);
  }
}
class LanguageProvider extends StateNotifier<String> {
  final read;

  LanguageProvider(this.read) : super('en') {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = prefs.getString('language') ?? 'en';
  }

  Future<void> toggleLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = languageCode;
    await prefs.setString('language', state);
  }
}

