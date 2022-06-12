// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:touristop/models/dates_list/dates_list_model.dart';
import 'package:touristop/models/plan.dart';
import 'package:touristop/models/spots_list/spots_list_model.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/providers/selected_bundle.dart';
import 'package:touristop/providers/spots_provider.dart';
import 'package:touristop/providers/user_location.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/utils/authentication.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final datesBox = Hive.box<DatesList>('dates');
  final spotsBox = Hive.box<SpotsList>('spots');
  final plan = Hive.box<Plan>('plan');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Application',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.gray,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) => _changePlanDialog(),
                                  );
                                },
                                icon: const Icon(
                                  Icons.refresh,
                                  size: 28,
                                ),
                                label: Text(
                                  'Change Plan',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ButtonStyle(
                                  alignment: Alignment.centerLeft,
                                  foregroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(255, 68, 68, 68),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      Text(
                        'User',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.gray,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) => _signOutDialog(),
                                  );
                                },
                                icon: const Icon(
                                  Icons.logout,
                                  size: 28,
                                ),
                                label: Text(
                                  'Logout',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ButtonStyle(
                                  alignment: Alignment.centerLeft,
                                  foregroundColor: MaterialStateProperty.all(
                                    Colors.red[400],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _signOutDialog() {
    final dates = ref.watch(datesProvider);
    final selectedBundles = ref.watch(selectedBundleProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: SizedBox(
          height: 80,
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Are you sure you want to logout?'),
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
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.slime,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () async {
                      dates.datesList.clear();
                      selectedBundles.selectedSpots.clear();

                      await datesBox.clear();
                      await spotsBox.clear();
                      await plan.clear();

                      debugPrint(spotsBox.values.length.toString());

                      await Authentication.signOut(context: context);

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      backgroundColor: AppColors.coldBlue,
                    ),
                    child: Text(
                      'Confirm',
                      style: GoogleFonts.inter(
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

  Widget _changePlanDialog() {
    final dates = ref.watch(datesProvider);
    final selectedBundles = ref.watch(selectedBundleProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: SizedBox(
          height: 100,
          width: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'All data will be lost. Are you sure you want to change plans?'),
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
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.slime,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () async {
                      dates.datesList.clear();
                      selectedBundles.selectedSpots.clear();

                      await datesBox.clear();
                      await spotsBox.clear();
                      await plan.clear();

                      debugPrint(spotsBox.values.length.toString());

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/select/dates',
                        (route) => false,
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      backgroundColor: AppColors.coldBlue,
                    ),
                    child: Text(
                      'Confirm',
                      style: GoogleFonts.inter(
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
