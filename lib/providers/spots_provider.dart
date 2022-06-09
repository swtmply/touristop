import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';

class SpotsProvider extends ChangeNotifier {
  List<TouristSpot> _spots = [];

  List<TouristSpot> get spots => _spots;

  void addAll(List<TouristSpot> spots) {
    _spots = spots;
    notifyListeners();
  }
}

final spotsProvider =
    ChangeNotifierProvider<SpotsProvider>((ref) => SpotsProvider());
