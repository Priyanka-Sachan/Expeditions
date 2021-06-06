import 'dart:io';

import 'package:expeditions/Providers/Places.dart';
import 'package:expeditions/UI/Screens/PlacesOverview.dart';
import 'package:expeditions/UI/Widgets/ImageInput.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static final id = 'add-place-screen';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final TextEditingController _titleController = TextEditingController();
  File _pickedImage = File('');

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _addPlace() {
    if (_titleController.text.isEmpty || _pickedImage.path.isEmpty) return;
    Provider.of<Places>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        title: Text(
          'Expeditions',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      controller: _titleController,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ImageInput(_selectImage),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _addPlace();
                Navigator.of(context).pushNamed(PlacesOverviewScreen.id);
              },
              child: Text('ADD PLACE'),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).accentColor),
            )
          ],
        ),
      ),
    );
  }
}
