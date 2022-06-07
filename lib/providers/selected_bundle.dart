import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedBundleProvider extends ChangeNotifier {
  final List<String> _selectedSpots = [];

  List<String> get selectedSpots => _selectedSpots;

  void addSpots(List<String> names) {
    _selectedSpots.addAll(names);
    notifyListeners();
  }

  void addSpot(String name) {
    _selectedSpots.add(name);
    notifyListeners();
  }
}

final selectedBundleProvider = ChangeNotifierProvider<SelectedBundleProvider>(
    (ref) => SelectedBundleProvider());
