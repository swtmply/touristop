import 'package:flutter/material.dart';
import 'package:flutter_dash_nullsafety/flutter_dash_nullsafety.dart';
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
        height: 120,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Container(
          padding: const EdgeInsets.only(right: 20),
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
                    Icon(
                      Icons.location_pin,
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
                    Icon(
                      Icons.location_pin,
                      color: AppColors.coldBlue,
                      size: 30,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Origin'),
                    const Text('Current Location'),
                    const Divider(),
                    const Text('Destination'),
                    Text(selectedSpot?.name ?? 'No selected spot'),
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
