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
import 'package:touristop/providers/selected_spots.dart';
import 'package:touristop/providers/spots_provider.dart';
import 'package:touristop/providers/user_location.dart';
import 'package:touristop/screens/main/select_spots/widgets/app_dropdown.dart';
import 'package:touristop/screens/main/select_spots/widgets/spot_list_item.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/utils/convert_to.dart';
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
  @override
  Widget build(BuildContext context) {
    final selectedDates = ref.watch(datesProvider);
    final selectedSpots = ref.watch(selectedSpotsProvider);
    final allSpots = ref.watch(spotsProvider);
    final userPosition = ref.watch(userLocationProvider);

    setState(() {
      currentDate = selectedDates.selectedDate ?? datesBox.values.first;
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        splashColor: AppColors.slime,
        backgroundColor: AppColors.coldBlue,
        label: const Text('Continue'),
        onPressed: () {
          selectedSpots.setNull();
          bool warning = false;
          for (var date in selectedDates.datesList) {
            final formatDate = DateFormat('yMd').format(date.dateTime);
            final exists = spotsList.values.firstWhereOrNull((element) {
              final formatDateElement = DateFormat('yMd').format(element.date);

              return formatDate == formatDateElement;
            });

            if (exists == null) {
              warning = true;
              break;
            }
          }

          if (warning) {
            showDialog(
              context: context,
              builder: (context) => _showWarning(),
            );
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/navigation',
              (route) => false,
            );
          }
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
                    const SizedBox(height: 10),
                    const Text(
                        'Note: Please select a tourist spot for each date.'),
                    const SizedBox(height: 10),
                    AppDropdown(
                      value: DateFormat('yMd').format(currentDate.dateTime),
                      hint: 'Select Dates:',
                      listItems: datesBox.values.map((date) {
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
                  ],
                ),
              ),
              if (allSpots.spots.isEmpty)
                FutureBuilder(
                  future: allSpots.init(userPosition.position!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }

                    return Expanded(
                      child: _buildListView(allSpots.spots),
                    );
                  },
                )
              else
                Expanded(
                  child: _buildListView(allSpots.spots),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _showWarning() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: SizedBox(
          height: 135,
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Please select a tourist spot/s in all of the dates. Some dates will have no schedule, are you sure you want to continue?'),
              Expanded(
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.slime,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/navigation',
                        (route) => false,
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      backgroundColor: AppColors.coldBlue,
                    ),
                    child: Text(
                      'Confirm',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(List<TouristSpot> spots) {
    List<TouristSpot> touristSpots = spots.where((element) {
      final found = element.dates.firstWhereOrNull((element) =>
          element['date'] ==
          DateFormat('E').format(currentDate.dateTime).toString());

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
