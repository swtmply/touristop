import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedBundleProvider extends ChangeNotifier {
  final List<String> _selectedBundles = [];

  List<String> get selectedSpots => _selectedBundles;

  void addSpots(List<String> names) {
    _selectedBundles.addAll(names);
    notifyListeners();
  }

  void addSpot(String name) {
    _selectedBundles.add(name);
    notifyListeners();
  }
}

final selectedBundleProvider = ChangeNotifierProvider<SelectedBundleProvider>(
    (ref) => SelectedBundleProvider());
