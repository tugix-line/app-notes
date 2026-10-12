import 'package:app_notes/auth/login_screen.dart';
import 'package:app_notes/database/database_help.dart';
import 'package:app_notes/models/note_model.dart';
import 'package:app_notes/notes/create_note.dart';
import 'package:app_notes/notes/update_note.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late DatabaseHelper handler;
  late Future<List<NoteModel>> notes;

  final searchController = TextEditingController();
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    handler = DatabaseHelper();
    notes = handler.getNotes();
  }

  void showDeleteDialog(BuildContext pageContext, int noteId) {
    showDialog(
      context: pageContext,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete Notes'),
        content: Text('Yakin Data Akan Dihapus?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final int result = await handler.deleteNote(noteId);
              if (!mounted) return;
              if (result > 0) {
                setState(() {
                  notes = handler.getNotes();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Data Berhasil Dihapus',
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.green[500],
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Gagal Menghapus Data',
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.red[500],
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: Text('Delete', style: TextStyle(color: Colors.red[500])),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('App Notes', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search Your Notes...',
                  icon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchKeyword = value.trim();
                    if (_searchKeyword.isEmpty) {
                      notes = handler.getNotes();
                    } else {
                      notes = handler.searchNote(_searchKeyword);
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder<List<NoteModel>>(
                future: notes,
                builder:
                    (
                      BuildContext context,
                      AsyncSnapshot<List<NoteModel>> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error : ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('Data Tidak Ada'));
                      } else {
                        final items = snapshot.data!;
                        return ListView.builder(
                          itemCount: items.length,
                          padding: EdgeInsets.all(14),
                          itemBuilder: (context, index) {
                            final note = items[index];
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              margin: EdgeInsets.symmetric(vertical: 6),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                elevation: 4,
                                shadowColor: Colors.black.withValues(
                                  alpha: 0.2,
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  title: Text(
                                    note.noteTitle,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    DateFormat(
                                      "dd MMM yyyy",
                                    ).format(DateTime.parse(note.createdAt)),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UpdateNoteScreen(note: note),
                                      ),
                                    );
                                  },
                                  trailing: IconButton(
                                    onPressed: () {
                                      showDeleteDialog(
                                        context,
                                        items[index].noteId!,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[300],
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CreateNoteScreen()),
          );
        },
        child: Icon(Icons.post_add_outlined, color: Colors.white),
      ),
    );
  }
}
