import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:touristop/theme/app_spacing.dart';

class DateSelectionButton extends StatelessWidget {
  const DateSelectionButton(
      {Key? key, this.date, required this.title, required this.placeholder})
      : super(key: key);

  final DateTime? date;
  final String title;
  final String placeholder;

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    date != null
                        ? DateFormat.yMMMMd('en_US').format(date!)
                        : placeholder,
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
