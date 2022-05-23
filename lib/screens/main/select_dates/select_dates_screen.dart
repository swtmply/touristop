import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:touristop/main.dart';
import 'package:touristop/models/date/date_model.dart';
import 'package:touristop/screens/main/select_dates/widgets/date_picker_calendar.dart';
import 'package:touristop/screens/main/select_dates/widgets/selected_dates.dart';

class SelectDatesScreen extends ConsumerStatefulWidget {
  const SelectDatesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectDatesScreenState();
}

class _SelectDatesScreenState extends ConsumerState<SelectDatesScreen> {
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  Widget build(BuildContext context) {
    final dates = ref.watch(datesProvider);
    final datesBox = Hive.box<Date>('dates');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select dates you want to travel',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Date Picker
                DatePickerCalendar(controller: _controller),
                const SizedBox(height: 20),
                const Text(
                  'Selected Dates:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // Selected Dates
                SelectedDates(controller: _controller),
                const SizedBox(height: 30),
                // Submit button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: dates.selectedDates.isEmpty
                          ? Colors.grey[300]
                          : Colors.pink,
                      primary: dates.selectedDates.isEmpty
                          ? Colors.grey[400]
                          : Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 32.0,
                      ),
                    ),
                    onPressed: dates.selectedDates.isEmpty
                        ? () {
                            datesBox.deleteFromDisk();
                          }
                        : () {
                            Navigator.pushNamed(context, '/select/spots');
                          },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
