import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsAndContactInfo extends StatefulWidget {
  const AboutUsAndContactInfo({super.key});

  @override
  State<AboutUsAndContactInfo> createState() => _AboutUsAndContactInfoState();
}

class _AboutUsAndContactInfoState extends State<AboutUsAndContactInfo> {

  // Initiate the phone library
  Future<void> _makeCall() async {
    final Uri uri = Uri(scheme: 'tel', path: '+15141234567');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _sendEmail() async {
    final Uri uri = Uri(scheme: 'mailto', path: 'balmart@gmail.com');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Widget _circleButton(IconData icon, Color color, VoidCallback onPressed) {
    return Ink(
      decoration: ShapeDecoration(color: color, shape: CircleBorder()),
      child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: Colors.white),
          iconSize: 24.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'About Us & Contact',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.amber,
          centerTitle: true
      ),
      body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              // About Us Section
              Text(
                'About Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 15),
              Text(
                'We are a company based in Montreal. Our Mission is to make shopping easier for everyone',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              Divider(),
              SizedBox(height: 15),
              // Contact Section
              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins'
                ),
              ),
              SizedBox(height: 15),
              // Circular Icon Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _circleButton(Icons.phone, Colors.lightBlue, _makeCall),
                  SizedBox(width: 15),
                  _circleButton(Icons.email, Colors.redAccent, _sendEmail),
                  SizedBox(width: 15),
                  _circleButton(Icons.facebook, Colors.indigo, () => _openLink('https://facebook.com')),
                  SizedBox(width: 15),
                  _circleButton(Icons.camera_alt, Colors.pink, () => _openLink('https://instagram.com')),
                ],
              ),
              SizedBox(height: 20),
              // Contact Info Rows
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(Icons.phone),
                    SizedBox(width: 5),
                    Text('+1 514-123-4567', textAlign: TextAlign.center),
                ]
              ),
              SizedBox(height: 10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(Icons.email),
                    SizedBox(width: 5),
                    Text('balmart@gmail.com', textAlign: TextAlign.center),
                ]
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on),
                  SizedBox(width: 5),
                  Text('Montreal, QC', textAlign: TextAlign.center),
                ],
              ),
            ],
          ),
      ),
    );
  }
}
