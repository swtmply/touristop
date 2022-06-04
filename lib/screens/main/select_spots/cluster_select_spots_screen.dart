// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:touristop/models/app_geopoint/app_geopoint_model.dart';
import 'package:touristop/models/dates_list/dates_list_model.dart';
import 'package:touristop/models/selected_spots/selected_spots_model.dart';
import 'package:touristop/models/spots_list/spots_list_model.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';
import 'package:touristop/providers/selected_spots.dart';
import 'package:touristop/providers/user_location.dart';
import 'package:touristop/screens/sections/select_spot/spot_information_screen.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/utils/navigation.dart';
import 'package:touristop/utils/reviews.dart';
import 'package:collection/collection.dart';

class DateSchedule {
  DateTime date;
  List<TouristSpot> spots;

  DateSchedule({
    required this.date,
    required this.spots,
  });
}

class ClusterSelectSpots extends ConsumerStatefulWidget {
  const ClusterSelectSpots({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ClusterSelectSpotsState();
}

class _ClusterSelectSpotsState extends ConsumerState<ClusterSelectSpots> {
  late Stream<List<Map<String, dynamic>>> stream;
  final datesList = Hive.box<DatesList>('dates');
  final clusterSpots = Hive.box<SelectedSpots>('selectedSpots');
  final spotsBox = Hive.box<SpotsList>('spots');

  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection('spots')
        .snapshots()
        .asyncMap((QuerySnapshot snapshot) => snapshot.docs
            .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    final userLocation = ref.watch(userLocationProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        splashColor: AppColors.slime,
        backgroundColor: AppColors.coldBlue,
        onPressed: () {
          // ignore: todo
          // TODO loop through dates
          Map<String, DateSchedule> schedule = {};
          final selectedSpots = clusterSpots.values.toList();
          selectedSpots.sort((a, b) {
            return a.spot.dates.length > b.spot.dates.length ? 1 : 0;
          });
          List<String> toRemove = [];

          for (DatesList datesList in datesList.values) {
            final day = DateFormat('E').format(datesList.dateTime).toString();
            final date = datesList.dateTime.toString();
            double timeRemaining = 8;
            for (SelectedSpots selected in selectedSpots) {
              final open = selected.spot.dates
                  .firstWhereOrNull((element) => element['date'] == day);

              if (toRemove.contains(selected.spot.name)) {
                continue;
              }

              if (open != null) {
                if (timeRemaining - selected.spot.numberOfHours >= 0) {
                  if (schedule[date] == null) {
                    schedule[date] =
                        DateSchedule(date: datesList.dateTime, spots: []);
                  }

                  schedule[date]!.spots.add(selected.spot);
                  timeRemaining -= selected.spot.numberOfHours;
                  toRemove.add(selected.spot.name);
                }
              }
            }
          }

          schedule.forEach((key, value) {
            for (TouristSpot spot in value.spots) {
              final spotItem = SpotsList(
                spot: spot,
                date: DateTime.parse(key),
              );
              String boxKey = '$key${spot.name}';

              spotsBox.put(boxKey, spotItem);
            }
          });

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Navigation(),
            ),
          );
        },
        label: const Text('Continue'),
        icon: const Icon(Icons.arrow_forward_outlined),
      ),
      body: SafeArea(
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    child: Text(
                      'Select places to go to',
                      style: GoogleFonts.inter(
                          fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder<List<TouristSpot>>(
                    future: touristSpotsList(
                        snapshot.data!, userLocation.position!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data;
                        return Expanded(
                          child: ListView.builder(
                            itemCount: data!.length,
                            itemBuilder: (context, index) {
                              return ClusterSpotListItem(spot: data[index]);
                            },
                          ),
                        );
                      } else {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      }
                    },
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
          },
        ),
      ),
    );
  }

  Future<List<TouristSpot>> touristSpotsList(
      List<Map<String, dynamic>> docList, Position userPosition) async {
    List<TouristSpot> spots = [];

    for (Map<String, dynamic> document in docList) {
      final spot = await generateTouristSpot(document, userPosition);
      spots.add(spot);
    }

    return spots;
  }

  Future<TouristSpot> generateTouristSpot(
      Map<String, dynamic> document, Position userPosition) async {
    final position = AppGeoPoint(
      latitude: document['position'].latitude,
      longitude: document['position'].longitude,
    );
    double distanceFromUser = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      userPosition.latitude,
      userPosition.longitude,
    );

    return TouristSpot(
      name: document['name'],
      description: document['description'],
      image: document['image'],
      position: position,
      address: document['address'],
      fee: document['fee'],
      distanceFromUser: distanceFromUser / 1000,
      dates: document['dates'],
      type: document['type'],
      numberOfHours: double.parse(document['numberOfHours'].toString()),
      averageRating: await Reviews.reviewAverage(document['name']),
    );
  }

  String generateKey(TouristSpot spot) {
    return spot.name;
  }
}

class ClusterSpotListItem extends ConsumerStatefulWidget {
  final TouristSpot spot;

  const ClusterSpotListItem({Key? key, required this.spot}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ClusterSpotListItem();
}

class _ClusterSpotListItem extends ConsumerState<ClusterSpotListItem> {
  final clusterSpots = Hive.box<SelectedSpots>('selectedSpots');

  @override
  Widget build(BuildContext context) {
    final spot = widget.spot;
    String key = spot.name;
    bool isSelected = clusterSpots.containsKey(key);
    final selectedSpots = ref.watch(selectedSpotsProvider);

    return InkWell(
      onTap: () {
        selectedSpots.setFirstSpot(widget.spot);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpotInformation(
              spot: widget.spot,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(93, 107, 230, 1),
                  Color.fromRGBO(93, 230, 197, 1),
                ],
              ),
              image: DecorationImage(
                image: NetworkImage(spot.image),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            spot.name,
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
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: RatingBar.builder(
                          ignoreGestures: true,
                          unratedColor:
                              const Color.fromARGB(100, 255, 241, 114),
                          initialRating: spot.averageRating!.isNaN
                              ? 0
                              : spot.averageRating!,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 25,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 2),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Color.fromRGBO(255, 239, 100, 1),
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 30),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      spot.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, right: 20),
            child: Align(
              alignment: Alignment.topRight,
              child: RoundCheckBox(
                isChecked: isSelected,
                onTap: (selectedItem) {
                  if (selectedItem!) {
                    clusterSpots.put(key, SelectedSpots(spot: spot));
                  } else {
                    clusterSpots.delete(key);
                  }
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
                    child: const FaIcon(FontAwesomeIcons.check,
                        color: Colors.white, size: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
