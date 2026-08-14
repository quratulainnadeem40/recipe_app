import 'dart:convert';

import 'package:get_storage/get_storage.dart';

class StorageService {
  static final GetStorage _storage = GetStorage();

  static const String _profileImageKey =
      'profile_image_base64';

  // =========================================================
  // SAVE PROFILE IMAGE
  // =========================================================

  static Future<void> saveProfileImage(
    List<int> bytes,
  ) async {
    final String base64Image = base64Encode(bytes);

    await _storage.write(
      _profileImageKey,
      base64Image,
    );
  }

  // =========================================================
  // GET PROFILE IMAGE
  // =========================================================

  static List<int>? get profileImageBytes {
    final String? base64Image =
        _storage.read<String>(_profileImageKey);

    if (base64Image == null || base64Image.isEmpty) {
      return null;
    }

    try {
      return base64Decode(base64Image);
    } catch (e) {
      return null;
    }
  }

  // =========================================================
  // REMOVE PROFILE IMAGE
  // =========================================================

  static Future<void> removeProfileImage() async {
    await _storage.remove(_profileImageKey);
  }

  // =========================================================
  // CLEAR USER DATA
  // =========================================================

  static Future<void> clearUserData() async {
    await _storage.remove(_profileImageKey);
  }
}