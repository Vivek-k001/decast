import 'package:flutter/material.dart';
import '../models/forecast_model.dart';
import 'package:intl/intl.dart';

class ForecastCardWidget extends StatelessWidget {
  final ForecastModel forecast;
  final int index;

  const ForecastCardWidget({
    super.key,
    required this.forecast,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isTomorrow = index == 1;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isTomorrow
              ? [Color(0xFFf093fb), Color(0xFFf5576c)]
              : [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: isTomorrow
            ? [
                BoxShadow(
                  color: Color(0xFFf5576c).withOpacity(0.4),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Day name
          Text(
            forecast.getDayName(index),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),

          // Date
          Text(
            DateFormat('MMM d').format(forecast.date),
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 10),

          // Weather icon
          Text(forecast.getWeatherIcon(), style: TextStyle(fontSize: 50)),
          SizedBox(height: 10),

          // Temperature
          Text(
            '${forecast.temperature.round()}°C',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),

          // Description
          Text(
            forecast.description.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10),

          // Details
          Text(
            '💧 ${forecast.humidity}%',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
          Text(
            '💨 ${forecast.windSpeed} m/s',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
