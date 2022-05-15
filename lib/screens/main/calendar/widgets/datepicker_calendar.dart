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

    return ClipRect(
      child: Align(
        alignment: Alignment.topCenter,
        heightFactor: 0.88,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: SfDateRangePicker(
            controller: controller,
            selectionMode: DateRangePickerSelectionMode.multiple,
            enablePastDates: false,
            showNavigationArrow: true,
            selectionShape: DateRangePickerSelectionShape.circle,
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              if (args.value is List<DateTime>) {
                data.addAll(args.value);
              }
            },
            headerStyle: const DateRangePickerHeaderStyle(
              textAlign: TextAlign.center,
              textStyle: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            headerHeight: 60,
          ),
        ),
      ),
    );
  }
}
