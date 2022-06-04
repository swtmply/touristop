import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:touristop/models/dates_list/dates_list_model.dart';
import 'package:touristop/models/selected_spots/selected_spots_model.dart';
import 'package:touristop/models/spots_list/spots_list_model.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/screens/main/select_dates/widgets/date_picker_calendar.dart';
import 'package:touristop/screens/main/select_dates/widgets/selected_dates.dart';
import 'package:touristop/screens/main/select_dates/widgets/selection_dialog.dart';

class SelectDatesScreen extends ConsumerStatefulWidget {
  const SelectDatesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectDatesScreenState();
}

class _SelectDatesScreenState extends ConsumerState<SelectDatesScreen> {
  final DateRangePickerController _controller = DateRangePickerController();
  String selectedOption = '';

  @override
  Widget build(BuildContext context) {
    final dates = ref.watch(datesProvider);
    final spotsBox = Hive.box<SpotsList>('spots');
    final datesBox = Hive.box<DatesList>('dates');
    final clusterSpots = Hive.box<SelectedSpots>('selectedSpots');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select dates you want to travel',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Date Picker
                DatePickerCalendar(controller: _controller),
                const SizedBox(height: 20),
                Text(
                  'Selected Dates:',
                  style: GoogleFonts.inter(
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
                        backgroundColor: dates.datesList.isEmpty
                            ? const Color.fromARGB(255, 250, 250, 250)
                            : Colors.transparent,
                        primary: dates.datesList.isEmpty
                            ? Colors.grey[400]
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: dates.datesList.isEmpty
                          ? () {
                              spotsBox.deleteFromDisk();
                              datesBox.deleteFromDisk();
                              clusterSpots.deleteFromDisk();
                            }
                          : () {
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: MaterialLocalizations.of(context)
                                    .modalBarrierDismissLabel,
                                pageBuilder: (BuildContext buildContext,
                                        Animation animation,
                                        Animation secondaryAnimation) =>
                                    const SelectionDialog(),
                              );
                            },
                      child: Text(
                        'Submit',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                        ),
                      ),
                    ),
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
