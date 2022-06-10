import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:touristop/models/spots_list/spots_list_model.dart';
import 'package:touristop/providers/selected_bundle.dart';
import 'package:touristop/providers/user_location.dart';
import 'package:touristop/utils/convert_to.dart';
import 'package:touristop/utils/reviews.dart';

class Bundles {
  static Future<Map<String, dynamic>> getBundleByDate(
      DateTime date,
      SelectedBundleProvider bundleProvider,
      UserLocationProvider userPosition) async {
    final spotsBox = Hive.box<SpotsList>('spots');
    final day = DateFormat.E().format(date);
    final collection = FirebaseFirestore.instance.collection('bundles');
    final bundlesSnapshot = await collection
        .where(
          'dates',
          arrayContains: day,
        )
        .get();

    if (bundlesSnapshot.docs.isNotEmpty) {
      final bundles = bundlesSnapshot.docs.map((e) => e.data()).toList();
      final length = bundleProvider.selectedSpots.length;

      while (bundleProvider.selectedSpots.length == length) {
        final index = Random();
        final bundle = bundles[index.nextInt(bundles.length)];
        final spots = List<String>.from(bundle['spots']);

        // if (spots
        //     .toSet()
        //     .intersection(bundleProvider.selectedSpots.toSet())
        //     .isEmpty) {
        bundleProvider.addSpots(spots);

        final spotList = await Future.wait(spots.map((name) async {
          final document = await getSpotByName(name);

          debugPrint(bundle['name']);

          return ConvertTo.touristSpot(document, userPosition.position!);
        }).toList());

        for (var spot in spotList) {
          spot.averageRating = await Reviews.reviewAverage(spot.name);
          final spotItem = SpotsList(
            spot: spot,
            date: date,
            isDone: false,
          );
          String boxKey = '$date${spot.name}';

          spotsBox.put(boxKey, spotItem);
        }
        // }
      }
    }

    return {};
  }

  static Future<List<Map<String, dynamic>>> getBundleWithSpots(
      String bundleName, List<String> spots) async {
    // return tourist spots
    final bundle = await Future.wait(spots.map((e) async {
      return {
        'name': bundleName,
        'spots': await Future.wait(
            spots.map((name) async => await getSpotByName(name))),
      };
    }).toList());

    return bundle;
  }

  static Future<Map<String, dynamic>> getSpotByName(String name) async {
    final collection = FirebaseFirestore.instance.collection('spots');
    final spots = await collection.where('name', isEqualTo: name).get();

    if (spots.docs.isNotEmpty) {
      final spot = spots.docs.first;
      return spot.data();
    }

    return {};
  }
}
