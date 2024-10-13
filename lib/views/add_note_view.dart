import 'package:flutter/material.dart';
import 'package:notes_app/view_model/notes_view_model.dart';
import 'package:provider/provider.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return Consumer<NotesViewModel>(
      builder: (context, todoProvider, child) => Scaffold(
        appBar: AppBar(
          actions: [
            //Check Button
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                onPressed: () async {
                  //Checking if title is empty..
                  if (titleController.text.isEmpty) {
                    // Show a dialog if the title is empty
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Title is empty"),
                          content:
                              const Text("Please enter a title before saving."),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                    return; // Exit the function if the title is empty
                  }
                  // Proceed with the normal flow if the title is not empty
                  try {
                    await todoProvider.postNote(
                      title: titleController.text,
                      description: descriptionController.text,
                    );
                    // Show a success SnackBar after the data is successfully posted
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Added successfully!',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors
                            .green, // Optional: Change the background color
                      ),
                    );
                    // Clear the text fields after successful submission
                    titleController.text = "";
                    descriptionController.text = "";
                  } catch (error) {
                    // Handle error, e.g., show a different SnackBar for failure
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to add todo. Please try again.'),
                        backgroundColor:
                            Colors.red, // Optional: Change the background color
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.check),
              ),
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            // Title TextField
            TextField(
              controller: titleController,
              onTap: () {},
              style: const TextStyle(fontSize: 25),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter title',
              ),
            ),
            //Divider
            const Divider(
              color: Colors.white,
            ),
            // Description TextField
            TextField(
              onTap: () {},
              controller: descriptionController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter description',
              ),
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
