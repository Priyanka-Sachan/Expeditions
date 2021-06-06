import 'package:expeditions/Helpers/LocationHelper.dart';
import 'package:expeditions/UI/Screens/MapScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function selectPlace;

  LocationInput({required this.selectPlace});

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl = '';

  void _showPreviewImage(double? latitude, double? longitude) {
    try {
      final locationPreviewUrl = LocationHelper.generateLocationPreview(
          latitude: latitude, longitude: longitude);
      setState(() {
        _previewImageUrl = locationPreviewUrl;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final currentLocation = await Location().getLocation();
      if (currentLocation.latitude == null || currentLocation.longitude == null)
        throw Exception('Location not found.');
      _showPreviewImage(currentLocation.latitude, currentLocation.longitude);
      widget.selectPlace(currentLocation.latitude, currentLocation.longitude);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (ctx) => MapScreen(
        isSelecting: true,
      ),
    ));
    if (selectedLocation == null) return;
    _showPreviewImage(selectedLocation.latitude, selectedLocation.longitude);
    widget.selectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
                onPressed: _getCurrentLocation,
                child: Row(
                  children: [
                    Icon(Icons.add_location_alt_rounded),
                    Text('Add Location'),
                  ],
                )),
            OutlinedButton(
                onPressed: _selectOnMap,
                child: Row(
                  children: [
                    Icon(Icons.map_rounded),
                    Text('Show in Maps'),
                  ],
                ),
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _previewImageUrl.isEmpty
              ? Container(
                  width: double.infinity,
                  height: 256,
                  color: Theme.of(context).primaryColor,
                  alignment: Alignment.center,
                  child: Text(
                    'NO LOCATION CHOSEN',
                    style: TextStyle(color: Colors.white),
                  ),
          )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                ),
        ),
      ],
    );
  }
}
