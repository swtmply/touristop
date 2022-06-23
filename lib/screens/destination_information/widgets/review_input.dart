import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:touristop/models/destination/destination_model.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/theme/app_spacing.dart';

class ReviewInput extends StatefulWidget {
  const ReviewInput({
    Key? key,
    required this.user,
    required this.selectedDestination,
  }) : super(key: key);

  final User? user;
  final Destination selectedDestination;

  @override
  State<ReviewInput> createState() => _ReviewInputState();
}

class _ReviewInputState extends State<ReviewInput> {
  double rating = 0;
  String comment = '';
  final reviewField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.pink,
            image: widget.user?.photoURL != null
                ? DecorationImage(
                    image: NetworkImage(
                      widget.user!.photoURL!,
                    ),
                  )
                : null,
            gradient: const LinearGradient(
              colors: AppColors.cbToSlime,
            ),
          ),
        ),
        const SizedBox(
          width: AppSpacing.small,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(widget.user?.displayName ?? 'Guest User'),
            RatingBar.builder(
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemSize: 20,
              itemPadding: EdgeInsets.zero,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: AppColors.star,
              ),
              onRatingUpdate: (rating) {
                this.rating = rating;
              },
            ),
            Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.large),
              width: 250,
              child: TextField(
                controller: reviewField,
                decoration: const InputDecoration(
                  hintText: 'Enter Comment',
                  hintStyle: TextStyle(color: Color.fromRGBO(212, 212, 212, 1)),
                ),
                onChanged: (value) {
                  comment = value;
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          width: AppSpacing.small,
        ),
        InkWell(
          onTap: () {
            Destination.addReview(
              widget.selectedDestination.id,
              Review(
                comment,
                rating,
                widget.user?.displayName! ?? "Guest User",
                widget.user?.photoURL,
              ),
            );
            reviewField.clear();
          },
          child: const FaIcon(
            FontAwesomeIcons.paperPlane,
          ),
        )
      ],
    );
  }
}
