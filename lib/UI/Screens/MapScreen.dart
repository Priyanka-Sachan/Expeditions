import 'package:expeditions/Models/Place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final Location initialLocation;
  final bool isSelecting;

  MapScreen(
      {this.initialLocation =
          const Location(latitude: 0, longitude: 0, address: ''),
      this.isSelecting = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation = LatLng(-1, -1);

  void _selectLocation(LatLng location) {
    setState(() {
      _pickedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
        title: Text(
          'Add location',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: widget.isSelecting && _pickedLocation.longitude >= 0
            ? [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
                    icon: Icon(Icons.check))
              ]
            : null,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.initialLocation.latitude,
              widget.initialLocation.longitude),
          zoom: 16,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: (_pickedLocation.longitude >= 0 || !widget.isSelecting)
            ? {Marker(markerId: MarkerId('m1'), position: _pickedLocation)}
            : const <Marker>{},
      ),
    );
  }
}
