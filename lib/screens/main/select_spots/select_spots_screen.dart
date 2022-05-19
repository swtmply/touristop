import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:touristop/boxes/spots_box.dart';
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
    final location = ref.watch(userLocationProvider);

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
            final date = selectedDate ?? dates.dates[0];

            // filter by date
            final docsFilteredByDate = data.docs
                .map((doc) {
                  final docData = doc.data() as Map<String, dynamic>;
                  final docPosition = doc.get('position');
                  double distanceFromUser = Geolocator.distanceBetween(
                        docPosition.latitude,
                        docPosition.longitude,
                        location.userPosition!.latitude,
                        location.userPosition!.longitude,
                      ) /
                      1000;

                  final spot = TouristSpot(
                    name: docData['name'],
                    description: docData['description'],
                    image: docData['image'],
                    dates: docData['dates'],
                    position: docPosition,
                    distanceFromUser: distanceFromUser,
                  );

                  return spot;
                })
                .toList()
                .where((doc) {
                  final day = DateFormat('E').format(date);

                  for (var schedule in doc.dates ?? []) {
                    if (schedule['date'] == day) return true;
                  }

                  return false;
                })
                .toList();

            docsFilteredByDate.sort(
                (a, b) => a.distanceFromUser! < b.distanceFromUser! ? 1 : 0);

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
                      itemCount: docsFilteredByDate.length,
                      itemBuilder: (context, index) {
                        return SpotListItem(
                          spot: TouristSpot(
                            name: docsFilteredByDate[index].name,
                            description: docsFilteredByDate[index].description,
                            image: docsFilteredByDate[index].image,
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
