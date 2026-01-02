import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import 'package:intl/intl.dart';

class WeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const WeatherCard({super.key, required this.weather});

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Weather icon
        Text(weather.getWeatherIcon(), style: TextStyle(fontSize: 100)),
        SizedBox(height: 20),

        // Temperature
        Text(
          '${weather.temperature.round()}°C',
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        SizedBox(height: 10),

        // City name
        Text(
          '${weather.cityName}, ${weather.country}',
          style: TextStyle(fontSize: 28, color: Color(0xFF555555)),
        ),
        SizedBox(height: 10),

        // Description
        Text(
          weather.description.toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF666666),
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 30),

        // Details grid
        _buildDetailsGrid(),
      ],
    );
  }

  Widget _buildDetailsGrid() {
    final details = {
      'Feels Like': '${weather.feelsLike.round()}°C',
      'Humidity': '${weather.humidity}%',
      'Wind Speed': '${weather.windSpeed} m/s',
      'Pressure': '${weather.pressure} hPa',
      'Visibility': '${(weather.visibility / 1000).toStringAsFixed(1)} km',
      'Cloudiness': '${weather.cloudiness}%',
      'Wind Direction': weather.getWindDirection(),
      'Min Temp': '${weather.minTemp.round()}°C',
      'Max Temp': '${weather.maxTemp.round()}°C',
      'Sunrise': _formatTime(weather.sunrise),
      'Sunset': _formatTime(weather.sunset),
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 2,
      ),
      itemCount: details.length,
      itemBuilder: (context, index) {
        final entry = details.entries.elementAt(index);
        return Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: TextStyle(color: Color(0xFF888888), fontSize: 13),
              ),
              SizedBox(height: 5),
              Text(
                entry.value,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
