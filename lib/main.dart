import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:touristop/firebase_options.dart';
import 'package:touristop/models/date/date_model.dart';
import 'package:touristop/models/geopoint/geopoint_model.dart';
import 'package:touristop/models/spot_box/spot_box_model.dart';
import 'package:touristop/models/tourist_spot/tourist_spot_model.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/providers/selected_spot_provider.dart';
import 'package:touristop/providers/user_location_provider.dart';
import 'package:touristop/screens/sections/enable_location_screen.dart';
import 'package:touristop/screens/main/login_screen.dart';
import 'package:touristop/screens/main/select_dates/select_dates_screen.dart';
import 'package:touristop/screens/main/select_spots/select_spots_screen.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:touristop/screens/sections/selected_spot/selected_spot_screen.dart';
import 'package:touristop/screens/sections/selected_spot/spot_reviews.dart';

final userLocationProvider = ChangeNotifierProvider<UserLocationProvider>(
    (ref) => UserLocationProvider());

final datesProvider =
    ChangeNotifierProvider<DatesProvider>((ref) => DatesProvider());

final selectedSpotProvider = ChangeNotifierProvider<SelectedSpotProvider>(
    (ref) => SelectedSpotProvider());

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);

  Hive.registerAdapter(DateAdapter());
  Hive.registerAdapter(TouristSpotAdapter());
  Hive.registerAdapter(GeoPointAdapter());
  Hive.registerAdapter(SpotBoxAdapter());

  await Hive.openBox<Date>('dates');
  await Hive.openBox<SpotBox>('spots');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      title: 'Touristop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      routes: {
        '/select/dates': (context) => const SelectDatesScreen(),
        '/select/spots': (context) => const SelectSpotsScreen(),
        '/selected/spot': (context) => const SpotInformation(),
        '/selected/spot/reviews': (context) => const SpotReviews(),
        '/enable-location': (context) => const EnableLocationScreen(),
        '/login': (context) => const LoginScreen(),
        // '/map':(context) => const MapScreen(),
      },
      initialRoute: user != null ? '/enable-location' : '/login',
    );
  }
}
