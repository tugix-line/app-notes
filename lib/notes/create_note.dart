import 'package:app_notes/database/database_help.dart';
import 'package:app_notes/models/note_model.dart';
import 'package:app_notes/notes/homepage.dart';
import 'package:flutter/material.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final titleControler = TextEditingController();
  final contentControler = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final db = DatabaseHelper();

  Future<void> createNote() async {
    try {
      int result = await db.createNote(
        NoteModel(
          noteTitle: titleControler.text,
          noteContent: contentControler.text,
          createdAt: DateTime.now().toIso8601String(),
        ),
      );
      if (!mounted) return;
      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Notes Berhasil Ditambahkan',
              textAlign: TextAlign.center,
            ),
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
            content: Text(
              'Notes Gagal Ditambahkan',
              textAlign: TextAlign.center,
            ),
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
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NoteScreen()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          'Create Notes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                createNote();
              }
            },
            icon: Icon(Icons.check_circle),
          ),
        ],
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleControler,
                decoration: InputDecoration(
                  labelText: 'Input Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Title Harus Diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                maxLines: 5,
                controller: contentControler,
                decoration: InputDecoration(
                  labelText: 'Input Content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Content Harus Diisi';
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
