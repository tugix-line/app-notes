import 'package:app_notes/database/database_help.dart';
import 'package:app_notes/models/note_model.dart';
import 'package:app_notes/notes/homepage.dart';
import 'package:flutter/material.dart';

class UpdateNoteScreen extends StatefulWidget {
  final NoteModel note;
  const UpdateNoteScreen({super.key, required this.note});

  @override
  State<UpdateNoteScreen> createState() => _UpdateNoteScreenState();
}

class _UpdateNoteScreenState extends State<UpdateNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  final formKey = GlobalKey<FormState>();
  final db = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note.noteTitle);
    contentController = TextEditingController(text: widget.note.noteContent);
  }

  Future<void> updateNote() async {
    try {
      int result = await db.updateNote(
        titleController.text,
        contentController.text,
        widget.note.noteId!,
      );
      if (!mounted) return;
      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data Berhasil Diubah', textAlign: TextAlign.center),
            backgroundColor: Colors.green[500],
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NoteScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal Mengupdate Data', textAlign: TextAlign.center),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Terjadi Kesalahan. Periksa Data Anda',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Notes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[300],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                updateNote();
              }
            },
            icon: Icon(Icons.check_circle_rounded),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Title Harus Diisi";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Content Harus Diisi";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
