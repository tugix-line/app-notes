import 'package:app_notes/auth/login_screen.dart';
import 'package:app_notes/database/database_help.dart';
import 'package:app_notes/models/user_model.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  bool isVisiblePass = false;
  bool isVisibleConfirmPass = false;
  final formKey = GlobalKey<FormState>();
  final db = DatabaseHelper();

  Future<void> register() async {
    try {
      int result = await db.register(
        UserModel(
          userName: userController.text,
          userPassword: passController.text,
        ),
      );
      if (!mounted) return;
      if (result > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrasi Berhasil', textAlign: TextAlign.center),
            backgroundColor: Colors.green[300],
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Registrasi Gagal. Silahkan Coba Kembali',
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
            'Terjadi Kesalahan Pada Proses Registrasi',
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
            padding: EdgeInsets.all(22),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, size: 120, color: Colors.teal),
                  ListTile(
                    title: Center(
                      child: Text(
                        'REGISTRASI ACCOUNT',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: userController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Input Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Username Harus Diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: passController,
                    obscureText: !isVisiblePass,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Input Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisiblePass = !isVisiblePass;
                          });
                        },
                        icon: Icon(
                          isVisiblePass
                              ? Icons.visibility
                              : Icons.visibility_off,
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
                  SizedBox(height: 10),
                  TextFormField(
                    controller: confirmPassController,
                    obscureText: !isVisibleConfirmPass,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisibleConfirmPass = !isVisibleConfirmPass;
                          });
                        },
                        icon: Icon(
                          isVisibleConfirmPass
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Confirm Password Harus Diisi';
                      } else if (passController.text !=
                          confirmPassController.text) {
                        return 'Password Tidak Sama';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                    height: 55,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          register();
                        }
                      },
                      label: Text(
                        'Registrasi Account',
                        style: TextStyle(fontSize: 20),
                      ),
                      icon: Icon(Icons.person_add),
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
                        'Sudah Memiliki Account? Silahkan',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
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
