import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:touristop/models/destination/destination_model.dart';
import 'package:touristop/models/schedule/selected_destination.dart';
import 'package:touristop/screens/destination_information/destination_reviews_screen.dart';
import 'package:touristop/screens/destination_information/widgets/destination_reviews.dart';
import 'package:touristop/screens/destination_information/widgets/review_input.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/theme/app_spacing.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DestinationInformation extends StatelessWidget {
  DestinationInformation(
      {Key? key, required this.destination, this.selectedDestination})
      : super(key: key);

  final Destination destination;
  final SelectedDestination? selectedDestination;
  final User? user = FirebaseAuth.instance.currentUser;

  speak() async {
    FlutterTts flutterTts = FlutterTts();

    await flutterTts.setPitch(1);
    await flutterTts.speak(destination.description);
  }

  // Future getimgfromFirebase() async {
  //   var firestore = FirebaseFirestore.instance;
  //   QuerySnapshot qn = await FirebaseFirestore.instance.collection('spots').getDocuments();
  //   return qn.documents;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
               Container(
                height: 300,
                  child: CarouselSlider.builder(
                            slideBuilder: (index){
                              final sliderimage = destination.images[index];
                              return Container(
                                child: Image.network(sliderimage,
                                fit: BoxFit.fill),
                              );
                            },
                            unlimitedMode: true,
                            autoSliderTransitionTime: const Duration(seconds: 3),
                            enableAutoSlider: true,
                            autoSliderDelay: const Duration(seconds: 3),
                            slideTransform: const CubeTransform(
                              rotationAngle: 4
                            ),
                            itemCount: destination.images.length,
                            ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: TextButton.icon(
                      label: const Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      icon: const FaIcon(
                        FontAwesomeIcons.chevronLeft,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: AppSpacing.base),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  RatingBarIndicator(
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: AppColors.star,
                    ),
                    unratedColor: AppColors.gray,
                    itemSize: 25,
                    rating: destination.rating!,
                  ),
                  const SizedBox(
                    height: AppSpacing.small,
                  ),
                  Row(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                          children: <TextSpan>[
                            const TextSpan(text: 'Open  '),
                            TextSpan(
                                text:
                                    '${destination.schedule.first.date}-${destination.schedule.last.date}  ',
                                style: const TextStyle(
                                  color: Color.fromRGBO(93, 107, 230, 1),
                                )),
                            const TextSpan(text: '\u2022  '),
                            TextSpan(
                                text: destination.schedule.first.timeOpen ==
                                        '6:00AM'
                                    ? 'Open 24 Hours'
                                    : '${destination.schedule.first.timeOpen} to ${destination.schedule.first.timeClose}',
                                style: const TextStyle(
                                  color: Color.fromRGBO(93, 230, 197, 1),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      children: <TextSpan>[
                        const TextSpan(text: 'Entrance Fee: '),
                        TextSpan(
                          text: destination.fee,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 18, 18, 18),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 20,
                    thickness: 2,
                    color: Colors.grey[300],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          'Address: ${destination.address}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 134, 134, 134),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () async {
                            await speak();
                          },
                          icon: const Icon(
                            Icons.spatial_audio_off,
                            color: AppColors.coldBlue,
                          ),
                          label: const Text(
                            'Speak',
                            style: TextStyle(
                              color: AppColors.coldBlue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSpacing.base,
                  ),
                  Text(
                    destination.description.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.small),
                  const Text(
                    'Guidelines to follow:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.small),
                  Text(
                    destination.guideline,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            SizedBox(
              width: double.infinity,
              height: 300,
              child: FutureBuilder<List<Destination>>(
                future: Destination.destinations(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballRotateChase,
                          colors: AppColors.cbToSlime,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error Fetching data'),
                    );
                  }

                  final data = snapshot.requireData;

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final fDestination = data[index];

                      if (fDestination.type == destination.type) {
                        return Container();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.base),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  fDestination.images.first,
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: AppSpacing.small,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Text(
                                fDestination.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: AppSpacing.small,
                            ),
                            RatingBarIndicator(
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: AppColors.star,
                              ),
                              unratedColor: AppColors.gray,
                              itemSize: 25,
                              rating: fDestination.rating!,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reviews:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AllSpotReviews(destination: destination),
                            ),
                          );
                        },
                        child: Row(
                          children: const [
                            Text(
                              'See All',
                              style: TextStyle(
                                color: AppColors.coldBlue,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            FaIcon(
                              FontAwesomeIcons.chevronRight,
                              color: AppColors.coldBlue,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.small),
                    child: Divider(
                      height: 20,
                      thickness: 2,
                      color: Colors.grey[300],
                    ),
                  ),
                  Visibility(
                    visible: selectedDestination?.isDone ?? false,
                    child: ReviewInput(
                      user: user,
                      selectedDestination: destination,
                    ),
                  ),
                  DestinationReviews(destination: destination)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
