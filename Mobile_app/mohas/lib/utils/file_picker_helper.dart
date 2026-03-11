// import 'dart:io';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class FilePickerHelper {
//   // Pick image from gallery or camera and convert to base64
//   static Future<Map<String, String>?> pickImage({bool fromCamera = false}) async {
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(
//         source: fromCamera ? ImageSource.camera : ImageSource.gallery,
//         maxWidth: 800,
//         maxHeight: 800,
//         imageQuality: 70,
//       );
      
//       if (image != null) {
//         File imageFile = File(image.path);
//         List<int> imageBytes = await imageFile.readAsBytes();
//         String base64Image = base64Encode(imageBytes);
        
//         // Debug print to verify we have data
//         debugPrint('Image picked: ${image.name}, size: ${imageBytes.length} bytes');
        
//         return {
//           'base64': base64Image,
//           'fileName': image.name,
//           'fileType': 'image',
//         };
//       }
//       return null;
//     } catch (e) {
//       debugPrint('Error picking image: $e');
//       return null;
//     }
//   }

//   // Pick any file and convert to base64
//   static Future<Map<String, String>?> pickFile({
//     List<String>? allowedExtensions,
//   }) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: allowedExtensions ?? ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
//         allowMultiple: false,
//         withData: true, // IMPORTANT: This ensures we get the bytes directly
//       );
      
//       if (result != null) {
//         PlatformFile file = result.files.first;
        
//         // Debug print to verify we have data
//         debugPrint('File picked: ${file.name}, size: ${file.size} bytes');
        
//         // FilePicker now gives us bytes directly with withData: true
//         if (file.bytes != null) {
//           String base64File = base64Encode(file.bytes!);
//           return {
//             'base64': base64File,
//             'fileName': file.name,
//             'fileSize': file.size.toString(),
//             'fileType': file.extension ?? 'unknown',
//           };
//         }
//       }
//       return null;
//     } catch (e) {
//       debugPrint('Error picking file: $e');
//       return null;
//     }
//   }

//   // ... rest of your existing methods remain the same


//     static IconData getFileIcon(String fileName) {
//     final extension = getFileExtension(fileName);
//     switch (extension) {
//       case 'pdf':
//         return Icons.picture_as_pdf;
//       case 'doc':
//       case 'docx':
//         return Icons.description;
//       case 'xls':
//       case 'xlsx':
//         return Icons.table_chart;
//       case 'jpg':
//       case 'jpeg':
//       case 'png':
//       case 'gif':
//         return Icons.image;
//       default:
//         return Icons.insert_drive_file;
//     }
//   }

//   // Also make getFileExtension static if it's not already
//   static String getFileExtension(String fileName) {
//     return fileName.split('.').last.toLowerCase();
//   }
// }


// lib/utils/file_picker_helper.dart
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FilePickerHelper {
  // Pick image from gallery or camera and convert to base64
  static Future<Map<String, String>?> pickImage({bool fromCamera = false}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );
      
      if (image != null) {
        File imageFile = File(image.path);
        List<int> imageBytes = await imageFile.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        
        // Debug print to verify we have data
        debugPrint('Image picked: ${image.name}, size: ${imageBytes.length} bytes');
        
        return {
          'base64': base64Image,
          'fileName': image.name,
          'fileType': 'image',
        };
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  // Pick any file and convert to base64
  static Future<Map<String, String>?> pickFile({
    List<String>? allowedExtensions,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions ?? ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
        withData: true, // IMPORTANT: This ensures we get the bytes directly
      );
      
      if (result != null) {
        PlatformFile file = result.files.first;
        
        // Debug print to verify we have data
        debugPrint('File picked: ${file.name}, size: ${file.size} bytes');
        
        // FilePicker now gives us bytes directly with withData: true
        if (file.bytes != null) {
          String base64File = base64Encode(file.bytes!);
          return {
            'base64': base64File,
            'fileName': file.name,
            'fileSize': file.size.toString(),
            'fileType': file.extension ?? 'unknown',
          };
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error picking file: $e');
      return null;
    }
  }

  // Convert base64 back to image widget
  static Widget base64ToImage(String base64String, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    try {
      if (base64String.isEmpty) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.person, color: Colors.grey),
        );
      }
      
      // Check if base64 already has data URI scheme
      String cleanBase64 = base64String;
      if (base64String.contains('base64,')) {
        cleanBase64 = base64String.split('base64,').last;
      }
      
      Uint8List bytes = base64Decode(cleanBase64);
      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          );
        },
      );
    } catch (e) {
      debugPrint('Error decoding base64 image: $e');
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Icon(Icons.error, color: Colors.red),
      );
    }
  }

  // Get file extension from filename
  static String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  // Check if file is an image based on extension
  static bool isImageFile(String fileName) {
    final extension = getFileExtension(fileName);
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(extension);
  }

  // Get appropriate icon for file type
  static IconData getFileIcon(String fileName) {
    final extension = getFileExtension(fileName);
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }
}