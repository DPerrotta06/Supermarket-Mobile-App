import 'package:flutter/material.dart';

import 'loginpage.dart';

class BalmartSplashScreen extends StatefulWidget {
  const BalmartSplashScreen({super.key});

  @override
  State<BalmartSplashScreen> createState() => _BalmartSplashScreenState();
}

class _BalmartSplashScreenState extends State<BalmartSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 6), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orangeAccent,
              Colors.lightGreenAccent,
              Colors.lightBlueAccent,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                'assets/images/Balmart_Background.jpg',
                width: 330,
              ),
            ),
            SizedBox(height: 60),
            Text(
              'All your shopping, in one place! \n \u{1F6D2} \u{1F6CD}',
              //unicode characters
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                fontSize: 30,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 60),
            CircularProgressIndicator(
              backgroundColor: Colors.green,
              valueColor: AlwaysStoppedAnimation(Colors.orangeAccent),
            ),
          ],
        ),
      ),
    );
  }
}
