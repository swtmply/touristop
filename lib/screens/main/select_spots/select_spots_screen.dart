import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:touristop/main.dart';
import 'package:touristop/models/tourist_spot_model.dart';
import 'package:touristop/screens/main/select_spots/widgets/app_dropdown.dart';
import 'package:touristop/screens/main/select_spots/widgets/spot_list_item.dart';

class SelectSpotsScreen extends ConsumerStatefulWidget {
  const SelectSpotsScreen({Key? key}) : super(key: key);

  @override
  SelectSpotsScreenState createState() => SelectSpotsScreenState();
}

class SelectSpotsScreenState extends ConsumerState<SelectSpotsScreen> {
  final Stream<QuerySnapshot> spots =
      FirebaseFirestore.instance.collection('spots').snapshots();

  String? selectedDate = 'Select Date';

  @override
  Widget build(BuildContext context) {
    final dates = ref.watch(datesProvider);

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

            // filter docs with specific date
            final data = snapshot.requireData;
            final docs = data.docs;

            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Places to go to',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        AppDropdown(
                          value: selectedDate.toString(),
                          hint: 'Select Date',
                          onChanged: (value) {
                            setState(() {
                              selectedDate = value;
                            });
                          },
                          listItems: dates.dates.map((date) {
                            return DateFormat.yMd().format(date).toString();
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        return SpotListItem(
                          spot: TouristSpot(
                            name: docs[index]['name'],
                            description: docs[index]['description'],
                            image: docs[index]['image'],
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
