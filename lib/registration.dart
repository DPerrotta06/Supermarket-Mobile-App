import 'package:balmart/homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'balmartapp.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool isValidEmail(String email) {
  if (email.length < 10) {
    return false;
  }
  final reg = RegExp(r'^[A-Za-z0-9]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
  return reg.hasMatch(email);
}

bool isValidPassword(String pass) {
  final reg = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)(?=(?:.*[!#$%^&*.?":{}|<>]){2,}).{8,16}$',
  ); //NEEDS TO BE FIXED
  return reg.hasMatch(pass);
}

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotVisible = true;

  void show(String str, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          str,
          style: TextStyle(
            color: color,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    String email = emailController.text.trim();
    String pass = passwordController.text.trim();

    // Email Validate
    if (!isValidEmail(email)) {
      show("Invalid Email Format!!!", Colors.red);
      return;
    }

    // Password Validate
    if (!isValidPassword(pass)) {
      show(
        "Password Must Be 8-16 Characters Long with Letters, Numbers & Two Special Characters",
        Colors.red,
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      show('Account Created Successfully', Colors.green);

      // Go to home page
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      }
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'email-already-in-use') {
        show('Email Already Registered!!!', Colors.orange);
      } else if (ex.code == 'weak-password') {
        show('Password too weak!!!', Colors.orange);
      } else {
        show('Registration Failed!!!', Colors.red);
      }
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      ); // Go back one screen (AKA Login Screen)
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  ),
                ),
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
                      onPressed: registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        elevation: 10,
                        shadowColor: Colors.deepOrange,
                        fixedSize: Size(150, 50),
                      ),
                      child: Text(
                        'Register',
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
