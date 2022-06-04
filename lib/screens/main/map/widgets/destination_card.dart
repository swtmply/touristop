import 'package:flutter/material.dart';
import 'package:flutter_dash_nullsafety/flutter_dash_nullsafety.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';
import 'package:touristop/theme/app_colors.dart';

class DestinationCard extends StatelessWidget {
  const DestinationCard({Key? key, this.selectedSpot}) : super(key: key);

  final TouristSpot? selectedSpot;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80.0,
      child: Container(
        height: 140,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: 50,
                child: Column(
                  children: const [
                    FaIcon(
                      FontAwesomeIcons.locationDot,
                      color: AppColors.coldBlue,
                      size: 30,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: Dash(
                        direction: Axis.vertical,
                        length: 30,
                        dashColor: Colors.grey,
                        dashBorderRadius: 20,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    FaIcon(
                      FontAwesomeIcons.streetView,
                      color: AppColors.slime,
                      size: 30,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Origin',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color.fromRGBO(130, 130, 130, 1),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Current Location',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: const Color.fromARGB(255, 10, 10, 10),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 2,
                      color: Color.fromRGBO(130, 130, 130, 1),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Destination',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color.fromRGBO(130, 130, 130, 1),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          selectedSpot?.name ?? 'No selected spot',
                          maxLines: 2,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: const Color.fromARGB(255, 10, 10, 10),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
