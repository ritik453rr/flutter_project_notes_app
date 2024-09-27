import 'package:flutter/material.dart';
import 'package:notes_app/model/weather_model.dart';
import 'package:notes_app/services/weather_api_services.dart';

class WeatherRepo {
  WeatherApiServices weatherApiServices = WeatherApiServices();
  Future<dynamic> getWeather({required String city}) async {
    try {
      final response = await weatherApiServices.getRequest(city);
      // Check if the response contains an error message
      if (response != null &&
          response is Map &&
          response.containsKey('error')) {
        return response[
            'error']; // Return the error message (e.g., "City not found")
      }
      return WeatherModel.fromJson(response);
    } catch (e) {
      debugPrint("Error fetching weather data: $e");
      return "Failed to fetch weather data";
    }
  }
}
