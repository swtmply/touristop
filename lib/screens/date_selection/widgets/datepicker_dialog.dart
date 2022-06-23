import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/theme/app_spacing.dart';

class TSDatePickerDialog extends StatefulWidget {
  final DateTime minDate;
  final DateTime? maxDate;
  final Function onChange;
  const TSDatePickerDialog({
    Key? key,
    required this.minDate,
    this.maxDate,
    required this.onChange,
  }) : super(key: key);

  @override
  State<TSDatePickerDialog> createState() => _TSDatePickerDialogState();
}

class _TSDatePickerDialogState extends State<TSDatePickerDialog> {
  @override
  Widget build(BuildContext context) {
    DateTime minDate = widget.minDate;
    final maxDate = widget.maxDate;
    final onChange = widget.onChange;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.small),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: 0.9,
                child: Container(
                  color: const Color.fromARGB(255, 250, 250, 250),
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: SfDateRangePicker(
                    minDate: minDate,
                    maxDate: maxDate,
                    selectionMode: DateRangePickerSelectionMode.single,
                    enablePastDates: false,
                    initialSelectedDate: minDate,
                    showNavigationArrow: true,
                    selectionShape: DateRangePickerSelectionShape.circle,
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      minDate = args.value;
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
                    onChange(minDate);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(
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
    );
  }
}
