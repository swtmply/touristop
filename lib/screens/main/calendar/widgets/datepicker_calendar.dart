import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:touristop/main.dart';

class DatePickerCalendar extends ConsumerWidget {
  const DatePickerCalendar({Key? key, required this.controller})
      : super(key: key);

  final DateRangePickerController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(datesProvider);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      child: SfDateRangePicker(
        controller: controller,
        selectionMode: DateRangePickerSelectionMode.multiple,
        enablePastDates: false,
        showNavigationArrow: true,
        selectionShape: DateRangePickerSelectionShape.rectangle,
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          if (args.value is List<DateTime>) {
            data.addAll(args.value);
          }
        },
        headerStyle: const DateRangePickerHeaderStyle(
          textAlign: TextAlign.center,
          textStyle: TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        headerHeight: 60,
      ),
    );
  }
}
