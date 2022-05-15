import 'package:flutter/material.dart';
import 'package:touristop/models/tourist_spot_model.dart';

class FloatingCards extends StatelessWidget {
  const FloatingCards(
      {Key? key, required this.pageController, required this.spots})
      : super(key: key);

  final PageController pageController;
  final List<TouristSpot> spots;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20.0,
      child: SizedBox(
        height: 200.0,
        width: MediaQuery.of(context).size.width,
        child: PageView.builder(
          controller: pageController,
          itemCount: spots.length,
          itemBuilder: (context, index) =>
              _spotsList(index, spots[index], pageController),
        ),
      ),
    );
  }
}

_spotsList(int index, TouristSpot spot, PageController pageController) {
  return AnimatedBuilder(
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
        // _createPolylines(userPosition, destination);
        // _animateToSpot(position);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        height: 150.0,
        width: 300.0,
        color: Colors.white,
        // ignore: todo
        // TODO floating card component
        child: Text(spot.name.toString()),
      ),
    ),
  );
}
