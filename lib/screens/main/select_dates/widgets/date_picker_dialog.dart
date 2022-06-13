import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:touristop/theme/app_colors.dart';

class AppDatePickerDialog extends ConsumerStatefulWidget {
  final Function onChange;
  final DateTime date;
  final DateTime? maxDate;
  const AppDatePickerDialog({
    Key? key,
    required this.date,
    required this.onChange,
    this.maxDate,
  }) : super(key: key);

  @override
  ConsumerState<AppDatePickerDialog> createState() =>
      _AppDatePickerDialogState();
}

class _AppDatePickerDialogState extends ConsumerState<AppDatePickerDialog> {
  String selected = '';

  @override
  Widget build(BuildContext context) {
    Function onChange = widget.onChange;
    DateTime date = widget.date;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 15,
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose a date',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 30),
                ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: 0.9,
                    child: Container(
                      color: const Color.fromARGB(255, 250, 250, 250),
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: SfDateRangePicker(
                        minDate: date,
                        maxDate: widget.maxDate,
                        selectionMode: DateRangePickerSelectionMode.single,
                        enablePastDates: false,
                        initialSelectedDate: date,
                        showNavigationArrow: true,
                        selectionShape: DateRangePickerSelectionShape.circle,
                        onSelectionChanged:
                            (DateRangePickerSelectionChangedArgs args) {
                          date = args.value;
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
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 180,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromRGBO(93, 107, 230, 1),
                          Color.fromRGBO(93, 230, 197, 1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: () {
                        onChange(date);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Submit',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
