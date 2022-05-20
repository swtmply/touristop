import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:touristop/firebase/auth/auth_provider.dart';
import 'package:touristop/firebase_options.dart';
import 'package:touristop/models/user_location_model.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/providers/selected_spot_provider.dart';
import 'package:touristop/providers/user_location_provider.dart';
import 'package:touristop/screens/main/calendar/calendar_screen.dart';
import 'package:touristop/screens/main/enable_location_screen.dart';
import 'package:touristop/screens/main/login_screen.dart';
import 'package:touristop/screens/main/map_screen.dart';
import 'package:touristop/screens/sections/spot_information.dart';
import 'package:touristop/screens/sections/spot_reviews.dart';
import 'package:touristop/screens/tests/user_test_screen.dart';
import 'screens/main/select_spots/select_spots_screen.dart';

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

final spotsProvider = ChangeNotifierProvider<SelectedSpotProvider>(
  (ref) => SelectedSpotProvider(),
);

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
        '/login': (context) => const LoginScreen(),
        '/spot-reviews': (context) => const SpotReviewsScreen(),
      },
      home: Scaffold(
        body: SafeArea(
          child: StreamBuilder(
            stream: fbAuth.auth.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return EnableLocationScreen();
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
