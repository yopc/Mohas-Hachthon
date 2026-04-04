import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class CloudinaryService {
  // ⚠️ REPLACE THESE WITH YOUR ACTUAL CLOUDINARY CREDENTIALS ⚠️
  static const String cloudName = 'djxjxdy6x';
  static const String uploadPreset = 'Moas project';

  // Unified entry point – decides platform
  static Future<String?> uploadImage(File imageFile, {Uint8List? bytes, String? fileName}) async {
    if (kIsWeb) {
      if (bytes == null || fileName == null) {
        throw Exception('Web upload requires bytes and fileName');
      }
      return await _uploadImageWeb(bytes, fileName);
    } else {
      return await _uploadImageMobile(imageFile);
    }
  }

  // Mobile upload (uses cloudinary_public package)
  static Future<String?> _uploadImageMobile(File imageFile) async {
    print('📱 Mobile upload: ${imageFile.path}');
    if (cloudName == 'djxjxdy6x' || uploadPreset == 'Moas project') {
      throw Exception('Cloudinary not configured. Please set cloudName and uploadPreset.');
    }
    try {
      final cloudinary = CloudinaryPublic(cloudName, uploadPreset, cache: false);
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path, resourceType: CloudinaryResourceType.Image),
      );
      return response.secureUrl;
    } catch (e) {
      print('❌ Mobile upload failed: $e');
      rethrow;
    }
  }

  // Web upload (uses HTTP multipart)
  static Future<String?> _uploadImageWeb(Uint8List bytes, String filename) async {
    print('🌐 Web upload: $filename');
    if (cloudName == 'YOUR_CLOUD_NAME' || uploadPreset == 'YOUR_UPLOAD_PRESET') {
      throw Exception('Cloudinary not configured. Please set cloudName and uploadPreset.');
    }
    try {
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
      final request = http.MultipartRequest('POST', uri);
      request.fields['upload_preset'] = uploadPreset;
      request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: filename));
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final json = jsonDecode(responseData);
        return json['secure_url'];
      } else {
        throw Exception('Cloudinary responded with status ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Web upload failed: $e');
      rethrow;
    }
  }
}