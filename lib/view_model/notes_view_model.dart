import 'package:flutter/material.dart';
import 'package:notes_app/model/note_model.dart';
import 'package:notes_app/repository/notes_repo.dart';
import 'package:notes_app/services/local_storage_services.dart';

class NotesViewModel extends ChangeNotifier {
  List<NoteModel> _notes = [];
  bool _isLoading = false;
  String? _errorMessage;
  List<NoteModel> get notes => _notes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  final NotesRepo notesRepo = NotesRepo();
  final LocalStorageService localStorageService = LocalStorageService();

  //load Notes.....
  Future<void> loadNotes() async {
    _isLoading = true; // Set loading to true
    _errorMessage = null; // Reset error message
    notifyListeners(); // Notify the UI about th
    try {
      List<NoteModel> apiNotes = await notesRepo.getNotes();
      await localStorageService.saveNotes(apiNotes);
      _notes = await localStorageService.getNotes();
    } catch (error) {
      _errorMessage =
          'An error occurred: ${error.toString()}'; // Set the error message
    } finally {
      _isLoading = false; // Set loading to false when done
      notifyListeners();
    }
  }

  //Post Notes
  Future<void> postNote(
      {required String title, required String description}) async {
    try {
      await notesRepo.postNote(title: title, description: description);
      notifyListeners();
    } catch (error) {
      _errorMessage =
          'Failed to add: ${error.toString()}'; // Set the error message
    }
  }

  //Post Note
  Future<void> deleteNote({required noteId}) async {
    try {
      await notesRepo.deleteNote(noteId: noteId);
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
      await notesRepo.updateNote(
          title: title, description: description, id: id);
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
