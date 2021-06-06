import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pathProvider;

class ImageInput extends StatefulWidget {
  late final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage = File('');

  Future<void> _takeImage() async {
    final picker = ImagePicker();
    final imageFile =
        await picker.getImage(source: ImageSource.camera, maxWidth: 600);
    if(imageFile==null)
      return;
    setState(() {
      _storedImage = File(imageFile.path);
    });
    final appDir = await pathProvider.getApplicationDocumentsDirectory();
    final fileName = path.basename(_storedImage.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 128,
            height: 128,
            color: Theme.of(context).primaryColor,
            alignment: Alignment.center,
            child: _storedImage.path.isNotEmpty
                ? Image.file(
                    _storedImage,
                    fit: BoxFit.fill,
                  )
                : Text(
                    'No Image Taken',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
        IconButton(onPressed: _takeImage, icon: Icon(Icons.add_a_photo))
      ],
    );
  }
}
