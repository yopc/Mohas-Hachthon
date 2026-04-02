import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/upload_service.dart'; // Contains CloudinaryService
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
  State<EvidencePicker> createState() => _EvidencePickerState();
}

class _EvidencePickerState extends State<EvidencePicker> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = [];
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null && mounted) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  Future<void> _uploadImages() async {
    if (_selectedImages.isEmpty) return;
    setState(() => _isUploading = true);
    final List<Evidence> uploadedEvidences = [];

    for (var image in _selectedImages) {
      // Use CloudinaryService static method (only one parameter)
      final url = await CloudinaryService.uploadImage(image);
      if (url != null) {
        final evidence = Evidence(
          id: '',
          enterpriseId: widget.enterpriseId,
          recordType: widget.recordType,
          recordId: widget.recordId,
          type: 'photo',
          url: url,
          uploadedBy: FirebaseAuth.instance.currentUser!.uid,
          timestamp: DateTime.now(),
          tags: [],
        );
        uploadedEvidences.add(evidence);
      }
    }

    if (mounted) {
      setState(() => _isUploading = false);
      widget.onUploaded(uploadedEvidences);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Evidence'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedImages.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: Image.file(_selectedImages[index], fit: BoxFit.cover, width: 80),
                  );
                },
              ),
            ),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Take Photo'),
          ),
          if (_selectedImages.isNotEmpty)
            ElevatedButton(
              onPressed: _uploadImages,
              child: _isUploading ? const CircularProgressIndicator() : const Text('Upload'),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (mounted) Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}