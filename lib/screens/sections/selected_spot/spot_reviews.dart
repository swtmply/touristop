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

    // final size = MediaQuery.of(context).size;
    // ignore: todo
    // TODO add rating
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
                  FontAwesomeIcons.chevronLeft,
                  color: Colors.black,
                  size: 20,
                ),
                label: Text(
                  'Back',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Reviews',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
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
                        'user': user,
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
                stream: reviews.snapshots(),
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
                                // Container(
                                //   height: 60,
                                //   width: 60,
                                //   decoration: BoxDecoration(
                                //     shape: BoxShape.circle,
                                //     color: Colors.pink,
                                //     image: DecorationImage(
                                //       image: NetworkImage(
                                //         data['user'].photo.toString(),
                                //       ),
                                //     ),
                                //   ),
                                // ),
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
