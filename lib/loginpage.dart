import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:balmart/2fa.dart';
import 'package:balmart/password_reset.dart';
import 'package:balmart/registration.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotVisible = true;
  String generatedCode = '';

  Future<void> loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      generatedCode = (100000 + Random().nextInt(900000)).toString();
      final currentTime = DateTime.now();
      final time =
          '${currentTime.hour}:${currentTime.minute.toString().padLeft(2, '0')}';
      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': 'balmart_service',
          'template_id': 'template_gahyv96',
          'user_id': '49S6Xueh8U5XTz4Cw', //public key
          'accessToken': dotenv.env['EMAIL_JS_PRIVATE_KEY']!, //private key
          'template_params': {
            'to_email': email,
            'passcode': generatedCode,
            'time': time,
          },
        }),
      );
      print('EmailJS status: ${response.statusCode}');
      print('EmailJS body: ${response.body}');
      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TwoFactorAuth(email: email, code: generatedCode),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            textAlign: TextAlign.center,
            '$e',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }

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
                    TextField(
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      controller: emailController,
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
                    SizedBox(height: 30),
                    TextField(
                      style: TextStyle(color: Colors.white),
                      obscureText: _isNotVisible,
                      textAlign: TextAlign.center,
                      controller: passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blueAccent,
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () => setState(() {
                            _isNotVisible = !_isNotVisible;
                          }),
                          icon: Icon(
                            color: Colors.white,
                            _isNotVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
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
                      onPressed: loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        elevation: 10,
                        shadowColor: Colors.deepOrange,
                        fixedSize: Size(150, 50),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PasswordReset()),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          fontSize: 17,
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Registration()),
                        );
                      },
                      child: Text(
                        textAlign: TextAlign.center,
                        "Don't have an account?\nCreate one today!",
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          fontSize: 17,
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
