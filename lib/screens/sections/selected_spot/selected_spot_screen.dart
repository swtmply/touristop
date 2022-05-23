import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touristop/main.dart';

class SpotInformation extends ConsumerWidget {
  const SpotInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedSpotProvider);

    Size size = MediaQuery.of(context).size;
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
                        selected.spot!.image,
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
                    selected.spot!.name,
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
                    initialRating: 5,
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
                              text: selected.spot!.fee,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox.fromSize(
                      size: const Size(86, 56),
                      child: Material(
                        child: InkWell(
                          onTap: () {},
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
                    Container(
                      padding: const EdgeInsets.only(top: 12),
                      child: SizedBox.fromSize(
                        size: const Size(86, 70),
                        child: Material(
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Icon(
                                  Icons.add,
                                  color: Color.fromRGBO(130, 130, 130, 1),
                                  size: 30,
                                ),
                                Text(
                                  "Add to Schedule",
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
                    SizedBox.fromSize(
                      size: const Size(86, 56),
                      child: Material(
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
                    'Address: ${selected.spot!.address}',
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
                    selected.spot!.description.toString(),
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  height: 350,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 200,
                                  // child: ClipRRect(
                                  //   borderRadius: BorderRadius.circular(8.0),
                                  //   child: Image.asset(
                                  //     'assets/images/login_banner.png',
                                  //     width: size.width * 0.35,
                                  //     fit: BoxFit.fitHeight,
                                  //   ),
                                  // ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Rizal Monument',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                RatingBar.builder(
                                  initialRating: 5,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  itemPadding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Color.fromRGBO(255, 239, 100, 1)),
                                  onRatingUpdate: (rating) {
                                    inspect(rating);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 200,
                                  // child: ClipRRect(
                                  //     borderRadius: BorderRadius.circular(8.0),
                                  //     child: Image.asset(
                                  //       'assets/images/image.png',
                                  //       width: size.width * 0.35,
                                  //       fit: BoxFit.fitHeight,
                                  //     )),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Rizal Monument',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                RatingBar.builder(
                                  initialRating: 5,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  itemPadding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Color.fromRGBO(255, 239, 100, 1)),
                                  onRatingUpdate: (rating) {
                                    inspect(rating);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 200,
                                  // child: ClipRRect(
                                  //   borderRadius: BorderRadius.circular(8.0),
                                  //   child: Image.asset(
                                  //     'assets/images/image.png',
                                  //     width: size.width * 0.35,
                                  //     fit: BoxFit.fitHeight,
                                  //   ),
                                  // ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Rizal Monument',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                RatingBar.builder(
                                  initialRating: 5,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  itemPadding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Color.fromRGBO(255, 239, 100, 1)),
                                  onRatingUpdate: (rating) {
                                    inspect(rating);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
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
