import 'dart:io';

import 'package:expeditions/Helpers/DBHelpers.dart';
import 'package:expeditions/Helpers/LocationHelper.dart';
import 'package:expeditions/Models/Place.dart';
import 'package:flutter/foundation.dart';

class Places with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> fetchAndSetPlaces() async {
    final data = await DBHelpers.getData('places');
    _items = data
        .map((item) => Place(
            id: item['id'],
            title: item['title'],
            image: File(item['image']),
            location: Location(
                longitude: item['loc_lon'],
                latitude: item['loc_lat'],
                address: item['address'])))
        .toList();
    notifyListeners();
  }

  Future<void> addPlace(String title, File image, Location location) async {
    String address =
        await LocationHelper.getAddress(location.latitude, location.longitude);
    Location newLocation = Location(
        latitude: location.latitude,
        longitude: location.longitude,
        address: address);
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: title,
        location: newLocation,
        image: image);
    _items.add(newPlace);
    print(newPlace.toString());
    notifyListeners();
    DBHelpers.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'loc_lat': newPlace.location.latitude,
      'loc_lon': newPlace.location.longitude,
      'address': newPlace.location.address
    });
  }
}
