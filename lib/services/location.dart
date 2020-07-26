import 'package:geolocator/geolocator.dart';

class Location {
  double lat;
  double lon;
  Future<void> getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    lat = position.latitude;
    lon = position.longitude;
  }
}
