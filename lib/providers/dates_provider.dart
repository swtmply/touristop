import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:touristop/models/dates_list/dates_list_model.dart';
import 'package:touristop/theme/app_colors.dart';

class DatesProvider extends ChangeNotifier {
  final List<DatesList> _datesList = [];
  DatesList? _selectedDate;

  List<DatesList> get datesList => _datesList;
  DatesList? get selectedDate => _selectedDate;

  String toDateKey(DateTime date) {
    return DateFormat('yMd').format(date).toString();
  }

  void sortDates() {
    _datesList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    notifyListeners();
  }

  void setSelectedDate(DatesList date) {
    _selectedDate = date;
    notifyListeners();
  }

  DatesList? findByDate(DateTime date) {
    final datesBox = Hive.box<DatesList>('dates');

    return datesBox.get(toDateKey(date));
  }

  void updateDateList(DateTime date, double hours) {
    final datesBox = Hive.box<DatesList>('dates');
    final datesList = datesBox.get(toDateKey(date));

    datesList!.timeRemaining += hours;

    datesList.save();

    notifyListeners();
  }

  void addAll(List<DateTime> dates) async {
    final datesBox = Hive.box<DatesList>('dates');

    await datesBox.clear();
    _datesList.clear();

    for (final date in dates) {
      final datesList = DatesList(dateTime: date, timeRemaining: 10);
      final key = toDateKey(date);
      datesBox.put(key, datesList);

      _datesList.add(datesList);
    }

    notifyListeners();
  }

  void removeDate(DatesList date) {
    final datesBox = Hive.box<DatesList>('dates');
    final key = toDateKey(date.dateTime);

    datesBox.delete(key);

    _datesList.remove(date);
    notifyListeners();
  }
}

final datesProvider =
    ChangeNotifierProvider<DatesProvider>((ref) => DatesProvider());
