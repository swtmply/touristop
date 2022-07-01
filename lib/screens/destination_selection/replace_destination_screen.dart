import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:touristop/models/destination/destination_model.dart';
import 'package:touristop/models/schedule/selected_destination.dart';
import 'package:touristop/screens/destination_information/destination_information.dart';
import 'package:touristop/screens/main_screen.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/theme/app_spacing.dart';

class ReplaceDestinationScreen extends StatefulWidget {
  final SelectedDestination selectedDestination;
  const ReplaceDestinationScreen({Key? key, required this.selectedDestination})
      : super(key: key);

  @override
  State<ReplaceDestinationScreen> createState() =>
      _ReplaceDestinationScreenState();
}

class _ReplaceDestinationScreenState extends State<ReplaceDestinationScreen> {
  List<Destination> _destinations = [];

  @override
  void initState() {
    super.initState();

    Destination.destinations().then((value) {
      setState(() {
        value.sort((a, b) => a.rating! < b.rating! ? 1 : 0);
        _destinations = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDestination = widget.selectedDestination;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.base),
                child: Text(
                  'Select Destination',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: AppSpacing.small,
              ),
              Expanded(
                child: _destinations.isEmpty
                    ? const Center(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballRotateChase,
                            colors: AppColors.cbToSlime,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _destinations.length,
                        itemBuilder: (context, index) {
                          if (_destinations[index].name ==
                              selectedDestination.destination.name) {
                            return Container();
                          }

                          return ReplaceDestinationListItem(
                            destination: _destinations[index],
                            selectedDestination: selectedDestination,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReplaceDestinationListItem extends StatefulWidget {
  const ReplaceDestinationListItem(
      {Key? key, required this.destination, required this.selectedDestination})
      : super(key: key);

  final Destination destination;
  final SelectedDestination selectedDestination;

  @override
  State<ReplaceDestinationListItem> createState() =>
      _ReplaceDestinationListItemState();
}

class _ReplaceDestinationListItemState
    extends State<ReplaceDestinationListItem> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DestinationInformation(destination: widget.destination),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.small),
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(93, 107, 230, 1),
                  Color.fromRGBO(93, 230, 197, 1),
                ],
              ),
              image: DecorationImage(
                image: NetworkImage(widget.destination.images.first),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 320,
                        child: Text(
                          widget.destination.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => _showWarning(),
                          );
                        },
                        child: const FaIcon(
                          FontAwesomeIcons.circleCheck,
                          size: 25,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: AppSpacing.small,
                  ),
                  RatingBarIndicator(
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Color.fromRGBO(255, 239, 100, 1),
                    ),
                    unratedColor: AppColors.gray,
                    itemSize: 25,
                    rating: widget.destination.rating!,
                  ),
                  const SizedBox(
                    height: AppSpacing.small,
                  ),
                  Text(
                    widget.destination.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _showWarning() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: SizedBox(
          height: 135,
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'The selected tourist spot will replace a tourist spot, are you sure you want to continue?'),
              Expanded(
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.slime,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      widget.selectedDestination.destination =
                          widget.destination;
                      widget.selectedDestination.save();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      backgroundColor: AppColors.coldBlue,
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
