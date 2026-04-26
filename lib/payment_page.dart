import 'package:balmart/homepage.dart';
import 'package:flutter/material.dart';
import 'models/cart.dart';
import 'payment_service.dart';
import 'package:balmart/l10n/app_localizations.dart';


class PaymentPage extends StatefulWidget {
  final Cart userCart;
  final double discountedTotal;

  const PaymentPage({super.key, required this.userCart, required this.discountedTotal});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handlePayment() async {
    // Get l10n before async gap so it works after awaits
    final l10n = AppLocalizations.of(context);
    if (_streetController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _postalCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translate('fillShippingFields'))),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await PaymentService().makePayment(
        widget.discountedTotal,
      ); //AMOUNT MUST BE OVER 50 CENTS
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.translate('paymentSuccess'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontSize: 15,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        );
        widget.userCart.clear(); // clears cart after payment
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.translate('paymentFailed'),
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
    // Get Localization instance
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: l10n.translate('checkOut'),
                style: TextStyle(
                  color: Colors.lightGreen,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 35,
                ),
              ),
              TextSpan(
                text: l10n.translate('checkOutSuffix'),
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
                  '${l10n.translate('pay')} \$${widget.discountedTotal.toStringAsFixed(2)}',
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
                l10n.translate('continueShopping'),
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
                      l10n.translate('paymentSecure'),
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
                l10n.translate('shippingAddress'),
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
                l10n.translate('streetAddress'),
                Icons.location_on,
              ),
              _buildAddressForm(_cityController, l10n.translate('city'), Icons.location_city),
              _buildAddressForm(
                _postalCodeController,
                l10n.translate('postalCode'),
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
