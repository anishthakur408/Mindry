import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Keys
  static const String _keyFirstLaunch = 'first_launch';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLastOpenedDate = 'last_opened_date';
  static const String _keyTotalEntries = 'total_entries';

  // First Launch
  static bool get isFirstLaunch {
    return _prefs?.getBool(_keyFirstLaunch) ?? true;
  }

  static Future<void> setFirstLaunchComplete() async {
    await _prefs?.setBool(_keyFirstLaunch, false);
  }

  // Theme Mode
  static String get themeMode {
    return _prefs?.getString(_keyThemeMode) ?? 'dark';
  }

  static Future<void> setThemeMode(String mode) async {
    await _prefs?.setString(_keyThemeMode, mode);
  }

  // Last Opened Date
  static DateTime? get lastOpenedDate {
    final dateString = _prefs?.getString(_keyLastOpenedDate);
    if (dateString != null) {
      return DateTime.parse(dateString);
    }
    return null;
  }

  static Future<void> setLastOpenedDate(DateTime date) async {
    await _prefs?.setString(_keyLastOpenedDate, date.toIso8601String());
  }

  // Total Entries (for stats)
  static int get totalEntries {
    return _prefs?.getInt(_keyTotalEntries) ?? 0;
  }

  static Future<void> setTotalEntries(int count) async {
    await _prefs?.setInt(_keyTotalEntries, count);
  }

  // Clear all preferences
  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
