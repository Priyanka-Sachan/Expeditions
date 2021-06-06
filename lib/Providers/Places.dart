import 'dart:io';

import 'package:expeditions/Helpers/DBHelpers.dart';
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
            location: Location(longitude: 0, latitude: 0, address: '')))
        .toList();
    notifyListeners();
  }

  void addPlace(String title, File image) {
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: title,
        location: Location(latitude: 0, longitude: 0, address: ''),
        image: image);
    _items.add(newPlace);
    notifyListeners();
    DBHelpers.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path
    });
  }
}
