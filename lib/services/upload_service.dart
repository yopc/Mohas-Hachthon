import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  static const String cloudName = 'YOUR_CLOUD_NAME';
  static const String uploadPreset = 'YOUR_UPLOAD_PRESET';

  static Future<String?> uploadImage(File imageFile) async {
    try {
      final cloudinary = CloudinaryPublic(cloudName, uploadPreset, cache: false);
      
      final CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
        ),
      );

      return response.secureUrl; // The public URL of your uploaded image
    } catch (e) {
      print('Upload failed: $e');
      return null;
    }
  }

  static Future<XFile?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }
}