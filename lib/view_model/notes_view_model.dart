import 'package:flutter/material.dart';
import 'package:notes_app/model/note_model.dart';
import 'package:notes_app/res/app_url.dart';
import 'package:notes_app/services/local_storage_services.dart';
import 'package:notes_app/services/notes_api_services.dart';

class NotesViewModel extends ChangeNotifier {

  List<NoteModel> _notes = [];
  bool _isLoading = false;
  String? _errorMessage;
  final NotesApiServices notesApiServices = NotesApiServices();
  final LocalStorageService localStorageService = LocalStorageService();

  List<NoteModel> get notes => _notes;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;
  

  //load Notes from api store in the local storage
  Future<void> loadNotes() async {
    _isLoading = true; // Set loading to true
    _errorMessage = null; // Reset error message
    notifyListeners();
    try {
      List<NoteModel> apiNotes =
      await notesApiServices.getRequest(AppUrl.getNotesUrl);
      await localStorageService.saveNotes(apiNotes);
      _notes = await localStorageService.getLocalNotes();
    } catch (error) {
      _errorMessage =
          'An error occurred: ${error.toString()}'; // Set the error message
    } finally {
      _isLoading = false; // Set loading to false when done
      notifyListeners();
    }
  }

  //Load notes from local storage
  Future<void> loadLocalNotes() async {
    _isLoading = true; // Set loading to true
    _errorMessage = null; // Reset error message
    notifyListeners();
    try {
      _notes = await localStorageService.getLocalNotes();
    } catch (error) {
      _errorMessage =
          'An error occurred: ${error.toString()}'; // Set the error message
    } finally {
      _isLoading = false; // Set loading to false when done
      notifyListeners();
    }
  }

  //Post Note
  Future<void> postNote(
      {required String title, required String description}) async {
    try {
      await notesApiServices.postRequest(
          title: title, description: description);
      notifyListeners();
    } catch (error) {
      _errorMessage =
          'Failed to add: ${error.toString()}'; // Set the error message
    }
  }

  //Delete Note
  Future<void> deleteNote({required noteId}) async {
    try {
      await notesApiServices.deleteRequest(
          id: noteId, deleteUrl: AppUrl.deleteNotesUrl);
      _notes.removeWhere(
        (element) => element.sId == noteId,
      );
      notifyListeners();
    } catch (error) {
      _errorMessage =
          'Failed to add: ${error.toString()}'; // Set the error message
    }
  }

  //Update Note
  Future<void> updateNote(
      {required String title,
      required String description,
      required String id}) async {
    try {
      await notesApiServices.putRequest(
          title: title,
          description: description,
          id: id,
          putUrl: AppUrl.putNotesUrl);
      int index = _notes.indexWhere(
        (element) => element.sId == id,
      );
      _notes[index].title = title;
      _notes[index].description = description;
      notifyListeners();
    } catch (error) {
      _errorMessage =
          'Failed to add: ${error.toString()}'; // Set the error message
    }
  }
}
