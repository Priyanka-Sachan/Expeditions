import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthImagePicker extends StatefulWidget {
  final void Function(File image) pickImage;

  AuthImagePicker({required this.pickImage});

  @override
  _AuthImagePickerState createState() => _AuthImagePickerState();
}

class _AuthImagePickerState extends State<AuthImagePicker> {
  File profileImage = File('');

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(source: ImageSource.gallery);
    if (imageFile == null) return;
    setState(() {
      profileImage = File(imageFile.path);
    });
    widget.pickImage(profileImage);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          backgroundImage:
              profileImage.path.isNotEmpty ? FileImage(profileImage) : null,
          radius: 64,
        ),
        CircleAvatar(
            backgroundColor: Theme.of(context).backgroundColor,
            child: IconButton(
                onPressed: pickImage, icon: Icon(Icons.camera_alt_rounded)))
      ],
    );
  }
}
