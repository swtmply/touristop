import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/theme/app_colors.dart';

class DatePickerCalendar extends ConsumerWidget {
  const DatePickerCalendar({Key? key, required this.controller})
      : super(key: key);

  final DateRangePickerController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDates = ref.watch(datesProvider);

    return ClipRect(
      child: Align(
        alignment: Alignment.topCenter,
        heightFactor: 0.9,
        child: Container(
          color: const Color.fromARGB(255, 250, 250, 250),
          height: MediaQuery.of(context).size.height * 0.45,
          child: SfDateRangePicker(
            controller: controller,
            selectionMode: DateRangePickerSelectionMode.multiple,
            enablePastDates: false,
            showNavigationArrow: true,
            selectionShape: DateRangePickerSelectionShape.circle,
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              if (args.value is List<DateTime>) {
                selectedDates.addAll(args.value);
              }
            },
            headerStyle: DateRangePickerHeaderStyle(
              backgroundColor: AppColors.slime,
              textAlign: TextAlign.center,
              textStyle: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontFamily: GoogleFonts.neucha().fontFamily,
              ),
            ),
            monthCellStyle: DateRangePickerMonthCellStyle(
              disabledDatesTextStyle: TextStyle(
                fontSize: 14,
                color: const Color.fromARGB(133, 121, 121, 121),
                fontFamily: GoogleFonts.neucha().fontFamily,
              ),
              textStyle: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontFamily: GoogleFonts.neucha().fontFamily,
              ),
            ),
            headerHeight: 60,
            todayHighlightColor: AppColors.coldBlue,
            selectionColor: AppColors.slime,
            // startRangeSelectionColor: Color.fromRGBO(93, 230, 197, 1),
            // endRangeSelectionColor:  Color.fromRGBO(93, 230, 197, 1),
            // rangeSelectionColor: Color.fromARGB(161, 93, 230, 198),
          ),
        ),
      ),
    );
  }
}
