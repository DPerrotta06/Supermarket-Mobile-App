import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  bool _isValidPassword(String pass) {
    final reg = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=(?:.*[!#$%^&*.?":{}|<>]){2,}).{8,16}$',
    );
    return reg.hasMatch(pass);
  }

  Future<void> resetPassword() async {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            textAlign: TextAlign.center,
            'Please enter your email!',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
      );
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              textAlign: TextAlign.center,
              'Password reset email sent!\nCheck your inbox!',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      SnackBar(
        content: Text(
          textAlign: TextAlign.center,
          'An error occured: $e',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.white,
                Colors.lightBlueAccent,
                Colors.lightGreenAccent,
                Colors.orangeAccent,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Bal',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      TextSpan(
                        text: 'mart',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      'Enter your email to send a password reset:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      style: TextStyle(color: Colors.white),
                      controller: emailController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blueAccent,
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(180),
                          borderSide: BorderSide(
                            color: Colors.white70,
                            width: 3.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(180),
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 3.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        elevation: 10,
                        shadowColor: Colors.deepOrange,
                        fixedSize: Size(170, 60),
                      ),
                      child: Text(
                        'Send Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
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
    );
  }
}
