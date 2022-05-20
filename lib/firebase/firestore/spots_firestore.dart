import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touristop/models/tourist_spot_model.dart';

class SpotsFirestore {
  final CollectionReference _spots =
      FirebaseFirestore.instance.collection('spots');

  Stream<QuerySnapshot> get spotsStream => _spots.snapshots();

  Future<DocumentSnapshot> findSpotById(String id) => _spots.doc(id).get();

  Future<List<TouristSpot>> get spotList async {
    QuerySnapshot snapshot = await _spots.get();

    return snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      return TouristSpot(
        name: data['name'],
        description: data['description'],
        image: data['image'],
        distanceFromUser: 0,
        position: data['position'],
        dates: data['dates'],
        address: data['address'],
        fee: data['fee'],
      );
    }).toList();
  }
}
