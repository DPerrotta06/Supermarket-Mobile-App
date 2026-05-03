import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:balmart/l10n/app_localizations.dart';

class TwoFactorAuth extends StatefulWidget {
  final String email;
  final String code;

  const TwoFactorAuth({super.key, required this.email, required this.code});

  @override
  State<TwoFactorAuth> createState() => _TwoFactorAuthState();
}

class _TwoFactorAuthState extends State<TwoFactorAuth> {
  final _codeController = TextEditingController();

  bool _verifyCode() => _codeController.text.trim() == widget.code;

  @override
  Widget build(BuildContext context) {
    // Get localization instance
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          centerTitle: true,
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Bal',
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    fontSize: 35,
                  ),
                ),
                TextSpan(
                  text: 'mart',
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
      ),
      backgroundColor: Colors.orangeAccent,
      body: Padding(
        padding: EdgeInsets.all(18),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  '${l10n.translate('enterCode')} ${widget.email}:',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                  controller: _codeController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blueAccent,
                    labelText: l10n.translate('code'),
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(180),
                      borderSide: BorderSide(color: Colors.white70, width: 3.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(180),
                      borderSide: BorderSide(color: Colors.blue, width: 3.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => (_verifyCode() == true)
                      ? Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomePage()),
                        )
                      : ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              textAlign: TextAlign.center,
                              l10n.translate('tryAgain'),
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    elevation: 10,
                    shadowColor: Colors.deepOrange,
                    fixedSize: Size(150, 50),
                  ),
                  child: Text(
                    l10n.translate('proceed'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                SizedBox(height: 40),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    textAlign: TextAlign.center,
                    l10n.translate('requestNewCode'),
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.lightBlueAccent,
                      decorationThickness: 2.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
