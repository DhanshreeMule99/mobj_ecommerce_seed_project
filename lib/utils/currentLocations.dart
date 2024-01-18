import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
class CurrentLocation{
  Future<String> getCurrentAddress() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String formattedAddress =
            "${placemark.street}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}";
        return formattedAddress;
      } else {
        return "Address not found";
      }
    } catch (e) {
      print(e);
      return "Error fetching address";
    }
  }
  Future<Position?> getCurrentLatLong() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        return position;
      } else {
        return position;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

}
