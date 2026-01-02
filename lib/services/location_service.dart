import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationService {
  // Get location by IP address (no permission needed)
  static Future<Map<String, double>?> getLocationByIP() async {
    try {
      final response = await http.get(Uri.parse('https://ipapi.co/json/'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'latitude': (data['latitude'] ?? 0).toDouble(),
          'longitude': (data['longitude'] ?? 0).toDouble(),
        };
      }
    } catch (e) {
      print('IP location error: $e');
    }
    return null;
  }

  // Get precise GPS location (asks for permission)
  static Future<Map<String, double>?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return await getLocationByIP(); // Fallback to IP
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return await getLocationByIP(); // Fallback to IP
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return await getLocationByIP(); // Fallback to IP
      }

      // Get position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return {'latitude': position.latitude, 'longitude': position.longitude};
    } catch (e) {
      print('GPS location error: $e');
      return await getLocationByIP(); // Fallback to IP
    }
  }
}
