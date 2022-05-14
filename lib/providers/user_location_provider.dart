import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:touristop/models/user_location_model.dart';

class UserLocationProvider extends StateNotifier<UserLocation> {
  UserLocationProvider() : super(UserLocation(null));
}
