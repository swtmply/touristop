import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:touristop/models/dates_list/dates_list_model.dart';
import 'package:touristop/models/plan.dart';
import 'package:touristop/models/spots_list/spots_list_model.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/providers/spots_provider.dart';
import 'package:touristop/screens/main/map/pin_map_screen.dart';
import 'package:touristop/screens/sections/select_spot/spot_reviews_screen.dart';
import 'package:touristop/theme/app_colors.dart';

class SpotInformation extends ConsumerStatefulWidget {
  final TouristSpot spot;
  final bool isSelectable;
  final bool? isSchedule;
  final bool? isSelected;

  const SpotInformation({
    Key? key,
    required this.spot,
    required this.isSelectable,
    this.isSchedule,
    this.isSelected,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SpotInformationState();
}

class _SpotInformationState extends ConsumerState<SpotInformation> {
  final spotsBox = Hive.box<SpotsList>('spots');
  final plan = Hive.box<Plan>('plan');
  final spotsCollection = FirebaseFirestore.instance.collection('spots');
  bool isSelected = false;
  String spotKey = '';
  FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    final spot = widget.spot;
    final selectedDates = ref.watch(datesProvider);
    final allSpots = ref.watch(spotsProvider);
    final dates = ref.watch(datesProvider);
    final datesBox = Hive.box<DatesList>('dates');
    final key =
        selectedDates.selectedDate?.dateTime ?? datesBox.values.first.dateTime;
    final datesListItem = datesBox.get(dates.toDateKey(key));

    setState(() {
      spotKey = '${spot.name}$key';
      isSelected = spotsBox.containsKey(spotKey);
    });

    speak() async {
      await flutterTts.setPitch(1);
      await flutterTts.speak(spot.description);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                Container(
                  height: 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        spot.image,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 30, left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: TextButton.icon(
                      label: Text(
                        'Back',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      icon: const FaIcon(
                        FontAwesomeIcons.chevronLeft,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 5),
                  alignment: Alignment.topLeft,
                  child: Text(
                    spot.name,
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 15),
                  child: RatingBar.builder(
                    initialRating: spot.averageRating!,
                    ignoreGestures: true,
                    unratedColor: const Color.fromARGB(100, 255, 241, 114),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 25,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2),
                    itemBuilder: (context, _) => const Icon(Icons.star,
                        color: Color.fromRGBO(255, 239, 100, 1)),
                    onRatingUpdate: (rating) {
                      debugPrint(rating.toString());
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          children: <TextSpan>[
                            const TextSpan(text: 'Open  '),
                            TextSpan(
                                text:
                                    '${spot.dates.first['date']}-${spot.dates.last['date']}  ',
                                style: GoogleFonts.inter(
                                  color: const Color.fromRGBO(93, 107, 230, 1),
                                )),
                            const TextSpan(text: '\u2022  '),
                            TextSpan(
                                text: spot.dates.first['timeOpen'] == '6:00AM'
                                    ? 'Open 24 Hours'
                                    : '${spot.dates.first['timeOpen']} to ${spot.dates.first['timeClose']} ',
                                style: GoogleFonts.inter(
                                  color: const Color.fromRGBO(93, 230, 197, 1),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        children: <TextSpan>[
                          const TextSpan(text: 'Entrance Fee: '),
                          TextSpan(
                              text: spot.fee,
                              style: GoogleFonts.inter(
                                color: const Color.fromARGB(255, 18, 18, 18),
                                fontSize: 12,
                              )),
                        ],
                      )),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    height: 20,
                    thickness: 2,
                    color: Colors.grey[300],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Material(
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PinMapScreen(
                                  spot: spot,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(
                                Icons.location_on_outlined,
                                color: Color.fromRGBO(130, 130, 130, 1),
                                size: 30,
                              ),
                              Text(
                                "Pin to Map",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: const Color.fromRGBO(130, 130, 130, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.isSelectable == true ||
                          widget.isSelected != null &&
                              widget.isSelected == true,
                      child: Visibility(
                        visible:
                            plan.get('plan')!.selected == 'Plan your own trip',
                        child: Expanded(
                          child: InkWell(
                            onTap: widget.isSelectable
                                ? () {
                                    final spotItem = SpotsList(
                                      spot: spot,
                                      date:
                                          selectedDates.selectedDate!.dateTime,
                                    );

                                    setState(() {
                                      if (isSelected) {
                                        spotsBox.delete(spotKey);
                                      } else {
                                        spotsBox.put(
                                          spotKey,
                                          spotItem,
                                        );
                                      }

                                      isSelected = !isSelected;
                                    });
                                  }
                                : null,
                            child: Column(
                              children: <Widget>[
                                isSelected
                                    ? const Icon(
                                        Icons.close,
                                        color: Color.fromRGBO(130, 130, 130, 1),
                                        size: 30,
                                      )
                                    : const Icon(
                                        Icons.add,
                                        color: Color.fromRGBO(130, 130, 130, 1),
                                        size: 30,
                                      ),
                                Text(
                                  spotsBox.containsKey(
                                          '${spot.name}${selectedDates.selectedDate}')
                                      ? 'Remove to Schedule'
                                      : "Add to Schedule",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: const Color.fromRGBO(
                                          130, 130, 130, 1)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SpotReviews(
                                spot: spot,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.reviews_outlined,
                              color: Color.fromRGBO(130, 130, 130, 1),
                              size: 30,
                            ),
                            Text(
                              "Reviews",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: const Color.fromRGBO(130, 130, 130, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    height: 20,
                    thickness: 2,
                    color: Colors.grey[300],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          'Address: ${spot.address}',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 134, 134, 134),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () async {
                            await speak();
                          },
                          icon: const Icon(
                            Icons.spatial_audio_off,
                            color: AppColors.coldBlue,
                          ),
                          label: Text(
                            'Speak',
                            style: GoogleFonts.inter(
                              color: AppColors.coldBlue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    spot.description.toString(),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Guidelines to follow:',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    spot.guideline,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Visibility(
                  visible:
                      widget.isSchedule == false || widget.isSchedule == null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    height: 330,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: allSpots.spots.length,
                      itemBuilder: (context, index) {
                        final data = allSpots.spots[index];

                        bool isSelectable = datesListItem!.timeRemaining -
                                allSpots.spots[index].numberOfHours >=
                            0;

                        if (data.name == widget.spot.name) {
                          return Container();
                        }

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SpotInformation(
                                  spot: data,
                                  isSelectable: isSelectable,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      data.image,
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    data.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                RatingBar.builder(
                                  initialRating: data.averageRating!,
                                  ignoreGestures: true,
                                  unratedColor:
                                      const Color.fromARGB(100, 255, 241, 114),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 25,
                                  itemPadding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Color.fromRGBO(255, 239, 100, 1)),
                                  onRatingUpdate: (rating) {
                                    debugPrint(rating.toString());
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
