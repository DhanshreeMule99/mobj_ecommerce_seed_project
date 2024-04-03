import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {
  static const String token = 'token';
  static const String userId = 'userid';
  static const String deviceIds = 'deviceId';
  static const String profilePic = 'profile';
  static const String googleToken = 'googleToken';
  static const String draftId = 'draftId';

  static final SharedPreferenceManager _instance =
      SharedPreferenceManager._internal();

  factory SharedPreferenceManager() {
    return _instance;
  }

  SharedPreferenceManager._internal();

  Future<dynamic> clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> setDraftId(String tokens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(draftId, tokens);
  }

  Future<String> getDraftId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(draftId) ?? "";
  }

  Future<int> getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(deviceIds) ?? 0;
  }

  Future<bool> setDeviceId(int deviceId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(deviceIds, deviceId);
  }

  Future<bool> setToken(String tokens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(token, tokens);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(token) ?? "";
  }

  Future<bool> setGoogleToken(String tokens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(googleToken, tokens);
  }

  Future<String> getGoogleToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(googleToken) ?? "";
  }

  Future<bool> setUserId(String tokens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userId, tokens);
  }

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userId) ?? "";
  }

  Future<bool> setProfile(String tokens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(profilePic, tokens);
  }

  Future<String> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(profilePic) ?? "";
  }
}
