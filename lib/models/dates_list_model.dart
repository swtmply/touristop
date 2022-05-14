class DatesList {
  List<DateTime> _datesList = [];

  List<DateTime> get dates => _datesList;

  void addAll(List<DateTime> dates) {
    _datesList = dates;
  }

  void remove(DateTime date) {
    _datesList.remove(date);
  }
}
