import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:touristop/firebase_options.dart';
import 'package:touristop/models/destination/destination_model.dart';
import 'package:touristop/models/schedule/schedule_model.dart';
import 'package:touristop/models/schedule/selected_destination.dart';
import 'package:touristop/screens/date_selection/date_selection_screen.dart';
import 'package:touristop/screens/destination_selection/destination_selection_screen.dart';
import 'package:touristop/screens/login_screen.dart';
import 'package:touristop/screens/main_screen.dart';
import 'package:touristop/screens/schedule/schedule_screen.dart';
import 'package:touristop/theme/app_colors.dart';
import 'package:touristop/utils/boxes.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);

  Boxes.initializeAdapters();

  await Hive.openBox<Destination>(Boxes.destinations);
  await Hive.openBox<SelectedDestination>(Boxes.selectedDestinations);
  await Hive.openBox<Schedule>(Boxes.schedule);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touristop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.coldBlue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const LoginScreen(),
    );
  }
}
