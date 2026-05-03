import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymentService {
  Future<String?> createPaymentIntent(double amount) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer ${dotenv.env['STRIPE_SECRET_KEY']!}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': (amount * 100).toInt().toString(),
          'currency': 'cad',
          'payment_method_types[]': 'card',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['client_secret'];
      } else {
        return null;
      }
    } catch (e) {
      print('Stripe error: $e');
      rethrow;
    }
  }

  Future<void> makePayment(double amount) async {
    try {
      final clientSecret = await createPaymentIntent(amount);
      if (clientSecret == null) {
        throw Exception('Failed to create payment intent');
      }
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "Balmart",
          style: ThemeMode.system,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print('Stripe error: $e');
      rethrow;
    }
  }
}
