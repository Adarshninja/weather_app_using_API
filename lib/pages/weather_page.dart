import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_modal.dart';
import 'package:weather_app/services/weather_service.dart';


class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
 // api key
final _weatherService = WeatherService('************************************');
// ignore: unused_field
Weather? _weather;
 // fetch weather 
_fetchWeather() async {
  String cityName = await _weatherService.getCurrentCity();

  try{
    final weather = await _weatherService.getWeather(cityName);
    setState(() {
      _weather = weather;
    });
  }
  // any errors
  catch(e){
    //
  }
}

 // weather animations
 String getWeatherAnimation(String? mainCondition) {
  if(mainCondition == null) return 'assets/sunny.json'; // this is your default case

  switch(mainCondition.toLowerCase()){
    case 'clouds':
    case 'mist':
    case 'smoke':
    case 'haze':
    case 'dust':
    case 'fog':
    return 'assets/cloud.json';
    case 'rain':
    case 'drizzle':
    case 'shower rain':
    return 'assets/rain.json';
    case 'Thunderstorm':
    return 'assets/thunder.json';
    case 'clear':
    return 'assets/sunny.json';
    default:
     return 'assets/sunny.json';
  }
 }

// init state
@override
void initState(){
  super.initState();

  // fetching weather at startup
  _fetchWeather();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city name
            Text(_weather?.cityName ?? "loading city.." ),
            // Animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            // temperature
            Text('${_weather?.temperature.round()}°C'),
    // weather condition
             Text(_weather?.mainCondition ?? "")
        
          ],
        ),
      ),
    );
  }
}
