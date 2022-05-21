import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:touristop/main.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/screens/main/calendar/widgets/datepicker_calendar.dart';
import 'package:touristop/screens/main/calendar/widgets/selected_dates.dart';
import 'package:touristop/widgets/header.dart';

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header('Choose dates'),
              const SizedBox(height: 20),
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
              SelectedDates(controller: _controller),
              const SizedBox(height: 10),
              _SubmitButton(data: data)
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key? key,
    required this.data,
  }) : super(key: key);

  final DatesProvider data;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: data.dates.isEmpty ? Colors.grey[300] : Colors.pink,
          primary: data.dates.isEmpty ? Colors.grey[400] : Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32.0,
          ),
        ),
        onPressed: data.dates.isEmpty
            ? () {}
            : () {
                Navigator.pushNamed(context, '/select-spots');
              },
        child: const Text('Submit'),
      ),
    );
  }
}
