import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:touristop/models/destination/destination_model.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/theme/app_spacing.dart';

class DestinationReviews extends StatefulWidget {
  const DestinationReviews({
    Key? key,
    required this.destination,
  }) : super(key: key);

  final Destination destination;

  @override
  State<DestinationReviews> createState() => _DestinationReviewsState();
}

class _DestinationReviewsState extends State<DestinationReviews> {
  final spotsRef = FirebaseFirestore.instance.collection('spots');

  Stream<List<Map<String, dynamic>>> _initReviews() {
    final snapshot =
        spotsRef.doc(widget.destination.id).collection('reviews').snapshots();
    final docs = snapshot.map((event) => event.docs);
    final reviews = docs.map(
      (event) => event.map((e) => e.data()).toList(),
    );
    return reviews;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _initReviews(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballRotateChase,
                  colors: AppColors.cbToSlime,
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          }

          final data = snapshot.requireData;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final review = Review(
                data[index]['comment'],
                data[index]['rating'].toDouble(),
                data[index]['user'] ?? "Guest User",
                data[index]['userPhoto'],
              );

              return Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.gray,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: AppColors.cbToSlime,
                        ),
                        image: review.userPhoto != null
                            ? DecorationImage(
                                image: NetworkImage(
                                  review.userPhoto!,
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.small),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review.user,
                        ),
                        RatingBarIndicator(
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: AppColors.star,
                          ),
                          unratedColor: AppColors.gray,
                          itemSize: 15,
                          rating: review.rating,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(review.comment),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
