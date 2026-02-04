import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing user session and app state persistence
class SessionService {
  // SharedPreferences keys
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyFirstLaunch = 'first_launch';
  static const String _keyUserLocation = 'user_location';

  /// Check if this is the first time launching the app
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFirstLaunch) ?? true;
  }

  /// Mark the app as having been launched
  Future<void> setFirstLaunchCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFirstLaunch, false);
  }

  /// Check if user has completed onboarding
  Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  /// Mark onboarding as completed
  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, true);
  }

  /// Save user location
  Future<void> saveUserLocation(String location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserLocation, location);
  }

  /// Get saved user location
  Future<String?> getUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserLocation);
  }

  /// Clear all session data (for logout)
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserLocation);
    // Keep onboarding status even after logout
  }

  /// Reset everything (for testing/debugging)
  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
