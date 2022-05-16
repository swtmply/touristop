import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:touristop/firebase/auth/auth_provider.dart';
import 'package:touristop/firebase_options.dart';
import 'package:touristop/models/user_location_model.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/providers/user_location_provider.dart';
import 'package:touristop/screens/main/calendar/calendar_screen.dart';
import 'package:touristop/screens/main/enable_location_screen.dart';
import 'package:touristop/screens/main/map_screen.dart';
import 'package:touristop/screens/sections/introduction.dart';
import 'screens/main/select_spots_screen.dart';

final userLocationProvider =
    StateNotifierProvider<UserLocationProvider, UserLocation>(
        (ref) => UserLocationProvider());

final datesProvider =
    ChangeNotifierProvider<DatesProvider>((ref) => DatesProvider());

final authProvider =
    ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      routes: {
        '/enable-location': (context) => const EnableLocationScreen(),
        '/map': (context) => const MapScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/select-spots': (context) => SelectSpotsScreen(),
      },
      home: Scaffold(
        body: SafeArea(
          // child: userLocation.userPosition != null
          //     ? const MapScreen()
          //     : const EnableLocationScreen(),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return EnableLocationScreen();
              } else if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              } else {
                return OnBoardingPage();
              }
            },
          ),
        ),
      ),
    );
  }
}
