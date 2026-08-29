import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class StorageService {
  static final GetStorage _storage = GetStorage();

  // Storage Keys
  static const String _profileImageKey = 'profile_image_base64';
  static const String _userTokenKey = 'user_token';
  static const String _userDataKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  // =========================================================
  // INITIALIZE SERVICE (Call this in main.dart: await GetStorage.init())
  // =========================================================

  static Future<void> init() async {
    await GetStorage.init();
  }

  // =========================================================
  // PROFILE IMAGE
  // =========================================================

  static Future<void> saveProfileImage(List<int> bytes) async {
    final String base64Image = base64Encode(bytes);
    await _storage.write(_profileImageKey, base64Image);
  }

  static List<int>? get profileImageBytes {
    final String? base64Image = _storage.read<String>(_profileImageKey);

    if (base64Image == null || base64Image.isEmpty) {
      return null;
    }

    try {
      return base64Decode(base64Image);
    } catch (e) {
      return null;
    }
  }

  static Future<void> removeProfileImage() async {
    await _storage.remove(_profileImageKey);
  }

  // =========================================================
  // AUTH & USER SESSION
  // =========================================================

  static Future<void> saveToken(String token) async {
    await _storage.write(_userTokenKey, token);
    await _storage.write(_isLoggedInKey, true);
  }

  static String? get userToken => _storage.read<String>(_userTokenKey);

  static bool get isLoggedIn => _storage.read<bool>(_isLoggedInKey) ?? false;

  static Future<void> saveUserData(Map<String, dynamic> userJson) async {
    await _storage.write(_userDataKey, jsonEncode(userJson));
  }

  static Map<String, dynamic>? get userData {
    final String? rawJson = _storage.read<String>(_userDataKey);
    if (rawJson == null) return null;
    try {
      return jsonDecode(rawJson) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }


  // =========================================================
  // CLEAR DATA & LOGOUT
  // =========================================================

  static Future<void> clearUserData() async {
    await _storage.remove(_profileImageKey);
    await _storage.remove(_userTokenKey);
    await _storage.remove(_userDataKey);
    await _storage.write(_isLoggedInKey, false);
  }

  static Future<void> eraseAllData() async {
    await _storage.erase();
  }
}