import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:touristop/main.dart';
import 'package:touristop/models/date/date_model.dart';
import 'package:touristop/models/geopoint/geopoint_model.dart' as app;
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';
import 'package:touristop/screens/main/select_spots/widgets/spot_list_item.dart';
import 'package:touristop/screens/main/select_spots/widgets/touristop_dropdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touristop/theme/app_colors.dart';


class SelectSpotsScreen extends ConsumerStatefulWidget {
  const SelectSpotsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectSpotsScreenState();
}

class _SelectSpotsScreenState extends ConsumerState<SelectSpotsScreen> {
  final Stream<QuerySnapshot> spots =
      FirebaseFirestore.instance.collection('spots').snapshots();

  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final dates = Hive.box<Date>('dates');
    final location = ref.watch(userLocationProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        splashColor: AppColors.slime,
        backgroundColor: AppColors.coldBlue,
        label: const Text('Continue'),
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(context, '/map', (route) => false);
        },
        icon: const Icon(Icons.arrow_forward_outlined),
      ),
      body: SizedBox(
        height: double.infinity,
        child: StreamBuilder<QuerySnapshot>(
          stream: spots,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong in the stream provided');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            final currentDate = _selectedDate ?? dates.values.toList()[0].date;
            final docs = snapshot.requireData.docs;

            List<TouristSpot> touristSpots = docs
                .map((doc) => documentToTouristSpot(doc, location.position!))
                .toList();

            // ignore: todo
            // TODO update sorting method
            touristSpots.sort(
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
                        Text('Select places to go to', style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                        ),),
                        const SizedBox(
                          height: 20,
                        ),
                        TDropdownButton(
                          value: DateFormat('yMd').format(currentDate),
                          hint: 'Select Dates:',
                          listItems: dates.values.map((date) {
                            return {
                              'value': date.date,
                              'text': DateFormat('yMd').format(date.date)
                            };
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDate = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: touristSpots.length,
                      itemBuilder: (context, index) {
                        return SpotListItem(touristSpots[index], currentDate);
                      },
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  TouristSpot documentToTouristSpot(
      QueryDocumentSnapshot<Object?> doc, Position userPosition) {
    final document = doc.data() as Map<String, dynamic>;
    final position = app.GeoPoint()
      ..latitude = document['position'].latitude
      ..longitude = document['position'].longitude;
    double distanceFromUser = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          userPosition.latitude,
          userPosition.longitude,
        ) /
        1000;

    final spot = TouristSpot(
      name: document['name'],
      description: document['description'],
      image: document['image'],
      position: position,
      address: document['address'],
      fee: document['fee'],
      distanceFromUser: distanceFromUser,
      dates: document['dates'],
    );

    return spot;
  }
}
