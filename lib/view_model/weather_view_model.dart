import 'package:flutter/material.dart';
import 'package:notes_app/model/weather_model.dart';
import 'package:notes_app/repository/weather_repo.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepo weatherRepo = WeatherRepo();
  WeatherModel weather = WeatherModel();
  bool isLoading = false;
  String? errorMessage; // New property for error message

  Future<void> loadWeather({required String location}) async {
    isLoading = true;
    errorMessage = null; // Reset error message before loading
    notifyListeners();
    try {
      final result = await weatherRepo.getWeather(city: location);

      if (result is WeatherModel) {
        weather =
            result; // If the result is a WeatherModel, update weather data
      } else if (result is String && result == 'City not found') {
        errorMessage = 'City not found'; // Set error message for invalid city
      }
    } catch (error) {
      errorMessage = 'An error occurred: $error'; // Handle any other errors
    } finally {
      isLoading = false;
      notifyListeners(); // Notify listeners when loading is done
    }
  }
}
