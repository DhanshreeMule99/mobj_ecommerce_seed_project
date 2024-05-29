import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {
  static const String token = 'token';
  static const String userId = 'userid';
  static const String deviceIds = 'deviceId';
  static const String profilePic = 'profile';
  static const String googleToken = 'googleToken';
  static const String draftId = 'draftId';
  static const String name = 'name';
  static const String email = 'email';
  static const String wishlistId = 'wishlistId';
  static const String cartKey = 'cartkey';
  static const String customer_id = 'customer_id';
  static const String logoImg = 'logoImage';

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

  Future<String> getLogoImg() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(logoImg) ?? '';
  }

  Future<void> setLogoImg(String img) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(logoImg, img);
  }

  Future<String> getDraftId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(draftId) ?? "";
  }

  Future<bool> setEmail(String emailId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(email, emailId);
  }

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(email) ?? "";
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

  Future<bool> setCartToken(String tokens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(cartKey, tokens);
  }

  Future<String> getCartToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(cartKey) ?? "";
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

  Future<bool> setAddressId(String tokens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(customer_id, tokens);
  }

  Future<String> getAddressId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(customer_id) ?? "";
  }

  Future<bool> setProfile(String tokens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(profilePic, tokens);
  }

  Future<String> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(profilePic) ?? "";
  }

  Future<String> getname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(name) ?? "";
  }

  Future<bool> setname(String tokens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(name, tokens);
  }

  Future<String> getemail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(email) ?? "";
  }

  Future<bool> setemail(String tokens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(email, tokens);
  }

  Future<String> getwishlistID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(wishlistId) ?? "";
  }

  Future<bool> setWishlistId(String tokens) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(wishlistId, tokens);
  }
}
