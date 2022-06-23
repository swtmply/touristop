import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:touristop/models/destination/destination_model.dart';
import 'package:touristop/screens/destination_selection/widgets/destination_list_item.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/theme/app_spacing.dart';

class AddDestinationScreen extends StatefulWidget {
  final DateTime selectedDate;
  const AddDestinationScreen({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<AddDestinationScreen> createState() => _AddDestinationScreenState();
}

class _AddDestinationScreenState extends State<AddDestinationScreen> {
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
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        splashColor: AppColors.slime,
        backgroundColor: AppColors.coldBlue,
        label: const Text('Continue'),
        icon: const Icon(Icons.arrow_forward_outlined),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
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
                          return DestinationListItem(
                            destination: _destinations[index],
                            selectedDate: widget.selectedDate,
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
