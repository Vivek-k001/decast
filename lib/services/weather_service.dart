import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env_config.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Get current weather by city name
  static Future<WeatherModel?> getWeatherByCity(String city) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/weather?q=$city&appid=${EnvConfig.apiKey}&units=metric',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('City not found');
      }
    } catch (e) {
      print('Error fetching weather: $e');
      rethrow;
    }
  }

  // Get current weather by coordinates
  static Future<WeatherModel?> getWeatherByCoords(
    double lat,
    double lon,
  ) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/weather?lat=$lat&lon=$lon&appid=${EnvConfig.apiKey}&units=metric',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Unable to fetch weather data');
      }
    } catch (e) {
      print('Error fetching weather: $e');
      rethrow;
    }
  }

  // Get 5-day forecast
  static Future<List<ForecastModel>> getForecast(double lat, double lon) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/forecast?lat=$lat&lon=$lon&appid=${EnvConfig.apiKey}&units=metric',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List forecastList = data['list'];

        // Get one forecast per day (closest to noon)
        Map<String, ForecastModel> dailyForecasts = {};

        for (var item in forecastList) {
          final forecast = ForecastModel.fromJson(item);
          final dateKey = forecast.date.toIso8601String().split('T')[0];

          if (!dailyForecasts.containsKey(dateKey) ||
              (forecast.date.hour - 12).abs() <
                  (dailyForecasts[dateKey]!.date.hour - 12).abs()) {
            dailyForecasts[dateKey] = forecast;
          }
        }

        return dailyForecasts.values.take(5).toList();
      } else {
        throw Exception('Forecast unavailable');
      }
    } catch (e) {
      print('Error fetching forecast: $e');
      return [];
    }
  }
}
