import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:touristop/models/destination/destination_model.dart';
import 'package:touristop/theme/app_colors.dart';

class FloatingDestinationCards extends StatefulWidget {
  final Function onDestinationSelect;
  final Function createPolyline;
  final Function moveCamera;
  final List<Destination> destinations;
  final LatLng userPosition;
  const FloatingDestinationCards({
    Key? key,
    required this.createPolyline,
    required this.moveCamera,
    required this.destinations,
    required this.onDestinationSelect,
    required this.userPosition,
  }) : super(key: key);

  @override
  State<FloatingDestinationCards> createState() =>
      _FloatingDestinationCardsState();
}

class _FloatingDestinationCardsState extends State<FloatingDestinationCards> {
  late PageController _pageController;
  int prevPage = -1;
  List<Destination> _destinations = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8)
      ..addListener(_onScroll);
    _destinations = widget.destinations;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20.0,
      child: SizedBox(
        height: 200.0,
        width: MediaQuery.of(context).size.width,
        child: PageView.builder(
          controller: _pageController,
          itemCount: _destinations.length,
          itemBuilder: (context, index) => AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 1;
              if (_pageController.position.haveDimensions) {
                value = _pageController.page! - index;
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
                widget.onDestinationSelect(_destinations[index]);
                final position = LatLng(
                  _destinations[index].position.latitude,
                  _destinations[index].position.longitude,
                );

                widget.createPolyline(
                  widget.userPosition,
                  LatLng(
                    _destinations[index].position.latitude,
                    _destinations[index].position.longitude,
                  ),
                );

                widget.moveCamera(position);
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
                                _destinations[index].images.first,
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
                              _destinations[index].name,
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            RatingBarIndicator(
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: AppColors.star,
                              ),
                              unratedColor: AppColors.gray,
                              itemSize: 25,
                              rating: _destinations[index].rating!,
                            ),
                            const SizedBox(height: 5),
                            Container(
                              width: 150,
                              height: 30,
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.slime,
                                    AppColors.coldBlue,
                                  ],
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Directions',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
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

  void _onScroll() {
    if (_pageController.page?.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
      LatLng position = LatLng(
        _destinations[_pageController.page?.toInt() as int].position.latitude,
        _destinations[_pageController.page?.toInt() as int].position.longitude,
      );
      widget.moveCamera(position);
    }
  }
}
