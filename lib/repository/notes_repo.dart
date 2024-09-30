import 'package:notes_app/model/note_model.dart';
import 'package:notes_app/res/app_url.dart';
import 'package:notes_app/services/notes_api_services.dart';

class NotesRepo {
  NotesApiServices apiServices = NotesApiServices();

  //Get Notes
  Future<List<NoteModel>> getNotes() async {
    try {
      dynamic jsonData = await apiServices.getRequest(AppUrl.getNotesEndPoint);
      List<NoteModel> tempLists = [];
      for (var i in jsonData["items"]) {
        tempLists.add(NoteModel.fromJson(i));
      }
      return tempLists;
    } catch (e) {
      rethrow;
    }
  }

  //Post Notes
  Future<void> postNote(
      {required String title, required String description}) async {
    await apiServices.postRequest(
        postUrl: AppUrl.postNotesEndPoint,
        title: title,
        description: description);
  }

  //Update Notes
  Future<void> updateNote(
      {required String? title,
      required String? description,
      required String id}) async {
    await apiServices.putRequest(
        putUrl: AppUrl.putNotesEndPoint,
        title: title,
        description: description,
        id: id);
  }

  //delete todo
  Future<void> deleteNote({required String noteId}) async {
    await apiServices.deleteRequest(
        deleteUrl: AppUrl.deleteNotesEndPoint, id: noteId);
  }
}
