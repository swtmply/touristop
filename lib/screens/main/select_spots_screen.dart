import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:touristop/main.dart';
import 'package:touristop/models/tourist_spot_model.dart';
import 'package:touristop/screens/sections/spot_information.dart';
// import 'second_page.dart';

class SelectSpotsScreen extends ConsumerStatefulWidget {
  const SelectSpotsScreen({Key? key}) : super(key: key);

  @override
  SelectSpotsScreenState createState() => SelectSpotsScreenState();
}

class SelectSpotsScreenState extends ConsumerState<SelectSpotsScreen> {
  final Stream<QuerySnapshot> spots =
      FirebaseFirestore.instance.collection('spots').snapshots();

  final List<String> genderItems = [
    'Male',
    'Female',
  ];

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final spot = ref.watch(spotsProvider);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: StreamBuilder<QuerySnapshot>(
          stream: spots,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            final data = snapshot.requireData;

            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20,
                    ),
                    child: Text(
                      'Places to go to',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButtonFormField2(
                          buttonDecoration: const BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 8,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            )
                          ]),
                          customButton: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sorted by:',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromARGB(
                                          255, 146, 146, 146),
                                    ),
                                  ),
                                  Text(
                                    selectedValue ?? 'Select Item',
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
                          isExpanded: true,
                          hint: Text(
                            'Select Your Gender',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          icon: const FaIcon(
                            FontAwesomeIcons.sort,
                            color: Colors.black45,
                          ),
                          items: genderItems
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select gender.';
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value.toString();
                            });
                          },
                          offset: const Offset(0, -10),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.size,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            spot.setSelectedSpot(TouristSpot(
                              name: data.docs[index]['name'].toString(),
                              description: data.docs[index]['description'].toString(),
                              image: data.docs[index]['image'].toString()
                            ));
                            Navigator.pushNamed(context, '/selected-spot');
                          },
                          child: Stack(
                            children: <Widget>[
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        '${data.docs[index]['image']}'),
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      const Color.fromARGB(255, 0, 0, 0)
                                          .withOpacity(0.6),
                                      BlendMode.darken,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              width: size.width * 0.5,
                                              child: Text(
                                                '${data.docs[index]['name']}',
                                                overflow: TextOverflow.clip,
                                                maxLines: 1,
                                                style: GoogleFonts.inter(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 10),
                                            child: RatingBar.builder(
                                              initialRating: 5,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 25,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2),
                                              itemBuilder: (context, _) =>
                                                  const Icon(Icons.star,
                                                      color: Color.fromRGBO(
                                                          255, 239, 100, 1)),
                                              onRatingUpdate: (rating) {
                                                print(rating);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 30),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${data.docs[index]['description']}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: GoogleFonts.inter(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 20, right: 20),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: RoundCheckBox(
                                    onTap: (selected) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SpotInformation(),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    },
                                    size: 25,
                                    checkedColor: Colors.transparent,
                                    uncheckedColor: Colors.transparent,
                                    border: Border.all(
                                      width: 3,
                                      color: Colors.white,
                                    ),
                                    checkedWidget: Container(
                                        padding: const EdgeInsets.all(2),
                                        child: const FaIcon(
                                            FontAwesomeIcons.check,
                                            color: Colors.white,
                                            size: 16)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
