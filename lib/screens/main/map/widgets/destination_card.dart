import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dash_nullsafety/flutter_dash_nullsafety.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:touristop/models/covid_summary.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:http/http.dart' as http;

class DestinationCard extends StatelessWidget {
  const DestinationCard({Key? key, this.selectedSpot}) : super(key: key);

  final TouristSpot? selectedSpot;

  Future<Summary> fetchCovidSummary() async {
    final response = await http.get(
      Uri.parse(
          'https://covid19-api-philippines.herokuapp.com/api/summary?city_mun=city+of+manila'),
    );

    if (response.statusCode == 200) {
      inspect(jsonDecode(response.body));
      return Summary.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load summary');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80.0,
      child: Column(
        children: [
          Container(
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
          const SizedBox(height: 10),
          FutureBuilder<Summary>(
            future: fetchCovidSummary(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  calculateByCases(snapshot.data!.activeCases),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: snapshot.data!.activeCases > 20000
                        ? Colors.red[500]
                        : snapshot.data!.activeCases > 5000
                            ? Colors.amber
                            : Colors.green,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  String calculateByCases(int activeCases) {
    String format = 'Covid Risk Level:';

    if (activeCases > 40000) {
      return "$format VERY HIGH";
    } else if (activeCases > 20000) {
      return "$format HIGH";
    } else if (activeCases > 5000) {
      return "$format MEDIUM";
    } else if (activeCases > 500) {
      return "$format LOW";
    } else {
      return "$format VERY LOW";
    }
  }
}
