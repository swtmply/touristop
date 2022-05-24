import 'package:flutter/material.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';

class DistanceCard extends StatelessWidget {
  const DistanceCard({Key? key, this.selectedSpot}) : super(key: key);

  final TouristSpot? selectedSpot;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 220,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 50,
            child: Row(
              children: [
                Text('Distance:'),
                Text('${selectedSpot?.distanceFromUser?.toStringAsFixed(2)}km'),
              ],
            )),
      ),
    );
  }
}
