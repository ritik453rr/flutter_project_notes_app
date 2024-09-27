import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotesApiServices {
//Get Request
  Future<dynamic> getRequest(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        dynamic jsonData = jsonDecode(response.body);
        debugPrint("Data Fetched");
        return jsonData;
      } else {
        throw Exception('Failed to load: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Network Error: $error');
    }
  }

  //Post Request....
  Future<void> postRequest(
      {required String postUrl,
      required String title,
      required String description}) async {
    final body = {
      "title": title,
      "description": description,
      "is_completed": true
    };
    try {
      final response = await http.post(Uri.parse(postUrl),
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 201) {
        debugPrint("Creation Successfull");
      } else {
        throw Exception('Failed to create: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Network Error: $error');
    }
  }

  //Put Request...
  Future<void> putRequest(
      {required String putUrl,
      required String? title,
      required String? description,
      required String id}) async {
    final body = {
      "title": title,
      "description": description,
      "is_completed": true
    };
    try {
      final response = await http.put(Uri.parse(putUrl + id),
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        debugPrint("Updation Successfull");
      } else {
        debugPrint("Not Updated");
        throw Exception('Failed to update note: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Network Error: $error');
    }
  }

  //Delete Request....
  Future<void> deleteRequest(
      {required String deleteUrl, required String id}) async {
    try {
      final response = await http.delete(
        Uri.parse(deleteUrl + id),
      );
      if (response.statusCode == 200) {
        debugPrint("Notes Deleted");
      } else {
        throw Exception('Failed to delete note: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Network Error: $error');
    }
  }
}
