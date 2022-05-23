import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:touristop/models/spot_box/spot_box_model.dart';

class FloatingCards extends ConsumerWidget {
  const FloatingCards(
      {Key? key, required this.pageController, required this.spots})
      : super(key: key);

  final PageController pageController;
  final List<SpotBox> spots;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: 150,
                width: 300,
                color: Colors.white,
                child: Text(spots[index].spot.name),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
