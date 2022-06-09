// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:touristop/models/dates_list/dates_list_model.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/providers/selected_bundle.dart';
import 'package:touristop/providers/spots_provider.dart';
import 'package:touristop/providers/user_location.dart';
import 'package:touristop/screens/main/select_spots/select_spots_screen.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/utils/bundles.dart';
import 'package:touristop/utils/convert_to.dart';
import 'package:touristop/utils/navigation.dart';
import 'package:touristop/utils/reviews.dart';

class SelectionDialog extends ConsumerStatefulWidget {
  final bool isArrivalIncluded;
  const SelectionDialog({Key? key, required this.isArrivalIncluded})
      : super(key: key);

  @override
  ConsumerState<SelectionDialog> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends ConsumerState<SelectionDialog> {
  final datesBox = Hive.box<DatesList>('dates');
  final spots = FirebaseFirestore.instance.collection('spots');

  String selected = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final dates = ref.watch(datesProvider);
    final selectedBundles = ref.watch(selectedBundleProvider);
    final userPosition = ref.watch(userLocationProvider);
    final allSpots = ref.watch(spotsProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: _isLoading
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballRotateChase,
                      colors: [AppColors.coldBlue, AppColors.slime],
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Generating your schedule. Please wait...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 15,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose a plan for your trip',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SelectionCard(
                        title: 'Plan your own trip',
                        body:
                            'Choose a date/s and pick the tourist spots you want to go to.',
                        selected: selected,
                        onClick: (value) {
                          setState(() {
                            selected = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      SelectionCard(
                        title: 'Let us plan it for you',
                        body:
                            'Sit back and relax. The application will generate everything for you',
                        selected: selected,
                        onClick: (value) {
                          setState(() {
                            selected = value;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 180,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color.fromRGBO(93, 107, 230, 1),
                                Color.fromRGBO(93, 230, 197, 1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            onPressed: () async {
                              final finalDates = dates.datesList.map((e) =>
                                  DatesList(
                                      dateTime: e.dateTime, timeRemaining: 8));

                              await datesBox.clear();
                              datesBox.putAll({
                                for (var e in finalDates)
                                  dates.toDateKey(e.dateTime): e
                              });

                              // Build Tourist Spots
                              QuerySnapshot snapshot = await spots.get();
                              final docs = snapshot.docs.map((e) => e).toList();

                              setState(() {
                                _isLoading = true;
                              });

                              allSpots.addAll(
                                await docsToTouristSpotList(
                                  docs,
                                  userPosition.position!,
                                ),
                              );

                              setState(() {
                                _isLoading = false;
                              });

                              dates.setSelectedDate(dates.datesList.first);
                              if (selected == 'Plan your own trip') {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SelectSpotsScreen(),
                                  ),
                                  (Route<dynamic> router) => false,
                                );
                              } else {
                                setState(() {
                                  _isLoading = true;
                                });

                                for (var e in dates.datesList) {
                                  await Bundles.getBundleByDate(
                                    e.dateTime,
                                    selectedBundles,
                                    userPosition,
                                  );
                                }

                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const Navigation(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              }
                            },
                            child: Text(
                              'Submit',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

class SelectionCard extends StatelessWidget {
  const SelectionCard({
    Key? key,
    required this.title,
    required this.body,
    required this.selected,
    required this.onClick,
  }) : super(key: key);

  final String title;
  final String body;
  final String selected;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClick(title),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: selected == title ? AppColors.slime : Colors.white,
          boxShadow: const [
            BoxShadow(
              color: AppColors.elevation,
              blurRadius: 5,
              offset: Offset(1, 5),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.coldBlue,
                    AppColors.slime,
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: selected == title ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    body,
                    style: TextStyle(
                      color: selected == title ? Colors.white : AppColors.gray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
