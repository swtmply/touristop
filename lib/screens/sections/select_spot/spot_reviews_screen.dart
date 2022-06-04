import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touristop/providers/selected_spots.dart';
import 'package:touristop/screens/sections/select_spot/all_spot_reviews_screen.dart';
import 'package:touristop/utils/reviews.dart';

class SpotReviews extends ConsumerStatefulWidget {
  const SpotReviews({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SpotReviewsState();
}

class _SpotReviewsState extends ConsumerState<SpotReviews> {
  final reviewField = TextEditingController();

  String review = '';
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    final selectedSpot = ref.watch(selectedSpotsProvider);
    final reviews = FirebaseFirestore.instance.collection('reviews');
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.caretLeft,
                    color: Colors.black,
                    size: 30,
                  ),
                  label: Text(
                    'Reviews',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ratingDialog(context);
                  },
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.plus,
                        color: Colors.black,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Add Review',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 250,
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        selectedSpot.firstSpot!.name,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: selectedSpot.firstSpot!.averageRating!,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 20,
                          itemPadding: EdgeInsets.zero,
                          onRatingUpdate: (rating) => setState(() {
                            this.rating = rating;
                          }),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                        Text(
                            '${selectedSpot.firstSpot!.averageRating!.toStringAsFixed(2)}/5')
                      ],
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllSpotReviews(),
                        ));
                  },
                  child: Row(
                    children: [
                      Text(
                        'See All',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      const FaIcon(
                        FontAwesomeIcons.chevronRight,
                        color: Colors.black,
                        size: 20,
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            const Divider(
              height: 20,
              thickness: 2,
              color: Color.fromRGBO(229, 229, 229, 1),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: Reviews.spotReviews(selectedSpot.firstSpot!.name, 10),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.hasData) {
                    final docs = (snapshot.data as QuerySnapshot).docs;

                    return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final data =
                              docs[index].data() as Map<String, dynamic>;

                          return Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 2,
                                  color: Color.fromRGBO(229, 229, 229, 1),
                                ),
                              ),
                            ),
                            height: 75,
                            // padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.pink,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        data['userPhoto'],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['user'],
                                      overflow: TextOverflow.fade,
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    RatingBar.builder(
                                      ignoreGestures: true,
                                      initialRating: data['rating'],
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 20,
                                      itemPadding: EdgeInsets.zero,
                                      onRatingUpdate: (rating) => setState(() {
                                        this.rating = rating;
                                      }),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    Text(
                                      data['review'],
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  }

                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> ratingDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        child: Container(
          height: 270,
          width: 400,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  'Add Reviews',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    child: Text(
                      'Rating:  ',
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  RatingBar.builder(
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 20,
                    itemPadding: EdgeInsets.zero,
                    itemBuilder: (context, _) => const Icon(Icons.star,
                        color: Color.fromRGBO(255, 239, 100, 1)),
                    onRatingUpdate: (rating) {},
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                child: Text(
                  'Comment:  ',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                // decoration: const BoxDecoration(
                //   border: Border(
                //       bottom: BorderSide(
                //     color: Colors.black,
                //     width: 3.0,
                //   )),
                // ),
                child: TextField(
                  // controller: reviewField,
                  decoration: InputDecoration(
                    hintText: 'Enter Comment',
                    hintStyle: GoogleFonts.inter(
                        color: Color.fromRGBO(212, 212, 212, 1)),
                    contentPadding: EdgeInsets.only(bottom: 30),
                  ),
                  onChanged: (value) {
                    // review = value;
                  },
                ),
              ),
              // TextButton(
              //     onPressed: () {
              //       // reviews.add({
              //       //   'review': review,
              //       //   'user': user!.displayName,
              //       //   'userPhoto': user.photoURL,
              //       //   'spot': selectedSpot.spot!.name,
              //       //   'rating': rating
              //       // }).catchError((error) =>
              //       //     debugPrint('Failed to add comment: $error'));

              //       // reviewField.clear();
              //     },
              //
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 150,
                  height: 40,
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
                    onPressed: () {
                      //            reviews.add({
                      // //       //   'review': review,
                      // //       //   'user': user!.displayName,
                      // //       //   'userPhoto': user.photoURL,
                      // //       //   'spot': selectedSpot.spot!.name,
                      // //       //   'rating': rating
                      // //       // }).catchError((error) =>
                      // //       //     debugPrint('Failed to add comment: $error'));

                      // //       // reviewField.clear();
                    },
                    child: Text('Submit',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
