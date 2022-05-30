import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:touristop/main.dart';
import 'package:touristop/models/spot_box/spot_box_model.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';
import 'package:touristop/utils/reviews.dart';

class SpotListItem extends ConsumerStatefulWidget {
  final TouristSpot spot;
  final DateTime selectedDate;

  const SpotListItem({Key? key, required this.spot, required this.selectedDate})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SpotListItemState();
}

class _SpotListItemState extends ConsumerState<SpotListItem> {
  @override
  void initState() {
    super.initState();
    Reviews.reviewAverage(widget.spot.name).then((value) {
      setState(() {
        widget.spot.averageRating = value.isNaN ? 0 : value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedSpot = ref.watch(selectedSpotProvider);
    final spotsBox = Hive.box<SpotBox>('spots');

    return InkWell(
      onTap: () {
        selectedSpot.setSelectedSpot(widget.spot);
        Navigator.pushNamed(context, '/selected/spot');
      },
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.spot.image),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            widget.spot.name,
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.only(left: 15, top: 10),
                        child: RatingBar.builder(
                          ignoreGestures: true,
                          unratedColor:
                              const Color.fromARGB(100, 255, 241, 114),
                          initialRating: widget.spot.averageRating ?? 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 25,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 2),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Color.fromRGBO(255, 239, 100, 1),
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 30),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.spot.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, right: 20),
            child: Align(
              alignment: Alignment.topRight,
              child: RoundCheckBox(
                isChecked: spotsBox
                    .containsKey('${widget.spot.name}${widget.selectedDate}'),
                onTap: (selectedItem) {
                  final spotItem = SpotBox(
                      spot: widget.spot, selectedDate: widget.selectedDate);

                  if (selectedItem.toString() == 'true') {
                    spotsBox.put(
                        '${widget.spot.name}${widget.selectedDate}', spotItem);
                  } else {
                    spotsBox
                        .delete('${widget.spot.name}${widget.selectedDate}');
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
                    child: const FaIcon(FontAwesomeIcons.check,
                        color: Colors.white, size: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
