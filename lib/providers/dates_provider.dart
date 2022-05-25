import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:touristop/models/date/date_model.dart';

class DatesProvider extends ChangeNotifier {
  List<DateTime> _datesList = [];
  DateTime? _selectedDate;

  List<DateTime> get selectedDates => _datesList;
  DateTime? get selectedDate => _selectedDate;

  String toDateKey(DateTime date) {
    return DateFormat('yMd').format(date).toString();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void addAll(List<DateTime> dates) async {
    final datesBox = Hive.box<Date>('dates');

    await datesBox.clear();

    for (final date in dates) {
      datesBox.put(toDateKey(date), Date()..date = date);
    }

    _datesList = dates;
    notifyListeners();
  }

  void removeDate(DateTime date) {
    final datesBox = Hive.box<Date>('dates');

    datesBox.delete(toDateKey(date));

    _datesList.remove(date);
    notifyListeners();
  }
}
