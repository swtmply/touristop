import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dash_nullsafety/flutter_dash_nullsafety.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:touristop/models/covid_summary.dart';
import 'package:touristop/models/destination/destination_model.dart';
import 'package:touristop/models/distance.dart';
import 'package:touristop/screens/destination_information/destination_information.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:touristop/theme/app_spacing.dart';

class SelectedDestinationCard extends StatefulWidget {
  const SelectedDestinationCard({
    Key? key,
    required this.destination,
    required this.onClose,
    required this.userPosition,
    required this.mode,
    required this.setMode,
    required this.onModeChange,
  }) : super(key: key);

  final Destination? destination;
  final Function onClose;
  final LatLng userPosition;
  final Function onModeChange;
  final String mode;
  final Function setMode;

  @override
  State<SelectedDestinationCard> createState() =>
      _SelectedDestinationCardState();
}

class _SelectedDestinationCardState extends State<SelectedDestinationCard> {
  Future<Distance> fetchDistance(LatLng destination, String mode) async {
    final url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${widget.userPosition.latitude},${widget.userPosition.longitude}&destinations=${destination.latitude},${destination.longitude}&mode=$mode&key=AIzaSyAjMSWhlbBDUTmEjl3sdBLFdTA6x0LbCCs';

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      return Distance.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Distance');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 80.0,
          child: Column(
            children: [
              Container(
                height: 140,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  padding:
                      const EdgeInsets.only(right: 20, top: 10, bottom: 10),
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
                        width: AppSpacing.small,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Origin',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(130, 130, 130, 1),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'Current Location',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 10, 10, 10),
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
                                const Text(
                                  'Destination',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(130, 130, 130, 1),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  widget.destination!.name,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 10, 10, 10),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: AppSpacing.small,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.darkGray,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  widget.setMode('driving');
                                  widget.onModeChange('driving');
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.car,
                                  size: 16,
                                  color: widget.mode == 'driving'
                                      ? AppColors.slime
                                      : Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.darkGray,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  widget.setMode('walking');
                                  widget.onModeChange('walking');
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.personWalking,
                                  size: 16,
                                  color: widget.mode == 'walking'
                                      ? AppColors.slime
                                      : Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.darkGray,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  widget.setMode('transit');
                                  widget.onModeChange('transit');
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.trainSubway,
                                  size: 16,
                                  color: widget.mode == 'transit'
                                      ? AppColors.slime
                                      : Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder<CovidSummary>(
                future: CovidSummary.fetchCovidSummary(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      calculateByCases(snapshot.data!.deaths),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: snapshot.data!.deaths > 20000
                            ? Colors.red[500]
                            : snapshot.data!.deaths > 5000
                                ? Colors.amber[700]
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
        ),
        Positioned(
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
              child: FutureBuilder(
                future: fetchDistance(
                  LatLng(
                    widget.destination!.position.latitude,
                    widget.destination!.position.longitude,
                  ),
                  widget.mode,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Distance:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${(snapshot.data as Distance).meter}km',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const Text(
                        'Time Remaining:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        (snapshot.data as Distance).time,
                        style: const TextStyle(
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          widget.destination!.images.first,
                        ),
                        fit: BoxFit.cover,
                      ),
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
                                widget.destination!.name,
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                onPressed: () => widget.onClose(),
                                child: const Icon(Icons.close),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.destination!.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
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
                          rating: widget.destination!.rating!,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DestinationInformation(
                                    destination: widget.destination!,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Read more..',
                                style: TextStyle(
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
        ),
      ],
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
