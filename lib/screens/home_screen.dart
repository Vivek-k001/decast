import 'package:decast/widgets/loadig_spinner.dart';
import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();

  WeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWeatherByIP();
  }

  // Load weather using IP location on startup
  Future<void> _loadWeatherByIP() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final location = await LocationService.getLocationByIP();
      if (location != null) {
        await _fetchWeatherByCoords(
          location['latitude']!,
          location['longitude']!,
        );
      } else {
        setState(() {
          _errorMessage = 'Could not detect location. Please search manually.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading weather: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Get precise GPS location
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final location = await LocationService.getCurrentLocation();
      if (location != null) {
        await _fetchWeatherByCoords(
          location['latitude']!,
          location['longitude']!,
        );
      } else {
        setState(() {
          _errorMessage = 'Could not get location';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Search weather by city name
  Future<void> _searchCity() async {
    final city = _cityController.text.trim();
    if (city.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await WeatherService.getWeatherByCity(city);
      if (weather != null) {
        final forecast = await WeatherService.getForecast(
          weather.lat,
          weather.lon,
        );

        setState(() {
          _currentWeather = weather;
          _forecast = forecast;
          _cityController.text = weather.cityName;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'City not found';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fetch weather by coordinates
  Future<void> _fetchWeatherByCoords(double lat, double lon) async {
    try {
      final weather = await WeatherService.getWeatherByCoords(lat, lon);
      if (weather != null) {
        final forecast = await WeatherService.getForecast(lat, lon);

        setState(() {
          _currentWeather = weather;
          _forecast = forecast;
          _cityController.text = weather.cityName;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Unable to fetch weather data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 60,
                      offset: Offset(0, 20),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    // Title
                    Text(
                      '🌤️ Weather App',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Location button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _getCurrentLocation,
                        icon: Icon(Icons.location_on),
                        label: Text(
                          _isLoading
                              ? '📍 Getting location...'
                              : '📍 Use My Current Location',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2ecc71),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Search box
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              hintText: 'Or enter city name...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFFDDDDDD),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFF667eea),
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(15),
                            ),
                            onSubmitted: (_) => _searchCity(),
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _searchCity,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF667eea),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Search',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Error message
                    if (_errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color(0xFFff4757),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // Loading or weather info
                    if (_isLoading)
                      Padding(
                        padding: EdgeInsets.all(40),
                        child: LoadingSpinner(),
                      )
                    else if (_currentWeather != null) ...[
                      SizedBox(height: 20),
                      WeatherCard(weather: _currentWeather!),

                      // Forecast section
                      if (_forecast.isNotEmpty) ...[
                        SizedBox(height: 40),
                        Divider(thickness: 2, color: Color(0xFFE0E0E0)),
                        SizedBox(height: 30),
                        Text(
                          '5-Day Forecast',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 20),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: _forecast.length,
                          itemBuilder: (context, index) {
                            return ForecastCardWidget(
                              forecast: _forecast[index],
                              index: index,
                            );
                          },
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}
