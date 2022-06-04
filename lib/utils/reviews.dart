import 'package:cloud_firestore/cloud_firestore.dart';

class Reviews {
  static Future<double> reviewAverage(String spotName) async {
    final reviews = FirebaseFirestore.instance.collection('reviews');
    final spotReviews = await reviews
        .where(
          'spot',
          isEqualTo: spotName,
        )
        .get();

    double sum = 0;

    for (final doc in spotReviews.docs) {
      final data = doc.data();
      sum += data['rating'];
    }

    return sum / spotReviews.docs.length;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> spotReviews(
      String spotName, int limit) {
    final reviewsCollection = FirebaseFirestore.instance.collection('reviews');
    final reviews = reviewsCollection
        .where(
          'spot',
          isEqualTo: spotName,
        )
        .limit(limit)
        .get()
        .asStream();

    return reviews;
  }
}
