import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';

class SelectedSpotsProvider extends ChangeNotifier {
  TouristSpot? _firstSpot;
  TouristSpot? _secondSpot;

  TouristSpot? get firstSpot => _firstSpot;
  TouristSpot? get secondSpot => _secondSpot;

  void setNull() {
    _firstSpot = null;
    notifyListeners();
  }

  void setFirstSpot(TouristSpot spot) {
    _firstSpot = spot;
    notifyListeners();
  }

  void setSecondSpot(TouristSpot spot) {
    _secondSpot = spot;
    notifyListeners();
  }
}

final selectedSpotsProvider = ChangeNotifierProvider<SelectedSpotsProvider>(
    (ref) => SelectedSpotsProvider());
