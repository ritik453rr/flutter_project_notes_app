import 'package:flutter/material.dart';
import 'package:notes_app/model/NoteModel.dart';
import 'package:notes_app/view_model/notes_view_model.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // For debouncing

class NoteView extends StatefulWidget {
  final NoteModel? note;
  const NoteView({super.key, required this.note});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  Timer? _debounce; // Debounce Timer
  bool saving = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title ?? '');
    descriptionController =
        TextEditingController(text: widget.note?.description ?? '');
  }

  // Debounce method to optimize the API calls
  Future<void> onFieldChanged(
      {required BuildContext context,
      required String title,
      required String description}) async {
  
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        saving = true;
      });
        
      await Provider.of<NotesViewModel>(context, listen: false).updateNote(
        title: title,
        description: description,
        id: widget.note!.sId.toString(),
      );
      setState(() {
        saving = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, value, child) => Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: saving ? const Text("saving...") : const Text("saved"),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 15),
                    // Title TextField
                    TextField(
                      onChanged: (value) async {
                        await onFieldChanged(
                            context: context,
                            title: titleController.text,
                            description: descriptionController.text);
                      },
                      controller: titleController,
                      style: const TextStyle(fontSize: 25),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter title',
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    // Description TextField
                    TextField(
                      onChanged: (value) async {
                        await onFieldChanged(
                            context: context,
                            title: titleController.text,
                            description: descriptionController.text);
                      },
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
            ));
  }
}
