import 'dart:io';

import 'package:expeditions/Models/Place.dart';
import 'package:expeditions/Providers/Places.dart';
import 'package:expeditions/UI/Screens/PlacesOverviewScreen.dart';
import 'package:expeditions/UI/Widgets/ImageInput.dart';
import 'package:expeditions/UI/Widgets/LocationInput.dart';
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
  Location _pickedLocation=Location(latitude: -1,longitude: -1,address: '');

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlace(double latitude,double longitude) {
    _pickedLocation = Location(latitude: latitude,longitude: longitude,address: '');
  }

  void _addPlace() {
    if (_titleController.text.isEmpty || _pickedImage.path.isEmpty || _pickedLocation.latitude<0 || _pickedLocation.longitude<0) return;
    Provider.of<Places>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage,_pickedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        title: Text(
          'Add Expedition',
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
                    SizedBox(height: 8,),
                    LocationInput(selectPlace: _selectPlace)
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
