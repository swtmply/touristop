import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:touristop/models/destination/destination_schedule.dart';
import 'package:touristop/models/destination/destination_position.dart';
import 'package:touristop/models/schedule/selected_destination.dart';
import 'package:touristop/utils/boxes.dart';

part 'destination_model.g.dart';

@HiveType(typeId: 0)
class Destination extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  late String description;
  @HiveField(2)
  late String address;
  @HiveField(3)
  late String fee;
  @HiveField(4)
  late String guideline;
  @HiveField(5)
  late String type;
  @HiveField(6)
  late double numberOfHours;
  @HiveField(7)
  late List<String> images;
  @HiveField(8)
  late DestinationPosition position;
  @HiveField(9)
  late List<DestinationSchedule> schedule;
  @HiveField(10)
  late double? rating;
  @HiveField(11)
  late double? distance;
  @HiveField(12)
  late String id;

  Destination({
    required this.name,
    required this.description,
    required this.address,
    required this.fee,
    required this.guideline,
    required this.type,
    required this.numberOfHours,
    required this.images,
    required this.position,
    required this.schedule,
    this.rating,
    this.distance,
    required this.id,
  });

  static Future<List<Destination>> destinations() async {
    return FirebaseFirestore.instance.collection('spots').snapshots().asyncMap(
      (snapshot) async {
        final docs = snapshot.docs;
        final List<Destination> destinations = [];

        for (var doc in docs) {
          destinations.add(await Destination.fromDocument(doc));
        }

        return destinations;
      },
    ).first;
  }

  static Future<void> setBundlebyDate(
      DateTime date, List<String> bundles) async {
    final collection = FirebaseFirestore.instance.collection('bundles');
    final selectedDestinationsBox =
        Hive.box<SelectedDestination>(Boxes.selectedDestinations);
    final day = DateFormat.E().format(date);
    final bundleSnapshot =
        await collection.where('dates', arrayContains: day).get();

    if (bundleSnapshot.docs.isNotEmpty) {
      final bundlesFromDB = bundleSnapshot.docs.map((e) => e.data()).toList();
      final length = bundles.length;

      while (bundles.length == length) {
        final index = Random();
        final bundle = bundlesFromDB[index.nextInt(bundlesFromDB.length)];

        if (!bundles.contains(bundle['name'])) {
          final destinations = List.from(bundle['spots']);

          for (var destinationName in destinations) {
            final destination = await getSpotByName(destinationName);

            final selectedDestination = SelectedDestination(
              dateSelected: date,
              destination: destination,
              isDone: false,
            );

            selectedDestinationsBox.put(
              selectedDestinationsBox.values.length,
              selectedDestination,
            );
          }
          bundles.add(bundle['name']);
        }
      }
    }
  }

  static Future<Destination> getSpotByName(String name) async {
    final collection = FirebaseFirestore.instance.collection('spots');
    final spots = await collection.where('name', isEqualTo: name).get();
    final spot = spots.docs.first;

    return Destination.fromDocument(spot);
  }

  static Stream<List<Review>> getReviews(String docId) {
    return FirebaseFirestore.instance
        .collection('spots')
        .doc(docId)
        .collection('spots')
        .snapshots()
        .map((snapshot) {
      final futures = snapshot.docs.map(
        (doc) => Review(
          doc['comment'],
          doc['rating'],
          doc['user'],
          doc['userPhoto'],
        ),
      );
      return futures.toList();
    });
  }

  static void addReview(String docId, Review review) async {
    final destinations = FirebaseFirestore.instance.collection('spots');
    final reviews = FirebaseFirestore.instance.collection('reviews');

    final result = await reviews.add({
      'comment': review.comment,
      'rating': review.rating,
      'user': review.user,
      'userPhoto': review.userPhoto
    });

    destinations.doc(docId).collection('reviews').add({
      'id': result.id,
      'comment': review.comment,
      'rating': review.rating,
      'user': review.user,
      'userPhoto': review.userPhoto,
      'created_at': DateTime.now(),
    });
  }

  static Future<double> averageRating(String docId) async {
    final destinations = FirebaseFirestore.instance.collection('spots');
    final reviews = await destinations.doc(docId).collection('reviews').get();
    final docs = reviews.docs;

    if (docs.isNotEmpty) {
      final ratings = docs.map((e) => e.data()['rating']);
      final totalRating = ratings.reduce((value, element) => value + element);

      return totalRating / docs.length;
    }

    return 0;
  }

  static void toggleDoneHistory(
      SelectedDestination destination, User? user) async {
    final userDocument =
        FirebaseFirestore.instance.collection('users').doc(user?.uid);

    if (destination.isDone) {
      await userDocument.collection('spots').add({
        'name': destination.destination.name,
        'image': destination.destination.images.first,
        'date': destination.dateSelected,
      });
    }
  }

  static Future<Destination> fromDocument(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) async {
    final data = snapshot.data();

    final schedule = List.from(data['dates']).map((schedule) {
      return DestinationSchedule(
        date: schedule['date'],
        timeOpen: schedule['timeOpen'],
        timeClose: schedule['timeClose'],
      );
    });

    final position = DestinationPosition(
      latitude: data['position'].latitude,
      longitude: data['position'].longitude,
    );

    final destination = Destination(
      id: snapshot.id,
      address: data['address'],
      description: data['description'],
      fee: data['fee'],
      guideline: data['guideline'],
      name: data['name'],
      numberOfHours: data['numberOfHours'].toDouble(),
      position: position,
      type: data['type'],
      schedule: schedule.toList(),
      images: List.from(data['image']),
      rating: await averageRating(snapshot.id),
    );

    return destination;
  }
}

class Review {
  String comment;
  double rating;
  String user;
  String? userPhoto;

  Review(this.comment, this.rating, this.user, this.userPhoto);
}
