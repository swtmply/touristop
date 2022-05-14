import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:touristop/firebase_options.dart';
import 'package:touristop/models/user_location_model.dart';
import 'package:touristop/providers/dates_provider.dart';
import 'package:touristop/providers/user_location_provider.dart';
import 'package:touristop/screens/main/calendar/calendar_screen.dart';
import 'package:touristop/screens/main/enable_location_screen.dart';
import 'package:touristop/screens/main/map_screen.dart';

final userLocationProvider =
    StateNotifierProvider<UserLocationProvider, UserLocation>(
        (ref) => UserLocationProvider());

final datesProvider =
    ChangeNotifierProvider<DatesProvider>((ref) => DatesProvider());

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
    final userLocation = ref.watch(userLocationProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      routes: {
        '/enable-location': (context) => const EnableLocationScreen(),
        '/map': (context) => const MapScreen(),
        '/calendar': (context) => const CalendarScreen(),
      },
      home: Scaffold(
        body: SafeArea(
          child: userLocation.userPosition != null
              ? const MapScreen()
              : const EnableLocationScreen(),
        ),
      ),
    );
  }
}
