// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:touristop/models/dates_list/dates_list_model.dart';
import 'package:touristop/models/spots_list/spots_list_model.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/providers/user_location.dart';
import 'package:touristop/screens/main/select_spots/widgets/app_dropdown.dart';
import 'package:touristop/screens/main/select_spots/widgets/spot_list_item.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/utils/convert_to.dart';
import 'package:touristop/utils/navigation.dart';
import 'package:touristop/utils/reviews.dart';
import 'package:collection/collection.dart';

class SelectSpotsScreen extends ConsumerStatefulWidget {
  const SelectSpotsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectSpotsScreenState();
}

class _SelectSpotsScreenState extends ConsumerState<SelectSpotsScreen> {
  final Stream<QuerySnapshot> spots =
      FirebaseFirestore.instance.collection('spots').snapshots();

  late DatesList currentDate;
  late double timeRemaining;
  late Future<List<TouristSpot>> Function(
      List<QueryDocumentSnapshot<Object?>>, Position) _docsToTouristSpotList;

  @override
  void initState() {
    super.initState();
    _docsToTouristSpotList = docsToTouristSpotList;
  }

  @override
  Widget build(BuildContext context) {
    final datesBox = Hive.box<DatesList>('dates');
    final spotsList = Hive.box<SpotsList>('spots');
    final location = ref.watch(userLocationProvider);
    final selectedDates = ref.watch(datesProvider);

    setState(() {
      currentDate = selectedDates.selectedDate!;
      final dateInBox = selectedDates.findByDate(currentDate.dateTime);

      timeRemaining = dateInBox!.timeRemaining;
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        splashColor: AppColors.slime,
        backgroundColor: AppColors.coldBlue,
        label: const Text('Continue'),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Navigation(),
            ),
          );
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

            final docs = snapshot.requireData.docs;

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
                        Text(
                          'Select places to go to',
                          style: GoogleFonts.inter(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AppDropdown(
                          value: DateFormat('yMd').format(currentDate.dateTime),
                          hint: 'Select Dates:',
                          listItems: selectedDates.datesList.map((date) {
                            return {
                              'value': date.dateTime,
                              'text': DateFormat('yMd').format(date.dateTime)
                            };
                          }).toList(),
                          onChanged: (value) {
                            final date = datesBox.get(
                                DateFormat('yMd').format(value).toString());

                            setState(() {
                              selectedDates.setSelectedDate(date!);
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
                    child: FutureBuilder(
                      future: _docsToTouristSpotList(docs, location.position!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final day = DateFormat('E')
                              .format(currentDate.dateTime)
                              .toString();
                          final data = snapshot.data as List<TouristSpot>;
                          List<TouristSpot> touristSpots =
                              data.where((element) {
                            final found = element.dates.firstWhereOrNull(
                                (element) => element['date'] == day);

                            if (found != null) {
                              return true;
                            }

                            return false;
                          }).toList();

                          touristSpots.sort((a, b) =>
                              a.averageRating! < b.averageRating! ? 1 : 0);

                          return ListView.builder(
                            itemCount: touristSpots.length,
                            itemBuilder: (context, index) {
                              if (spotsList.values.isNotEmpty) {
                                final selected = spotsList.values
                                    .firstWhereOrNull((element) {
                                  if (element.spot.name ==
                                      touristSpots[index].name) {
                                    return true;
                                  }

                                  return false;
                                });

                                if (selected?.date != currentDate.dateTime &&
                                    selected?.spot.name ==
                                        touristSpots[index].name) {
                                  return Container();
                                }

                                return SpotListItem(
                                  spot: touristSpots[index],
                                  selectedDate: currentDate.dateTime,
                                );
                              } else {
                                return SpotListItem(
                                  spot: touristSpots[index],
                                  selectedDate: currentDate.dateTime,
                                );
                              }
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
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

  Future<List<TouristSpot>> docsToTouristSpotList(
      List<QueryDocumentSnapshot<Object?>> docs, Position userPosition) async {
    List<TouristSpot> touristSpots = docs
        .map((doc) => ConvertTo.touristSpot(
            doc.data() as Map<String, dynamic>, userPosition))
        .toList();

    for (TouristSpot spot in touristSpots) {
      double rating = await Reviews.reviewAverage(spot.name);

      spot.averageRating = rating.isNaN ? 0 : rating;
    }

    return touristSpots;
  }
}
