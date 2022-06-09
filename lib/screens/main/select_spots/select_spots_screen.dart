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
import 'package:touristop/providers/spots_provider.dart';
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
  final datesBox = Hive.box<DatesList>('dates');
  final spotsList = Hive.box<SpotsList>('spots');

  late DatesList currentDate;
  late double timeRemaining;
  late String day;

  @override
  Widget build(BuildContext context) {
    final selectedDates = ref.watch(datesProvider);
    final allSpots = ref.watch(spotsProvider);

    setState(() {
      currentDate = selectedDates.selectedDate!;
      final dateInBox = selectedDates.findByDate(currentDate.dateTime);

      timeRemaining = dateInBox!.timeRemaining;
      day = DateFormat('E').format(currentDate.dateTime).toString();
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
        child: SafeArea(
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
                        final date = datesBox
                            .get(DateFormat('yMd').format(value).toString());

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
                child: _buildListView(allSpots.spots),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(List<TouristSpot> spots) {
    List<TouristSpot> touristSpots = spots.where((element) {
      final found =
          element.dates.firstWhereOrNull((element) => element['date'] == day);

      if (found != null) {
        return true;
      }

      return false;
    }).toList();

    touristSpots.sort((a, b) => a.averageRating! < b.averageRating! ? 1 : 0);

    return ListView.builder(
      itemCount: touristSpots.length,
      itemBuilder: (context, index) {
        if (spotsList.values.isNotEmpty) {
          final selected = spotsList.values.firstWhereOrNull((element) {
            if (element.spot.name == touristSpots[index].name) {
              return true;
            }

            return false;
          });

          if (selected?.date != currentDate.dateTime &&
              selected?.spot.name == touristSpots[index].name) {
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
