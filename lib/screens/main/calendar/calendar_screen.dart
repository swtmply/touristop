import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:touristop/main.dart';
import 'package:touristop/screens/main/calendar/widgets/datepicker_calendar.dart';
import 'package:touristop/screens/main/calendar/widgets/selected_dates.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends ConsumerState<CalendarScreen> {
  final DateRangePickerController _controller = DateRangePickerController();

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(datesProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            DatePickerCalendar(controller: _controller),
            const SelectedDates(),
            TextButton(
              onPressed: data.dates.isEmpty
                  ? () {}
                  : () {
                      Navigator.pushNamed(context, '/select-spots');
                    },
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
