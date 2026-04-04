import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/upload_service.dart';
import '../models/evidence.dart';

class EvidencePicker extends StatefulWidget {
  final String enterpriseId;
  final String recordType;
  final String recordId;
  final Function(List<Evidence>) onUploaded;

  const EvidencePicker({
    super.key,
    required this.enterpriseId,
    required this.recordType,
    required this.recordId,
    required this.onUploaded,
  });

  @override
  State<EvidencePicker> createState() {
    print('🟢 EvidencePicker createState() called');
    return _EvidencePickerState();
  }
}

class _EvidencePickerState extends State<EvidencePicker> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = []; // Use XFile for cross-platform
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    print('🟢 EvidencePicker initState');
  }

  Future<void> _pickImage() async {
    print('📸 _pickImage() called');
    if (_isUploading) {
      print('⚠️ Upload in progress, ignoring pick');
      return;
    }
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        print('✅ Image picked: ${image.path}');
        if (mounted) {
          setState(() {
            _selectedImages.add(image);
          });
          print('✅ Image added to selected list (mounted)');
        } else {
          print('⚠️ Widget unmounted, cannot add image');
        }
      } else {
        print('ℹ️ No image selected');
      }
    } catch (e) {
      print('❌ Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to capture image: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // Future<void> _uploadImages() async {
  //   print('🚀 _uploadImages() called. Selected images count: ${_selectedImages.length}');
  //   if (_selectedImages.isEmpty) {
  //     print('⚠️ No images to upload');
  //     return;
  //   }
  //   if (_isUploading) {
  //     print('⚠️ Already uploading, ignoring duplicate call');
  //     return;
  //   }

  //   setState(() => _isUploading = true);
  //   final List<Evidence> uploadedEvidences = [];
  //   final List<String> failedUploads = [];

  //   for (int i = 0; i < _selectedImages.length; i++) {
  //     final XFile xfile = _selectedImages[i];
  //     print('📤 Uploading image ${i + 1}/${_selectedImages.length}');
  //     try {
  //       // Convert XFile to File (works on mobile) or read bytes on web
  //       final File file = File(xfile.path);
  //       final url = await CloudinaryService.uploadImage(file);
  //       if (url != null && url.isNotEmpty) {
  //         print('✅ Uploaded URL: $url');
  //         final evidence = Evidence(
  //           id: '',
  //           enterpriseId: widget.enterpriseId,
  //           recordType: widget.recordType,
  //           recordId: widget.recordId,
  //           type: 'photo',
  //           url: url,
  //           uploadedBy: FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
  //           timestamp: DateTime.now(),
  //           tags: [],
  //         );
  //         uploadedEvidences.add(evidence);
  //       } else {
  //         print('❌ Upload returned null URL');
  //         failedUploads.add(xfile.path.split('/').last);
  //       }
  //     } catch (e) {
  //       print('❌ Upload exception: $e');
  //       failedUploads.add(xfile.path.split('/').last);
  //     }
  //   }

  //   if (!mounted) {
  //     print('⚠️ Widget unmounted during upload, aborting UI updates');
  //     return;
  //   }

  //   setState(() => _isUploading = false);

  //   if (failedUploads.isNotEmpty) {
  //     final message = '${failedUploads.length} image(s) failed to upload. Check Cloudinary settings.';
  //     print('⚠️ $message');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(message), backgroundColor: Colors.orange, duration: const Duration(seconds: 4)),
  //     );
  //   } else if (uploadedEvidences.isEmpty) {
  //     print('❌ No evidence uploaded at all');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('No images could be uploaded. Please check your internet and Cloudinary configuration.')),
  //     );
  //   }

  //   if (uploadedEvidences.isNotEmpty) {
  //     print('✅ Calling onUploaded with ${uploadedEvidences.length} evidences');
  //     widget.onUploaded(uploadedEvidences);
  //   }

  //   print('🔚 Closing dialog');
  //   Navigator.pop(context);
  // }


Future<void> _uploadImages() async {
  print('🚀 _uploadImages() called. Selected images count: ${_selectedImages.length}');
  if (_selectedImages.isEmpty || _isUploading) return;

  setState(() => _isUploading = true);
  final List<Evidence> uploadedEvidences = [];
  final List<String> failedUploads = [];

  for (int i = 0; i < _selectedImages.length; i++) {
    final XFile xfile = _selectedImages[i];
    print('📤 Uploading image ${i + 1}/${_selectedImages.length}');
    try {
      String? url;
      if (kIsWeb) {
        // Read bytes from XFile (web)
        final bytes = await xfile.readAsBytes();
        final fileName = xfile.name.isNotEmpty ? xfile.name : 'image_$i.jpg';
        url = await CloudinaryService.uploadImage(File(''), bytes: bytes, fileName: fileName);
      } else {
        // Mobile: use File directly
        final file = File(xfile.path);
        url = await CloudinaryService.uploadImage(file);
      }

      if (url != null && url.isNotEmpty) {
        print('✅ Uploaded URL: $url');
        final evidence = Evidence(
          id: '',
          enterpriseId: widget.enterpriseId,
          recordType: widget.recordType,
          recordId: widget.recordId,
          type: 'photo',
          url: url,
          uploadedBy: FirebaseAuth.instance.currentUser?.uid ?? 'unknown',
          timestamp: DateTime.now(),
          tags: [],
        );
        uploadedEvidences.add(evidence);
      } else {
        print('❌ Upload returned null URL');
        failedUploads.add(xfile.path);
      }
    } catch (e) {
      print('❌ Upload exception: $e');
      failedUploads.add(xfile.path);
    }
      if (!mounted) {
      print('⚠️ Widget unmounted during upload, aborting UI updates');
      return;
    }

    setState(() => _isUploading = false);

    if (failedUploads.isNotEmpty) {
      final message = '${failedUploads.length} image(s) failed to upload. Check Cloudinary settings.';
      print('⚠️ $message');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.orange, duration: const Duration(seconds: 4)),
      );
    } else if (uploadedEvidences.isEmpty) {
      print('❌ No evidence uploaded at all');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No images could be uploaded. Please check your internet and Cloudinary configuration.')),
      );
    }

    if (uploadedEvidences.isNotEmpty) {
      print('✅ Calling onUploaded with ${uploadedEvidences.length} evidences');
      widget.onUploaded(uploadedEvidences);
    }

    print('🔚 Closing dialog');
    Navigator.pop(context);
  
  }

  // ... rest of the method (snackbars, closing dialog) unchanged
}
  @override
  Widget build(BuildContext context) {
    print('🏗️ Building EvidencePicker, isUploading=$_isUploading, images=${_selectedImages.length}');
    final bool canUpload = !_isUploading && _selectedImages.isNotEmpty;
    print('🔘 Upload button enabled: $canUpload');

    return AlertDialog(
      title: const Text('Add Evidence'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedImages.isNotEmpty) ...[
              const Text('Selected Images:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedImages.map((xfile) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: kIsWeb
                          ? Image.network(xfile.path, fit: BoxFit.cover)  // ✅ Web fix
                          : Image.file(File(xfile.path), fit: BoxFit.cover),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
            ElevatedButton.icon(
              onPressed: _isUploading ? null : _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
            ),
            const SizedBox(height: 8),
            if (_selectedImages.isNotEmpty)
              ElevatedButton(
                onPressed: canUpload
                    ? () {
                        print('🖱️ Upload button CLICKED!');
                        _uploadImages();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.blue,
                ),
                child: _isUploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Upload'),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isUploading
              ? null
              : () {
                  print('❌ Cancel clicked, closing dialog');
                  Navigator.pop(context);
                },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}