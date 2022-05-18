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

  DateTime? selectedDate;

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
            final date = selectedDate ?? dates.dates[0];

            // ignore: todo
            // TODO filter by distance
            final docs = data.docs.where((doc) {
              final docData = doc.data()! as Map<String, dynamic>;
              List<dynamic> docDates = docData['dates'] ?? [];
              final day = DateFormat('E').format(date);

              for (var schedule in docDates) {
                if (schedule['date'] == day) return true;
              }

              return false;
            }).toList();

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
                          value: DateFormat('yMd').format(date),
                          hint: 'Select Date',
                          onChanged: (value) {
                            setState(() {
                              selectedDate = value;
                            });
                          },
                          listItems: dates.dates.map((date) {
                            return {
                              'value': date,
                              'text': DateFormat('yMd').format(date)
                            };
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
