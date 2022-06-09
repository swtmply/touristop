import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlanProvider extends ChangeNotifier {
  String _plan = "";

  String get plan => _plan;

  void setPlan(String plan) {
    _plan = plan;
    notifyListeners();
  }
}

final planProvider =
    ChangeNotifierProvider<PlanProvider>((ref) => PlanProvider());
