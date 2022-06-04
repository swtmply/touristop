import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touristop/providers/selected_spots.dart';
import 'package:touristop/theme/app_colors.dart';

class AllSpotReviews extends ConsumerStatefulWidget {
  const AllSpotReviews({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllSpotReviewsState();
}

class _AllSpotReviewsState extends ConsumerState<AllSpotReviews> {
  int selectedStars = 5;

  @override
  Widget build(BuildContext context) {
    final selectedSpot = ref.watch(selectedSpotsProvider);
    final reviews = FirebaseFirestore.instance.collection('reviews');

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.caretLeft,
                      size: 25,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'All Reviews',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 30,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (int i = 5; i >= 0; i--)
                        StarBuilder(
                          count: i,
                          selected: i == selectedStars,
                          onTap: (value) {
                            setState(() {
                              selectedStars = value;
                            });
                          },
                        )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: reviews
                      .where('spot', isEqualTo: selectedSpot.firstSpot!.name)
                      .get()
                      .asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text(
                          'Something went wrong in the stream provided');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }

                    final docs = snapshot.requireData.docs.where((element) {
                      final data = element.data() as Map<String, dynamic>;
                      if (data['rating'] == selectedStars) return true;

                      return false;
                    }).toList();

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;

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
                                    unratedColor:
                                        const Color.fromRGBO(230, 230, 230, 1),
                                    ignoreGestures: true,
                                    initialRating: data['rating'],
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 20,
                                    itemPadding: EdgeInsets.zero,
                                    onRatingUpdate: (rating) => setState(() {
                                      // this.rating = rating;
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
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class StarBuilder extends StatelessWidget {
  const StarBuilder({
    Key? key,
    required this.count,
    required this.onTap,
    required this.selected,
  }) : super(key: key);

  final int count;
  final Function onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(count);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: (25 * count).toDouble(),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: selected
                ? [AppColors.coldBlue, AppColors.slime]
                : [Colors.white, Colors.white],
          ),
          border: Border.all(
            color: selected ? Colors.transparent : Colors.black,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < count; i++)
              const Icon(
                Icons.star,
                color: Colors.amber,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}