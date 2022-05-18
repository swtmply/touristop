import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:touristop/boxes/spots_box.dart';
import 'package:touristop/models/tourist_spot_model.dart';

class SelectedSpotsProvider extends ChangeNotifier {
  TouristSpot? _spot;
  List<SpotBox>? _spots;

  TouristSpot? get spot => _spot;
  List<SpotBox>? get spots => _spots;

  final box = Hive.box<SpotBox>('spots');

  void setSelectedSpot(TouristSpot selectedSpot) {
    _spot = selectedSpot;
    notifyListeners();
  }

  Future<void> addSpot(SpotBox spot) async {
    box.add(spot);
    notifyListeners();
  }

  updateItem(int index, SpotBox spot) {
    box.putAt(index, spot);
    notifyListeners();
  }

  deleteItem(int index) {
    box.deleteAt(index);
    notifyListeners();
  }
}
