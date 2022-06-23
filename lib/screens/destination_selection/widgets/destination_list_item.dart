// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:touristop/models/destination/destination_model.dart';
import 'package:touristop/models/schedule/selected_destination.dart';
import 'package:touristop/screens/destination_information/destination_information.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/theme/app_spacing.dart';
import 'package:touristop/utils/boxes.dart';
import 'package:collection/collection.dart';

class DestinationListItem extends ConsumerStatefulWidget {
  final Destination destination;
  final DateTime selectedDate;
  const DestinationListItem(
      {Key? key, required this.destination, required this.selectedDate})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DestinationListItemState();
}

class _DestinationListItemState extends ConsumerState<DestinationListItem> {
  final selectedDestinationsBox =
      Hive.box<SelectedDestination>(Boxes.selectedDestinations);

  String generateKey() {
    final date = DateUtils.dateOnly(widget.selectedDate);
    return '${widget.destination.name}-$date';
  }

  SelectedDestination? _getDestination() {
    final data = selectedDestinationsBox.values.firstWhereOrNull((element) {
      if (element.destination.name == widget.destination.name &&
          element.dateSelected.toString() == widget.selectedDate.toString()) {
        return true;
      }
      return false;
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final destination = widget.destination;
    final selectedDestination = _getDestination();
    final selectedDate = widget.selectedDate;

    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DestinationInformation(
                  destination: destination,
                ),
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
                image: NetworkImage(destination.images.first),
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
                          destination.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      RoundCheckBox(
                        isChecked: selectedDestination != null,
                        onTap: (checked) {
                          if (checked == true) {
                            final selectedDestination = SelectedDestination(
                              dateSelected: selectedDate,
                              destination: destination,
                              isDone: false,
                            );

                            selectedDestinationsBox.put(
                              selectedDestinationsBox.values.length,
                              selectedDestination,
                            );
                          } else {
                            selectedDestinationsBox
                                .delete(selectedDestination?.key);
                          }
                        },
                        size: 25,
                        checkedColor: Colors.transparent,
                        uncheckedColor: Colors.transparent,
                        border: Border.all(
                          width: 3,
                          color: Colors.white,
                        ),
                        checkedWidget: Container(
                          padding: const EdgeInsets.all(2),
                          child: const FaIcon(
                            FontAwesomeIcons.check,
                            color: Colors.white,
                            size: 16,
                          ),
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
                    rating: destination.rating!,
                  ),
                  const SizedBox(
                    height: AppSpacing.small,
                  ),
                  Text(
                    destination.description,
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
}
