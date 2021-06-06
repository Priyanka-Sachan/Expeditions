import 'dart:io';

import 'package:expeditions/Models/Place.dart';
import 'package:flutter/foundation.dart';

class Places with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String title, File image) {
    final newPlace = Place(
        id: DateTime.now().toString(),
        title: title,
        location: Location(latitude: 0, longitude: 0, address: ''),
        image: image);
    _items.add(newPlace);
    notifyListeners();
  }
}
