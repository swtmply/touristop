import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:touristop/firebase/firestore/spots_firestore.dart';
import 'package:touristop/models/tourist_spot_model.dart';

class FirestoreTestScreen extends StatefulWidget {
  const FirestoreTestScreen({Key? key}) : super(key: key);

  @override
  State<FirestoreTestScreen> createState() => _FirestoreTestScreenState();
}

class _FirestoreTestScreenState extends State<FirestoreTestScreen> {
  final _spotsFirestore = SpotsFirestore();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: StreamBuilder(
        stream: _spotsFirestore.spotsStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) return const Text('Something went wrong! :(');

          List<QueryDocumentSnapshot> spots = snapshot.data!.docs;

          return ListView.builder(
            itemCount: spots.length,
            itemBuilder: (context, index) {
              TouristSpot spot = TouristSpot(
                  name: spots[index]['name'],
                  description: spots[index]['description'],
                  image: spots[index]['image'],
                  distanceFromUser: 0,
                  position: spots[index]['position'],
                  dates: spots[index]['dates']);

              return Text(spot.name.toString());
            },
          );
        },
      ),
    );
  }
}
