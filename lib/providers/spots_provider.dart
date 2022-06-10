import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';
import 'package:touristop/utils/convert_to.dart';
import 'package:touristop/utils/reviews.dart';

class SpotsProvider extends ChangeNotifier {
  List<TouristSpot> _spots = [];

  List<TouristSpot> get spots => _spots;

  void addAll(List<TouristSpot> spots) {
    _spots = spots;
    notifyListeners();
  }

  Future init(Position userPosition) async {
    final spots = FirebaseFirestore.instance.collection('spots');

    QuerySnapshot snapshot = await spots.get();
    final docs = snapshot.docs.map((e) => e).toList();

    _spots = await docsToTouristSpotList(docs, userPosition);
  }

  Future<List<TouristSpot>> docsToTouristSpotList(
    List<QueryDocumentSnapshot<Object?>> docs,
    Position userPosition,
  ) async {
    List<TouristSpot> touristSpots = docs
        .map((doc) => ConvertTo.touristSpot(
            doc.data() as Map<String, dynamic>, userPosition))
        .toList();

    for (TouristSpot spot in touristSpots) {
      double rating = await Reviews.reviewAverage(spot.name);

      spot.averageRating = rating.isNaN ? 0 : rating;
    }

    return touristSpots;
  }
}

final spotsProvider =
    ChangeNotifierProvider<SpotsProvider>((ref) => SpotsProvider());
