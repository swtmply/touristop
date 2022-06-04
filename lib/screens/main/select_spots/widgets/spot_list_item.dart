import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:touristop/models/dates_list/dates_list_model.dart';
import 'package:touristop/models/spots_list/spots_list_model.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/providers/selected_spots.dart';
import 'package:touristop/screens/sections/select_spot/spot_information_screen.dart';
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
    final selectedSpots = ref.watch(selectedSpotsProvider);
    final spotsBox = Hive.box<SpotsList>('spots');
    final datesBox = Hive.box<DatesList>('dates');
    final dates = ref.watch(datesProvider);
    final datesListItem = datesBox.get(dates.toDateKey(widget.selectedDate));

    String key = '${widget.spot.name}${widget.selectedDate}';
    bool isSelected = spotsBox.containsKey(key);
    bool isSelectable =
        datesListItem!.timeRemaining - widget.spot.numberOfHours >= 0;

    return InkWell(
      onTap: () {
        selectedSpots.setFirstSpot(widget.spot);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpotInformation(
              spot: widget.spot,
            ),
          ),
        );
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
                              const Color.fromARGB(255, 181, 177, 177),
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
                isChecked: isSelected,
                onTap: isSelectable || isSelected
                    ? (selectedItem) {
                        final spotItem = SpotsList(
                          spot: widget.spot,
                          date: widget.selectedDate,
                          isSelected: true,
                        );

                        if (selectedItem.toString() == 'true') {
                          dates.updateDateList(
                              widget.selectedDate, -widget.spot.numberOfHours);
                          spotsBox.put(key, spotItem);
                          debugPrint('Spot Added');
                        } else {
                          dates.updateDateList(
                              widget.selectedDate, widget.spot.numberOfHours);
                          spotsBox.delete(key);
                        }
                      }
                    : null,
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
