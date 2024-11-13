import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_modal.dart';
import 'package:http/http.dart' as http;

class WeatherService {

// ignore: constant_identifier_names
static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
final String apiKey;

WeatherService(this.apiKey);

Future<Weather> getWeather(String cityName) async {
  final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

  if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load weather data');
  }
 }
 Future<String> getCurrentCity() async {
  // Check location permission
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  // Define location settings with desired accuracy
  LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high, // Set the desired accuracy level here
  );

  // Fetch the current location using the new LocationSettings
  Position position = await Geolocator.getCurrentPosition(
    locationSettings: locationSettings,
  );

  // Convert the location into a list of placemarks
  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  // Extract the city name from the first placemark
  String? city = placemarks[0].locality;
  return city ?? "";
}

}
