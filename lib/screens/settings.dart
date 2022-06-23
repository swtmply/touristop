import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:touristop/models/schedule/selected_destination.dart';
import 'package:touristop/screens/date_selection/date_selection_screen.dart';
import 'package:touristop/screens/history_screen.dart';
import 'package:touristop/screens/login_screen.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/theme/app_spacing.dart';
import 'package:touristop/utils/authentication.dart';
import 'package:touristop/utils/boxes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final selectedDestinationsBox =
      Hive.box<SelectedDestination>(Boxes.selectedDestinations);
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.xxl, horizontal: AppSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              const SizedBox(
                height: AppSpacing.base,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Application',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.darkGray,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        SettingsButtonWidget(
                          icon: const Icon(
                            Icons.refresh,
                            size: 28,
                          ),
                          label: const Text(
                            'Change Plan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ButtonStyle(
                            alignment: Alignment.centerLeft,
                            foregroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 68, 68, 68),
                            ),
                          ),
                          onPressed: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) => _showDialog(
                                () async {
                                  await selectedDestinationsBox.clear();

                                  // ignore: use_build_context_synchronously
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DateSelectionScreen(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                'All data will be lost. Are you sure you want to change plans?',
                              ),
                            );
                          },
                        ),
                        SettingsButtonWidget(
                          icon: const Icon(
                            Icons.history,
                            size: 28,
                          ),
                          label: const Text(
                            'History',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ButtonStyle(
                            alignment: Alignment.centerLeft,
                            foregroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 68, 68, 68),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HistoryScreen(
                                  user: user,
                                ),
                              ),
                            );
                          },
                        ),
                        const Divider()
                      ],
                    ),
                  ),
                  const Text(
                    'User',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.darkGray,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        SettingsButtonWidget(
                          icon: const Icon(
                            Icons.logout,
                            size: 28,
                          ),
                          label: const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            primary: Colors.red[400],
                            alignment: Alignment.centerLeft,
                          ),
                          onPressed: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) => _showDialog(
                                () async {
                                  await Authentication.signOut(
                                    context: context,
                                  );
                                  await selectedDestinationsBox.clear();

                                  // ignore: use_build_context_synchronously
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                'All access to the application will be blocked. Are you sure you want to logout?',
                              ),
                            );
                          },
                        ),
                      ],
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

  Widget _showDialog(Function onPressed, String message) {
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
                    onPressed: () => onPressed(),
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

class SettingsButtonWidget extends StatelessWidget {
  const SettingsButtonWidget({
    Key? key,
    required this.icon,
    required this.label,
    this.style,
    required this.onPressed,
  }) : super(key: key);

  final Widget icon, label;
  final ButtonStyle? style;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton.icon(
            onPressed: () => onPressed(),
            icon: icon,
            label: label,
            style: style,
          ),
        ),
      ],
    );
  }
}
