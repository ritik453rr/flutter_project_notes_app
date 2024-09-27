import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherApiServices {
//Get Request
  Future<dynamic> getRequest(String city) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&APPID=43ea6baaad7663dc17637e22ee6f78f2'));
      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        debugPrint("weather Data Fetched");
        return jsonData;
      } else if (response.statusCode == 404) {
        return {'error': 'City not found'};
      } else {
        throw Exception('Failed to load: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Network Error: $error');
    }
  }
}
