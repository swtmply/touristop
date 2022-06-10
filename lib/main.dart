import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:touristop/firebase_options.dart';
import 'package:touristop/models/app_geopoint/app_geopoint_model.dart';
import 'package:touristop/models/dates_list/dates_list_model.dart';
import 'package:touristop/models/plan.dart';
import 'package:touristop/models/selected_spots/selected_spots_model.dart';
import 'package:touristop/models/spots_list/spots_list_model.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';
import 'package:touristop/screens/main/map/map_screen.dart';
import 'package:touristop/screens/main/schedule/schedule_screen.dart';
import 'package:touristop/screens/main/select_dates/select_dates_screen.dart';
import 'package:touristop/screens/main/select_spots/cluster_select_spots_screen.dart';
import 'package:touristop/screens/main/select_spots/select_spots_screen.dart';
import 'package:touristop/screens/sections/enable_location_screen.dart';
import 'package:touristop/screens/sections/introduction_screen.dart';
import 'package:touristop/screens/sections/login_screen.dart';
import 'package:touristop/utils/navigation.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);

  Hive.registerAdapter<AppGeoPoint>(AppGeoPointAdapter());
  Hive.registerAdapter<TouristSpot>(TouristSpotAdapter());
  Hive.registerAdapter<SpotsList>(SpotsListAdapter());
  Hive.registerAdapter<DatesList>(DatesListAdapter());
  Hive.registerAdapter(SelectedSpotsAdapter());
  Hive.registerAdapter(PlanAdapter());

  await Hive.openBox<SpotsList>('spots');
  await Hive.openBox<DatesList>('dates');
  await Hive.openBox<SelectedSpots>('selectedSpots');
  await Hive.openBox<Plan>('plan');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? user = FirebaseAuth.instance.currentUser;
    final datesBox = Hive.box<DatesList>('dates');

    return MaterialApp(
      title: 'Touristop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        '/select/dates': (context) => const SelectDatesScreen(),
        '/select/spots': (context) => const SelectSpotsScreen(),
        '/select/spots/cluster': (context) => const ClusterSelectSpots(),
        '/enable-location': (context) => const EnableLocationScreen(),
        '/schedule': (context) => const ScheduleScreen(),
        '/navigation': (context) => const Navigation(),
        '/map': (context) => const MapScreen(),
        '/login': (context) => const LoginScreen(),
        '/introduction': (context) => const Introduction(),
      },
      initialRoute: user == null
          ? '/introduction'
          : datesBox.values.isEmpty
              ? '/select/dates'
              : '/navigation',
    );
  }
}
