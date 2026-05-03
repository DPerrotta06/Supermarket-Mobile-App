import 'dart:convert';
import 'package:balmart/homepage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'models/cart.dart';
import 'payment_service.dart';
import 'package:balmart/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class PaymentPage extends StatefulWidget {
  final Cart userCart;
  final double discountedTotal;

  const PaymentPage({
    super.key,
    required this.userCart,
    required this.discountedTotal,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _addressController = TextEditingController();
  bool _isLoading = false;
  final _uuid = const Uuid();
  late String _sessionToken;
  List<dynamic> locations = [];
  bool _listIsVisible = false;

  @override
  void initState() {
    super.initState();
    _sessionToken = _uuid.v4();
    _addressController.addListener(() {
      _locationSuggestion(_addressController.text);
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _locationSuggestion(String input) async {
    if (_listIsVisible) {
      _listIsVisible = false;
      return;
    }
    if (input.isEmpty) {
      setState(() => locations = []);
      return;
    }
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': input,
        'format': 'json',
        'limit': '10',
      });
      final response = await http.get(
        uri,
        headers: {'User-Agent': 'balmart-app'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          locations = data;
        });
      }
    } catch (e) {
      debugPrint('Maps Error: $e');
    }
  }

  void _selectLocation(String description) {
    _listIsVisible = true;
    _addressController.text = description;
    _addressController.selection = TextSelection.fromPosition(
      TextPosition(offset: description.length),
    );
    setState(() => locations = []);
  }

  Future<void> _handlePayment() async {
    final l10n = AppLocalizations.of(context);
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translate('fillShippingFields'))),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await PaymentService().makePayment(widget.discountedTotal);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.translate('paymentSuccess'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 15,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        );
        widget.userCart.clear();
        Future.delayed(
          Duration(seconds: 1),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.translate('paymentFailed'),
              textAlign: TextAlign.center,
              style: const TextStyle(
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
    final bool hasText = controller.text.isNotEmpty;
    final bool hasSuggestions = locations.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.lightBlueAccent, width: 4),
            ),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey,
                ),
                prefixIcon: Icon(icon, color: Colors.amber),
                suffixIcon: hasText
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          controller.clear();
                          setState(() => locations = []);
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          if (hasSuggestions)
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 250),
              child: Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListView.separated(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: locations.length,
                  separatorBuilder: (_, _) => const Divider(),
                  itemBuilder: (context, index) {
                    final place = locations[index];
                    final description = place['display_name'] ?? '';
                    final parts = description.split(',');
                    final mainText = parts.isNotEmpty
                        ? parts[0].trim()
                        : description;
                    final secondaryText = parts.length > 1
                        ? parts.skip(1).join(',').trim()
                        : '';
                    return ListTile(
                      leading: const Icon(
                        Icons.location_on,
                        color: Colors.lightBlueAccent,
                      ),
                      title: Text(
                        mainText,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: secondaryText.isNotEmpty
                          ? Text(
                              secondaryText,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            )
                          : null,
                      onTap: () => _selectLocation(description),
                    );
                  },
                ),
              ),
            ),
          if (!hasText && !hasSuggestions)
            Container(
              margin: const EdgeInsets.only(top: 22),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  shadowColor: Colors.deepOrangeAccent,
                  elevation: 10,
                ),
                onPressed: () {
                  _useMyLocation();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.my_location, color: Colors.amber),
                    SizedBox(width: 8),
                    Text(
                      'Use my location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled!');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied!');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions!',
      );
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _useMyLocation() async {
    try {
      final position = await _determinePosition();
      final uri = Uri.https('nominatim.openstreetmap.org', '/reverse', {
        'lat': position.latitude.toString(),
        'lon': position.longitude.toString(),
        'format': 'json',
      });
      final response = await http.get(
        uri,
        headers: {'User-Agent': 'balmart-app'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['display_name'] ?? '';
        _addressController.text = address;
        setState(() {
          locations = [];
        });
      }
    } catch (e) {
      debugPrint('Location Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
              style: TextStyle(color: Colors.red, fontSize: 22),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: l10n.translate('checkOut'),
                style: const TextStyle(
                  color: Colors.lightGreen,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 35,
                ),
              ),
              TextSpan(
                text: l10n.translate('checkOutSuffix'),
                style: const TextStyle(
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
        padding: const EdgeInsets.all(20),
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
                    ? const CircularProgressIndicator(
                        backgroundColor: Colors.green,
                        valueColor: AlwaysStoppedAnimation(Colors.orangeAccent),
                      )
                    : Text(
                        '${l10n.translate('pay')} \$${widget.discountedTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
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
                style: const TextStyle(
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
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lock,
                    color: Colors.lightBlueAccent,
                    size: 25,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      l10n.translate('paymentSecure'),
                      style: const TextStyle(
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
        padding: const EdgeInsets.all(20),
        child: Container(
          decoration: const BoxDecoration(
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
            padding: const EdgeInsets.all(18),
            children: [
              Text(
                l10n.translate('shippingAddress'),
                style: const TextStyle(
                  fontSize: 22,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              _buildAddressForm(
                _addressController,
                l10n.translate('streetAddress'),
                Icons.location_on,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
