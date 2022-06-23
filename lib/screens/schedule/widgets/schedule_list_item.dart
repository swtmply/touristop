import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:touristop/models/destination/destination_model.dart';
import 'package:touristop/models/schedule/selected_destination.dart';
import 'package:touristop/screens/destination_information/destination_information.dart';
import 'package:touristop/screens/destination_selection/replace_destination_screen.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/theme/app_spacing.dart';
import 'package:touristop/utils/boxes.dart';

class ScheduleListItem extends ConsumerStatefulWidget {
  final SelectedDestination selectedDestination;
  final bool isEditing;
  const ScheduleListItem(
      {Key? key, required this.selectedDestination, required this.isEditing})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScheduleListItemState();
}

class _ScheduleListItemState extends ConsumerState<ScheduleListItem> {
  final selectedDestinationsBox =
      Hive.box<SelectedDestination>(Boxes.selectedDestinations);
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final selectedDestination = widget.selectedDestination;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DestinationInformation(
              destination: selectedDestination.destination,
              selectedDestination: selectedDestination,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.small),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.45,
            children: [
              SlidableAction(
                onPressed: (context) {
                  selectedDestination.isDone = !selectedDestination.isDone;
                  Destination.toggleDoneHistory(selectedDestination, user);

                  if (mounted) {
                    setState(() {});
                  }
                },
                backgroundColor: const Color.fromRGBO(93, 230, 197, 1),
                foregroundColor: Colors.white,
                icon: Icons.check_circle_outline,
                label: selectedDestination.isDone ? 'Undone' : 'Done',
              ),
              SlidableAction(
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReplaceDestinationScreen(
                        selectedDestination: selectedDestination,
                      ),
                    ),
                  );
                },
                backgroundColor: AppColors.coldBlue,
                foregroundColor: Colors.white,
                icon: Icons.shuffle,
                label: 'Replace',
              ),
            ],
          ),
          child: Container(
            height: 150,
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
                image:
                    NetworkImage(selectedDestination.destination.images.first),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: widget.isEditing ? AppSpacing.small : AppSpacing.base,
                horizontal: AppSpacing.base,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 320,
                        child: Text(
                          selectedDestination.destination.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            decoration: selectedDestination.isDone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: widget.isEditing,
                        child: Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedDestinationsBox
                                    .delete(selectedDestination.key);
                              });
                            },
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.xmark,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  RatingBarIndicator(
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Color.fromRGBO(255, 239, 100, 1),
                    ),
                    unratedColor: AppColors.gray,
                    itemSize: 25,
                    rating: selectedDestination.destination.rating!,
                  ),
                  const SizedBox(
                    height: AppSpacing.small,
                  ),
                  Text(
                    selectedDestination.destination.description,
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
        ),
      ),
    );
  }
}
