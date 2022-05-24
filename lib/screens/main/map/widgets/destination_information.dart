import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touristop/main.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';

class DestinationInformation extends ConsumerWidget {
  const DestinationInformation(
      {Key? key, this.selectedSpot, required this.onClose})
      : super(key: key);

  final TouristSpot? selectedSpot;
  final Function onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spot = ref.watch(selectedSpotProvider);

    return Positioned(
      bottom: 0,
      child: SizedBox(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: Container(
          color: Colors.white,
          // child: Row(
          //   children: [
          //     Text(selectedSpot?.name ?? "No selected spot"),
          //     TextButton(
          //       onPressed: () => onClose(),
          //       child: Icon(Icons.close),
          //     ),
          //   ],
          // ),
          padding: EdgeInsets.symmetric(horizontal: 10),

          child: Row(
            children: [
              Container(
                height: 150,
                width: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                      image: NetworkImage(
                        selectedSpot!.image,
                      ),
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedSpot!.name,
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () => onClose(),
                            child: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Text(
                        selectedSpot!.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    RatingBar.builder(
                      initialRating: 5,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20,
                      itemPadding: EdgeInsets.zero,
                      itemBuilder: (context, _) => const Icon(Icons.star,
                          color: Color.fromRGBO(255, 239, 100, 1)),
                      onRatingUpdate: (rating) {
                        inspect(rating);
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 180,
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
                        style: TextButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () {
                          spot.setSelectedSpot(selectedSpot!);
                          Navigator.pushNamed(context, '/selected/spot');
                        },
                        child: Text('Read more..',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
