import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:touristop/models/spots_list/spots_list_model.dart';
import 'package:touristop/providers/user_location.dart';

class FloatingCards extends ConsumerWidget {
  const FloatingCards({
    Key? key,
    required this.pageController,
    required this.spots,
    required this.onSpotSelect,
    required this.moveCamera,
    required this.createPolyline,
  }) : super(key: key);

  final PageController pageController;
  final List<SpotsList> spots;
  final Function onSpotSelect;
  final Function moveCamera;
  final Function createPolyline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLocation = ref.watch(userLocationProvider);

    return Positioned(
      bottom: 20.0,
      child: SizedBox(
        height: 200.0,
        width: MediaQuery.of(context).size.width,
        child: PageView.builder(
          controller: pageController,
          itemCount: spots.length,
          itemBuilder: (context, index) => AnimatedBuilder(
            animation: pageController,
            builder: (context, child) {
              double value = 1;
              if (pageController.position.haveDimensions) {
                value = pageController.page! - index;
                value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
              }

              return Center(
                child: SizedBox(
                  height: Curves.easeInOut.transform(value) * 130.0,
                  width: Curves.easeInOut.transform(value) * 350.0,
                  child: child,
                ),
              );
            },
            child: InkWell(
              onTap: () {
                onSpotSelect(spots[index].spot);
                final position = LatLng(
                  spots[index].spot.position!.latitude,
                  spots[index].spot.position!.longitude,
                );
                createPolyline(
                  LatLng(
                    userLocation.position?.latitude ?? 14.5995,
                    userLocation.position?.longitude ?? 120.9842,
                  ),
                  LatLng(
                    spots[index].spot.position!.latitude,
                    spots[index].spot.position!.longitude,
                  ),
                );

                moveCamera(position);
              },
              child: Container(
                height: 150,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Container(
                        height: 110,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              image: NetworkImage(
                                spots[index].spot.image,
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
                            Text(
                              spots[index].spot.name,
                              maxLines: 3,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            RatingBar.builder(
                              unratedColor:
                                  const Color.fromARGB(255, 210, 210, 210),
                              initialRating: spots[index].spot.averageRating!,
                              ignoreGestures: true,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20,
                              itemPadding: EdgeInsets.zero,
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
