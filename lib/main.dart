import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:touristop/boxes/spots_box.dart';
import 'package:touristop/firebase/auth/auth_provider.dart';
import 'package:touristop/firebase_options.dart';
import 'package:touristop/models/user_location_model.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/providers/selected_spots_provider.dart';
import 'package:touristop/providers/user_location_provider.dart';
import 'package:touristop/screens/main/calendar/calendar_screen.dart';
import 'package:touristop/screens/main/enable_location_screen.dart';
import 'package:touristop/screens/main/login_screen.dart';
import 'package:touristop/screens/main/map_screen.dart';
import 'package:touristop/screens/sections/spot_information.dart';
import 'screens/main/select_spots/select_spots_screen.dart';

import 'package:path_provider/path_provider.dart' as PathProvider;

final userLocationProvider =
    StateNotifierProvider<UserLocationProvider, UserLocation>(
  (ref) => UserLocationProvider(),
);

final datesProvider = ChangeNotifierProvider<DatesProvider>(
  (ref) => DatesProvider(),
);

final authProvider = ChangeNotifierProvider<AuthProvider>(
  (ref) => AuthProvider(),
);

final selectedSpots = ChangeNotifierProvider<SelectedSpotsProvider>(
  (ref) => SelectedSpotsProvider(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory directory = await PathProvider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Hive.registerAdapter(SpotBoxAdapter());
  await Hive.openBox<SpotBox>('spots');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fbAuth = ref.watch(authProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.pink, scaffoldBackgroundColor: Colors.white),
      routes: {
        '/enable-location': (context) => const EnableLocationScreen(),
        '/map': (context) => const MapScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/select-spots': (context) => const SelectSpotsScreen(),
        '/selected-spot': (context) => const SpotInformation(),
        '/login': (context) => const LoginScreen()
      },
      home: Scaffold(
        body: SafeArea(
          child: StreamBuilder(
            stream: fbAuth.auth.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return const CalendarScreen();
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              } else {
                return const LoginScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}
