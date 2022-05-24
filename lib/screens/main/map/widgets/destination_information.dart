import 'package:flutter/material.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';

class DestinationInformation extends StatelessWidget {
  const DestinationInformation(
      {Key? key, this.selectedSpot, required this.onClose})
      : super(key: key);

  final TouristSpot? selectedSpot;
  final Function onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: SizedBox(
        height: 180,
        width: MediaQuery.of(context).size.width,
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              Text(selectedSpot?.name ?? "No selected spot"),
              TextButton(
                onPressed: () => onClose(),
                child: Icon(Icons.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
