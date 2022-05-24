import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Distance:',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
                Text('${selectedSpot?.distanceFromUser?.toStringAsFixed(2)}km',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                    )),
                Text('Time Remaining:',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )),
                Text('16m',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                    )),
              ],
            )),
      ),
    );
  }
}
