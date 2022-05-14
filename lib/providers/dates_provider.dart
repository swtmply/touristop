import 'package:flutter/material.dart';

class DatesProvider extends ChangeNotifier {
  List<DateTime> _datesList = [];

  List<DateTime> get dates => _datesList;

  void addAll(List<DateTime> dates) {
    _datesList = dates;
    notifyListeners();
  }

  void remove(DateTime date) {
    _datesList.remove(date);
    notifyListeners();
  }
}
