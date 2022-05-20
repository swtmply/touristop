import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:touristop/main.dart';

class SpotReviewsScreen extends ConsumerStatefulWidget {
  const SpotReviewsScreen({Key? key}) : super(key: key);

  @override
  SpotReviewsScreenState createState() => SpotReviewsScreenState();
}

class SpotReviewsScreenState extends ConsumerState<SpotReviewsScreen> {
  var comment = "";

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(spotsProvider);
    CollectionReference reviews =
        FirebaseFirestore.instance.collection('reviews');

    final spotReviews =
        reviews.where('spot', isEqualTo: selected.spot!.name).get();
    Size size = MediaQuery.of(context).size;
    final fbAuth = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () async {},
              label: Text(
                'Back',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              icon: const FaIcon(
                FontAwesomeIcons.chevronLeft,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Reviews',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            child: const Divider(
              height: 20,
              thickness: 2,
              color: Color.fromRGBO(229, 229, 229, 1),
            ),
          ),
          const SizedBox(height: 5),
          Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromRGBO(199, 199, 199, 1),
                    width: 1.5,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Add a rewiew to this place.',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: () {
                      reviews.add({
                        'comment': comment,
                        'user': fbAuth.user!.uid,
                        'spot': selected.spot!.name
                      }).catchError(
                          (error) => print('Failed to add comment: $error'));
                    },
                    icon: const Icon(Icons.send,
                        color: const Color.fromRGBO(199, 199, 199, 1)),
                  ),
                ),
                onChanged: (value) {
                  comment = value;
                },
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Add a rewiew to this place.';
                //   }
                //   return null;
                // },
              )),
          const SizedBox(height: 20),
          FutureBuilder(
            future: spotReviews,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator.adaptive();
              }

              final data = snapshot.data as QuerySnapshot;
              final docs = data.docs;

              return Column(
                  children: docs.map((doc) {
                return Text(doc['comment']);
              }).toList());
            },
          ),
          // Container(
          //   decoration: const BoxDecoration(
          //     border: Border(
          //         bottom: BorderSide(
          //             width: 2, color: Color.fromRGBO(229, 229, 229, 1))),
          //   ),
          //   height: 100,
          //   child: Container(
          //     child: Row(children: [
          //       Container(
          //         width: size.width * 0.25,
          //         padding: const EdgeInsets.symmetric(vertical: 10),
          //         child: const CircleAvatar(
          //           backgroundImage: AssetImage(
          //             'assets/images/image.png',
          //           ),
          //           radius: 50,
          //         ),
          //       ),
          //       Container(
          //         width: size.width * 0.65,
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Container(
          //               padding: const EdgeInsets.only(top: 20, bottom: 5),
          //               child: Text(
          //                 'Clea Payra',
          //                 style: GoogleFonts.inter(
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.w800,
          //                 ),
          //               ),
          //             ),
          //             Container(
          //               child: Text(
          //                 'Ang ganda ganda ko talaga bossking HAHAHAHAHAHA cute mo naman sis xD',
          //                 style: GoogleFonts.inter(
          //                   fontSize: 14,
          //                   color: const Color.fromRGBO(91, 91, 91, 1),
          //                   fontWeight: FontWeight.normal,
          //                 ),
          //               ),
          //             )
          //           ],
          //         ),
          //       )
          //     ]),
          //   ),
          // ),
          TextButton(
            onPressed: () {
              fbAuth.googleLogout();
            },
            child: Text('Logout'),
          ),
        ]),
      ),
    );
  }
}
