import 'dart:convert';
import 'package:notes_app/model/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static String loginStatusKey = "loginKey";

  // Save notes to shared preferences
  Future<void> saveNotes(List<NoteModel> notes) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> noteStrings =
          notes.map((note) => jsonEncode(note.toJson())).toList();
      await prefs.setStringList('notes', noteStrings);
    } catch (error) {
      throw Exception('Failed to save notes locally: $error');
    }
  }

  // Get notes from shared preferences with error handling
  Future<List<NoteModel>> getLocalNotes() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? notesStrings = prefs.getStringList('notes');
      if (notesStrings != null) {
        return notesStrings
            .map((note) => NoteModel.fromJson(jsonDecode(note)))
            .toList();
      } else {
        return [];
      }
    } catch (error) {
      throw Exception('Failed to load notes locally: $error');
    }
  }

  //Set Login Status
  void setLoginStatus({required bool status}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(loginStatusKey, status);
  }

  //Get Login Status
   Future<bool?> getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? result = prefs.getBool(loginStatusKey);
    return result;
  }
}
