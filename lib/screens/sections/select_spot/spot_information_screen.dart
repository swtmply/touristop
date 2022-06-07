import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:touristop/models/spots_list/spots_list_model.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/providers/selected_spots.dart';

class SpotInformation extends ConsumerStatefulWidget {
  final TouristSpot spot;
  const SpotInformation({Key? key, required this.spot}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SpotInformationState();
}

class _SpotInformationState extends ConsumerState<SpotInformation> {
  final spotsBox = Hive.box<SpotsList>('spots');
  final spotsCollection = FirebaseFirestore.instance.collection('spots');
  bool isSelected = false;
  String spotKey = '';

  @override
  Widget build(BuildContext context) {
    final spot = widget.spot;
    final selectedDates = ref.watch(datesProvider);
    final selectedSpots = ref.watch(selectedSpotsProvider);

    setState(() {
      spotKey = '${spot.name}${selectedDates.selectedDate!.dateTime}';
      isSelected = spotsBox.containsKey(spotKey);
    });

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
                                  text: 'Mon-Wed-Fri  ',
                                  style: GoogleFonts.inter(
                                    color:
                                        const Color.fromRGBO(93, 107, 230, 1),
                                  )),
                              const TextSpan(text: '\u2022  '),
                              TextSpan(
                                  text: '8:00 AM to 7:00 PM ',
                                  style: GoogleFonts.inter(
                                    color:
                                        const Color.fromRGBO(93, 230, 197, 1),
                                  )),
                            ],
                          )),
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
                            Navigator.pushNamed(context, '/map');
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
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          final spotItem = SpotsList(
                            spot: spot,
                            date: selectedDates.selectedDate!.dateTime,
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
                        },
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
                                  color:
                                      const Color.fromRGBO(130, 130, 130, 1)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/selected/spot/reviews',
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
                const SizedBox(
                  height: 40,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: spotsCollection
                      .where('type', isEqualTo: spot.type)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }

                    final data = snapshot.requireData;
                    final docs = data.docs;

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      height: 300,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data =
                              docs[index].data() as Map<String, dynamic>;

                          if (data['name'] == widget.spot.name) {
                            return Container();
                          }

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
                                        data['image'],
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      data['name'],
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
