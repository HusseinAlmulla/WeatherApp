import 'dart:convert';

import 'package:http/http.dart' as http;

import '../services/location.dart';
import '../utilities/constants.dart';

class WeatherModel {
  int temperatureC;
  int temperatureF;
  int condition;
  String cityName;
  String weatherDescription;

  Future<dynamic> getWeatherDataByGeoLOcation() async {
    Location location = Location();
    await location.getCurrentLocation();
    double lat = location.lat;
    double lon = location.lon;
    http.Response response = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey');

    var data;
    data = parseWeatherData(response);
    return data;
  }

  parseWeatherData(http.Response response) {
    var data;
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      double tempDouble = jsonData['main']['temp'];
      temperatureC = (tempDouble - 273.15).toInt();
      temperatureF = (tempDouble * 9 / 5 - 459.67).toInt();
      weatherDescription = jsonData['weather'][0]['description'];
      condition = jsonData['weather'][0]['id'];
      cityName = jsonData['name'];
      data = {
        'tempC': temperatureC,
        'tempF': temperatureF,
        'desc': weatherDescription,
        'condition': condition,
        'city': cityName
      };
    }
    return data;
  }

  Future<dynamic> getWeatherDataByCity(String cityName) async {
    http.Response response = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&&appid=$apiKey');

    var data;
    data = parseWeatherData(response);
    return data;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
