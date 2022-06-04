import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/theme/app_colors.dart';

class SelectionDialog extends ConsumerStatefulWidget {
  const SelectionDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectionDialog> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends ConsumerState<SelectionDialog> {
  String selected = '';

  @override
  Widget build(BuildContext context) {
    final dates = ref.watch(datesProvider);

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
                  'Choose a plan for your trip',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 30),
                SelectionCard(
                  title: 'Plan your own trip',
                  body:
                      'Choose a date and pick the tourist spots you want to go to.',
                  selected: selected,
                  onClick: (value) {
                    setState(() {
                      selected = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                SelectionCard(
                  title: 'Let us plan it for you',
                  body:
                      'Choose the tourist spots you want to go to and we will handle the dates for you.',
                  selected: selected,
                  onClick: (value) {
                    setState(() {
                      selected = value;
                    });
                  },
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
                        dates.setSelectedDate(dates.datesList.first);

                        if (selected == 'Plan your own trip') {
                          Navigator.pushNamed(context, '/select/spots');
                        } else {
                          Navigator.pushNamed(context, '/select/spots/cluster');
                        }
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

class SelectionCard extends StatelessWidget {
  const SelectionCard({
    Key? key,
    required this.title,
    required this.body,
    required this.selected,
    required this.onClick,
  }) : super(key: key);

  final String title;
  final String body;
  final String selected;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(title),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: selected == title ? AppColors.slime : Colors.white,
          boxShadow: const [
            BoxShadow(
              color: AppColors.elevation,
              blurRadius: 5,
              offset: Offset(1, 5),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.coldBlue,
                    AppColors.slime,
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: selected == title ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    body,
                    style: TextStyle(
                      color: selected == title ? Colors.white : AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
