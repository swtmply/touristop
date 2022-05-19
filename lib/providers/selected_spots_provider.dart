import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:touristop/boxes/spots_box.dart';
import 'package:touristop/models/tourist_spot_model.dart';

class SelectedSpotsProvider extends ChangeNotifier {
  TouristSpot? _spot;

  TouristSpot? get spot => _spot;

  void setSelectedSpot(TouristSpot selectedSpot) {
    _spot = selectedSpot;
    notifyListeners();
  }

  Future<void> addSpot(SpotBox spot) async {
    final box = await Hive.openBox<SpotBox>('spots');

    box.add(spot);
    notifyListeners();
  }

  updateItem(int index, SpotBox spot) async {
    final box = await Hive.openBox<SpotBox>('spots');

    box.putAt(index, spot);
    notifyListeners();
  }

  deleteItem(int index) async {
    final box = await Hive.openBox<SpotBox>('spots');

    box.deleteAt(index);
    notifyListeners();
  }
}
