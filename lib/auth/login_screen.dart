import 'package:app_notes/auth/register_screen.dart';
import 'package:app_notes/database/database_help.dart';
import 'package:app_notes/models/user_model.dart';
import 'package:app_notes/notes/homepage.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  bool isVisible = false;
  final formKey = GlobalKey<FormState>();
  final db = DatabaseHelper();

  Future<void> login() async {
    try {
      var respon = await db.login(
        UserModel(
          userName: userController.text,
          userPassword: passController.text,
        ),
      );
      if (!mounted) return;
      if (respon == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Berhasil', textAlign: TextAlign.center),
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
              'Login Gagal. Silahkan Coba Kembali !',
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
            'Terjadi Kesalahan! Periksa Data Login Anda',
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('lib/images/login.png', width: 200),
                  SizedBox(height: 15),
                  Text(
                    'App Notes',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: userController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: 'Input Username',
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'UserName Harus Diisi';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: passController,
                      obscureText: !isVisible,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Input Password',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          icon: Icon(
                            isVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password Harus Diisi';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8, top: 8, right: 8),
                    height: 55,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      label: Text('Login', style: TextStyle(fontSize: 20)),
                      icon: Icon(Icons.login),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Belum Punya Account? Silahkan',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateAccount(),
                            ),
                          );
                        },
                        child: Text(
                          'Registrasi Akun',
                          style: TextStyle(fontSize: 16, color: Colors.teal),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
