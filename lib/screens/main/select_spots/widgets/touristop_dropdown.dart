import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class TDropdownButton extends StatelessWidget {
  const TDropdownButton(
      {Key? key,
      required this.hint,
      this.value,
      required this.listItems,
      required this.onChanged})
      : super(key: key);

  final String hint;
  final dynamic value;
  final List<Map<dynamic, Object>> listItems;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      isExpanded: true,
      customButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hint,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 146, 146, 146),
                ),
              ),
              Text(
                value ?? 'Select Item',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const FaIcon(
            FontAwesomeIcons.sort,
            color: Colors.black45,
          ),
        ],
      ),
      buttonDecoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 8,
            blurRadius: 5,
            offset: Offset(0, 3),
          )
        ],
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      items: listItems.map((item) {
        return DropdownMenuItem(
            value: item['value'], child: Text(item['text'].toString()));
      }).toList(),
      onChanged: (value) {
        onChanged(value);
      },
      offset: const Offset(0, 10),
    );
  }
}
