import 'package:balmart/splashscreenpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'models/cart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey =
      "pk_test_51TKs97Fmze0sdQs3cRLf58nLTZ5w3R4QjLaHtyutEtZdyQ7s0Dog0yOu70gTawYI75BDp24irkhnRC9SR2oPXy7x00lTRGLF7E";
  Stripe.instance.applySettings();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BalmartSplashScreen()
    ),
  );
}
