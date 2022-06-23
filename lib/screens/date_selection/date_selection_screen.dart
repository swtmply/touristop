import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touristop/screens/date_selection/widgets/date_selection_button.dart';
import 'package:touristop/screens/date_selection/widgets/datepicker_dialog.dart';
import 'package:touristop/screens/date_selection/widgets/selection_dialog.dart';
import 'package:touristop/theme/app_spacing.dart';

class DateSelectionScreen extends ConsumerStatefulWidget {
  const DateSelectionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DateSelectionScreenState();
}

class _DateSelectionScreenState extends ConsumerState<DateSelectionScreen> {
  DateTime? first, second;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xxl,
            horizontal: AppSpacing.base,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select your dates of travel',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: AppSpacing.base,
              ),
              InkWell(
                onTap: () {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: "",
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return TSDatePickerDialog(
                        minDate: DateTime.now(),
                        onChange: (DateTime date) {
                          setState(() {
                            first = date;
                            second = first!.add(const Duration(days: 1));
                          });
                        },
                      );
                    },
                  );
                },
                child: DateSelectionButton(
                  title: 'Start date',
                  placeholder: 'Please select a date',
                  date: first,
                ),
              ),
              const SizedBox(
                height: AppSpacing.small,
              ),
              InkWell(
                onTap: first != null
                    ? () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: "",
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return TSDatePickerDialog(
                              minDate: first!.add(const Duration(days: 1)),
                              maxDate: first?.add(const Duration(days: 7)),
                              onChange: (DateTime date) {
                                setState(() {
                                  second = date;
                                });
                              },
                            );
                          },
                        );
                      }
                    : null,
                child: DateSelectionButton(
                  title: 'Travel end date',
                  placeholder: 'Please select a start date first',
                  date: second,
                ),
              ),
              const SizedBox(
                height: AppSpacing.base,
              ),
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
                      primary: first == null ? Colors.grey[400] : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: second == null
                        ? null
                        : () {
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: "",
                              pageBuilder: (BuildContext buildContext,
                                      Animation animation,
                                      Animation secondaryAnimation) =>
                                  SelectionDialog(
                                start: first!,
                                end: second!,
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
    );
  }
}
