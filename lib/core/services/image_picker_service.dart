import 'dart:developer';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  // Pick single image from Gallery
  static Future<Uint8List?> pickFromGallery({int imageQuality = 80}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
      );

      if (image == null) return null;
      return await image.readAsBytes();
    } catch (e) {
      log('Error picking image from gallery: $e');
      return null;
    }
  }

  // Pick single image from Camera
  static Future<Uint8List?> pickFromCamera({int imageQuality = 80}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
      );

      if (image == null) return null;
      return await image.readAsBytes();
    } catch (e) {
      log('Error picking image from camera: $e');
      return null;
    }
  }
}