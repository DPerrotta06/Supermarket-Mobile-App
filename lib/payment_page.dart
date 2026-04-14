import 'package:balmart/homepage.dart';
import 'package:flutter/material.dart';
import 'models/cart.dart';
import 'payment_service.dart';

class PaymentPage extends StatefulWidget {
  final Cart userCart;

  const PaymentPage({super.key, required this.userCart});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handlePayment() async {
    if (_streetController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _postalCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all shipping fields.')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await PaymentService().makePayment(
        widget.userCart.total,
      ); //AMOUNT MUST BE OVER 50 CENTS
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Payment was successful!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontSize: 15,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Payment cancelled or failed.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 15,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildAddressForm(
    TextEditingController controller,
    String hintText,
    IconData icon,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.lightBlueAccent, width: 4),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.amber),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Chec',
                style: TextStyle(
                  color: Colors.lightGreen,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 35,
                ),
              ),
              TextSpan(
                text: 'kout',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 35,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.orangeAccent,
      ),
      backgroundColor: Colors.orangeAccent,
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        color: Colors.orangeAccent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shadowColor: Colors.deepOrangeAccent,
                  elevation: 15,
                ),
                onPressed: _isLoading ? null : _handlePayment,
                child: _isLoading
                    ? CircularProgressIndicator(
                        backgroundColor: Colors.green,
                        valueColor: AlwaysStoppedAnimation(Colors.orangeAccent),
                      )
                    : Text(
                        'Pay \$${widget.userCart.total.toStringAsFixed(2)}',
                        //AMOUNT MUST BE OVER 50 CENTS
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HomePage()),
                );
              },
              child: Text(
                'Continue Shopping',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white70,
                  decorationThickness: 1.5,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock, color: Colors.lightBlueAccent, size: 25),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      'Your payment is secure and encrypted thanks to Stripe!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
          child: ListView(
            padding: EdgeInsets.all(18),
            children: [
              Text(
                'Shipping Address',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              _buildAddressForm(
                _streetController,
                'Street Address',
                Icons.location_on,
              ),
              _buildAddressForm(_cityController, 'City', Icons.location_city),
              _buildAddressForm(
                _postalCodeController,
                'Postal Code',
                Icons.local_post_office_sharp,
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
