import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:notes_app/model/weather_model.dart';

class WeatherApiServices {
//Get Request
  Future<dynamic> getWeather({required String city}) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&APPID=43ea6baaad7663dc17637e22ee6f78f2'));
      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        debugPrint("weather Data Fetched");
        if (jsonData != null &&
            jsonData is Map &&
            jsonData.containsKey('error')) {
          return jsonData[
              'error']; // Return the error message (e.g., "City not found")
        }
        return WeatherModel.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return 'City not found';
      } else {
        throw Exception('Failed to load: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Network Error: $error');
    }
  }
}
