import 'package:flutter/material.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';

class SelectedSpotProvider extends ChangeNotifier {
  TouristSpot? _spot;

  TouristSpot? get spot => _spot;

  void setSelectedSpot(TouristSpot spot) {
    _spot = spot;
    notifyListeners();
  }
}
