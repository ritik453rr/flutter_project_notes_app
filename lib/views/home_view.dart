import 'package:flutter/material.dart';
import 'package:notes_app/model/note_model.dart';
import 'package:notes_app/services/local_storage_services.dart';
import 'package:notes_app/views/add_note_view.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/note_view.dart';
import 'package:notes_app/views/weather_view.dart';
import 'package:notes_app/view_model/notes_view_model.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  LocalStorageService localStorageService = LocalStorageService();
  @override
  void initState() {
    Provider.of<NotesViewModel>(context, listen: false).loadLocalNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          //Weather Button...
          IconButton(
            tooltip: "Weather",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WeatheView(),
                ),
              );
            },
            icon: const Icon(Icons.cloud),
          ),
          //Refresh button.....
          IconButton(
            tooltip: "Refrsh",
            onPressed: () {
              Provider.of<NotesViewModel>(context, listen: false).loadNotes();
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
          //LogOut Button
          IconButton(
            tooltip: "Logout",
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginView(),
                  ),
                  (route) => false);
              localStorageService.setLoginStatus(status: false);
            },
            icon: const Icon(Icons.logout_outlined),
          ),
          //Space..
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      // Floating Add Notes Button
      floatingActionButton: FloatingActionButton.extended(
        tooltip: "Add",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNoteView(),
            ),
          );
        },
        label: const Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      body: Consumer<NotesViewModel>(
        builder: (context, notesProvider, child) {
          // 1. Show loading indicator while fetching data
          if (notesProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // 2. Show error message if there's an error
          if (notesProvider.errorMessage != null) {
            return Center(
              child: Text(
                'Error: ${notesProvider.errorMessage}',
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }
          // 3. Show empty state message if no notes are available
          if (notesProvider.notes.isEmpty) {
            return Center(
              child: Text(
                'empty',
                style: TextStyle(fontSize: 25, color: Colors.grey[500]),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            child: ListView.builder(
              itemCount: notesProvider.notes.length,
              itemBuilder: (context, index) {
                final NoteModel note = notesProvider.notes[index];
                // Note Card
                return Card(
                  color: Colors.grey.withOpacity(0.2),
                  elevation: 5,
                  child: ListTile(
                    trailing:
                        //Delete button
                        IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Delete Note"),
                              content: const Text("Sure to delete Note?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("No"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    notesProvider.deleteNote(noteId: note.sId);
                                  },
                                  child: const Text("Yes"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    // View Note
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteView(note: note),
                        ),
                      );
                    },
                    // Todo title
                    title: Text(
                      note.title ?? 'No Title',
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      note.description ?? 'No Description',
                      maxLines: 1,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
