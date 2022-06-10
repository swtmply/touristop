import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:touristop/models/dates_list/dates_list_model.dart';
import 'package:touristop/models/selected_spots/selected_spots_model.dart';
import 'package:touristop/models/spots_list/spots_list_model.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/screens/main/select_dates/widgets/date_picker_dialog.dart';
import 'package:touristop/screens/main/select_dates/widgets/selection_dialog.dart';

class SelectDatesScreen extends ConsumerStatefulWidget {
  const SelectDatesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectDatesScreenState();
}

class _SelectDatesScreenState extends ConsumerState<SelectDatesScreen> {
  // final DateRangePickerController _controller = DateRangePickerController();
  String selectedOption = '';
  DateTime? first, second;
  bool isArrivalIncluded = false;

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
                  'Dates of travel',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Date Picker
                const SizedBox(height: 20),
                // Selected Dates
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: MaterialLocalizations.of(context)
                              .modalBarrierDismissLabel,
                          pageBuilder: (BuildContext buildContext,
                                  Animation animation,
                                  Animation secondaryAnimation) =>
                              AppDatePickerDialog(
                            date: DateTime.now(),
                            onChange: (value) {
                              setState(() {
                                first = value;
                                second = first!.add(const Duration(days: 1));

                                dates.datesList.clear();
                                dates.datesList.addAll([
                                  DatesList(dateTime: first!, timeRemaining: 8),
                                  DatesList(dateTime: second!, timeRemaining: 8)
                                ]);
                              });
                            },
                          ),
                        );
                      },
                      child: SelectDateButton(
                          date: first,
                          title: 'Start date',
                          description: 'Click here to select a date '),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: first != null
                          ? () {
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: MaterialLocalizations.of(context)
                                    .modalBarrierDismissLabel,
                                pageBuilder: (BuildContext buildContext,
                                        Animation animation,
                                        Animation secondaryAnimation) =>
                                    AppDatePickerDialog(
                                  date: first?.add(const Duration(days: 1)) ??
                                      DateTime.now()
                                          .add(const Duration(days: 1)),
                                  maxDate: first?.add(const Duration(days: 7)),
                                  onChange: (value) {
                                    setState(() {
                                      second = value;

                                      final daysBetween =
                                          second!.difference(first!).inDays;
                                      dates.datesList.clear();

                                      for (var i = 0;
                                          i < daysBetween + 1;
                                          i++) {
                                        final date =
                                            first!.add(Duration(days: i));

                                        dates.datesList.add(
                                          DatesList(
                                              dateTime: date, timeRemaining: 8),
                                        );
                                      }
                                    });
                                  },
                                ),
                              );
                            }
                          : null,
                      child: SelectDateButton(
                        date: second,
                        title: 'End date',
                        description: 'Select a start date first',
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
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
                        backgroundColor: first == null
                            ? const Color.fromARGB(255, 250, 250, 250)
                            : Colors.transparent,
                        primary:
                            first == null ? Colors.grey[400] : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: first == null
                          ? null
                          : () {
                              showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: MaterialLocalizations.of(context)
                                    .modalBarrierDismissLabel,
                                pageBuilder: (BuildContext buildContext,
                                        Animation animation,
                                        Animation secondaryAnimation) =>
                                    SelectionDialog(
                                  isArrivalIncluded: isArrivalIncluded,
                                ),
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

class SelectDateButton extends StatelessWidget {
  const SelectDateButton({
    Key? key,
    required this.date,
    required this.title,
    required this.description,
  }) : super(key: key);

  final DateTime? date;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    date != null
                        ? DateFormat.yMMMMd('en_US').format(date!)
                        : description,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  if (date != null)
                    Text(
                      DateFormat.EEEE().format(date!),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
