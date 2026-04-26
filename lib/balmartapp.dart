import 'package:balmart/splashscreenpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:balmart/models/cart.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:balmart/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: '.env');
  Stripe.publishableKey =
      "pk_test_51TKs97Fmze0sdQs3cRLf58nLTZ5w3R4QjLaHtyutEtZdyQ7s0Dog0yOu70gTawYI75BDp24irkhnRC9SR2oPXy7x00lTRGLF7E";
  Stripe.instance.applySettings();
  runApp(
    // Wrap entire app with provider so cart is accessible from any screen
    ChangeNotifierProvider(create: (_) => Cart(
      // Gets current Firebase user ID for the cart
      userId: FirebaseAuth.instance.currentUser?.uid ?? '',
    ),
      child: BalmartApp(), // BalmartApp handles MaterialApp
    ),
  );
}

// BalmartApp owns the MaterialApp and locale state
class BalmartApp extends StatefulWidget {
  const BalmartApp({super.key});

  // static method so any screen can call BalmartApp.setLocale(context, locale)
  static void setLocale(BuildContext context, Locale newLocale) {
    final state = context.findAncestorStateOfType<_BalmartAppState>();
    state?.changeLocale(newLocale);
  }
  @override
  State<BalmartApp> createState() => _BalmartAppState();
}

class _BalmartAppState extends State<BalmartApp> {
  Locale _locale = Locale('en'); // Default English

  void changeLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale, // current locale
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('fr'),
        Locale('it'),
        Locale('de'), // German
        Locale('ru'),
        Locale('hr'), // Croatian
        Locale('ja'), // Japanese
        Locale('es'),
      ],
      home: BalmartSplashScreen(),
    );
  }
}

