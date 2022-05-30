import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touristop/main.dart';
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
    final selectedSpot = ref.watch(selectedSpotProvider);
    final reviews = FirebaseFirestore.instance.collection('reviews');
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const FaIcon(
                  FontAwesomeIcons.arrowLeft,
                  color: Colors.black,
                  size: 20,
                ),
                label: Text(
                  'Reviews',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Tourist Spot Ratings',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: selectedSpot.spot!.averageRating!,
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
                        Text('${selectedSpot.spot!.averageRating!}/5')
                      ],
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
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
                      const FaIcon(
                        FontAwesomeIcons.arrowRight,
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
            const SizedBox(height: 10),
            RatingBar.builder(
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 20,
              itemPadding: EdgeInsets.zero,
              itemBuilder: (context, _) => const Icon(Icons.star,
                  color: Color.fromRGBO(255, 239, 100, 1)),
              onRatingUpdate: (rating) => setState(() {
                this.rating = rating;
              }),
            ),
            Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromRGBO(199, 199, 199, 1),
                    width: 1.5,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: reviewField,
                decoration: InputDecoration(
                  hintText: 'Add a review to this place.',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: () {
                      reviews.add({
                        'review': review,
                        'user': user!.displayName,
                        'userPhoto': user.photoURL,
                        'spot': selectedSpot.spot!.name,
                        'rating': rating
                      }).catchError((error) =>
                          debugPrint('Failed to add comment: $error'));

                      reviewField.clear();
                    },
                    icon: const Icon(Icons.send,
                        color: Color.fromRGBO(199, 199, 199, 1)),
                  ),
                ),
                onChanged: (value) {
                  review = value;
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: Reviews.spotReviews(selectedSpot.spot!.name),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.hasData) {
                    final docs = (snapshot.data as QuerySnapshot).docs;

                    return ListView.builder(
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

                  return const CircularProgressIndicator.adaptive();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
