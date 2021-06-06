import 'package:expeditions/Providers/Places.dart';
import 'package:expeditions/UI/Screens/MapScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceDetailsScreen extends StatelessWidget {
  static final id = 'place-details-screen';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final place = Provider.of<Places>(context, listen: false).findById(id);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        title: Text(
          place.title,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 256,
              child: Image.file(
                place.image,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('AT ${place.location.address}'),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (ctx) =>
                        MapScreen(initialLocation: place.location)));
              },
              child: Text('VIEW ON MAP'))
        ],
      ),
    );
  }
}
