import 'package:balmart/about_us_and_contact_info.dart';
import 'package:balmart/loginpage.dart';
import 'package:balmart/shoppingpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Needed for auto scroll timer
import 'package:balmart/l10n/app_localizations.dart';
import 'package:balmart/balmartapp.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Control which carousel page is shown
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  Widget _promoCard(IconData icon, Color color, String title, String subtitle) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        // withOpacity is deprecated in newer Flutter versions, withValues is the replacement
        color: color.withValues(alpha: 0.1), // make color transparent
        borderRadius: BorderRadius.circular(12),
        // withOpacity is deprecated in newer Flutter versions, withValues is the replacement
        border: Border.all(color: color.withValues(alpha: 0.4)), // make color transparent
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 40),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

   List<Map<String, dynamic>> _carouselItems(AppLocalizations l10n) => [
    {
      'label': l10n.translate('fruits'),
      'color': Colors.red,
      'icon': Icons.apple,
      'image':
          'https://th.bing.com/th/id/OIP.j1_y6Mjvzy5ORzCzm5GVHQHaGt?w=192&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',
    },
    {
      'label': l10n.translate('vegetables'),
      'color': Colors.green,
      'icon': Icons.eco,
      'image':
          'https://img.freepik.com/premium-vector/lettuce-clipart-vector-illustration_1123392-3227.jpg',
    },
    {
      'label': l10n.translate('meat'),
      'color': Colors.brown,
      'icon': Icons.set_meal,
      'image':
          'https://th.bing.com/th/id/OIP.BfKddISssH6KGYU57yfBmwHaHa?w=166&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',
    },
    {
      'label': l10n.translate('dairy'),
      'color': Colors.lightBlue,
      'icon': Icons.water_drop,
      'image':
          'https://th.bing.com/th/id/OIP.j6EPid9FooOOEi1gdzHIGAHaHa?w=236&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',
    },
    {
      'label': l10n.translate('desserts'),
      'color': Colors.pink,
      'icon': Icons.cookie,
      'image':
          'https://th.bing.com/th/id/OIP.kGc5E2v8xqhEnsj7IpZ6bgHaJQ?w=186&h=233&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',
    },
    {
      'label': l10n.translate('snacks'),
      'color': Colors.orange,
      'icon': Icons.restaurant,
      'image':
          'https://th.bing.com/th?q=Salt+and+Vinegar+Chips&w=120&h=120&c=1&rs=1&qlt=70&o=7&cb=1&dpr=1.3&pid=InlineBlock&rm=3&mkt=en-CA&cc=CA&setlang=en&adlt=moderate&t=1&mw=247',
    },
    {
      'label': l10n.translate('alcohol'),
      'color': Colors.purple,
      'icon': Icons.local_bar,
      'image':
          'https://www.acouplecooks.com/wp-content/uploads/2021/08/Jagermeister-Drink-009.jpg',
    },
    {
      'label': l10n.translate('toiletries'),
      'color': Colors.teal,
      'icon': Icons.bathroom,
      'image':
          'https://th.bing.com/th/id/OIP.4tELCduBYOCFPPcWPD9vqwHaHa?w=196&h=196&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',
    },
    {
      'label': l10n.translate('clothing'),
      'color': Colors.indigo,
      'icon': Icons.checkroom,
      'image':
          'https://th.bing.com/th/id/OIP.zUnMfAhyxVjUzz7BqQk4YAHaHa?w=186&h=186&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',
    },
    {
      'label': l10n.translate('medicine'),
      'color': Colors.blueGrey,
      'icon': Icons.medical_services,
      'image':
          'https://th.bing.com/th/id/OIP.zFlm1iZaH13h5_V1evj-VwHaHa?w=171&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',
    },
  ];

  @override
  void initState() {
    super.initState();
    // auto scrolls carousel every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentPage < 10 - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // loops back to start
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    // Cancel timer when page closes to avoid memory leaks
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  String getName(String str) {
    String name = str.split('@')[0]; // get par before the @
    name = name.replaceAll(RegExp(r'[0-9]'), ''); // remove numbers
    name = name.replaceAll(RegExp(r'[._]'), ' '); // dots and underscore gives a space
    if (name.isEmpty) return '?';
    if (name.length > 8) {
      name = name.substring(0,8);
    }
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    // Get currently logged in user from Firebase
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';
    final name = getName(email);

    // Get localization instance
    final l10n = AppLocalizations.of(context);

    // Carousel built with translations
    final carouselItems = _carouselItems(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.translate('homePage'),
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Scrollable container
        child: Column(
        children: [
          SizedBox(height: 15),
          // Carousel Title
          Text(
            l10n.translate('featuredCategories'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 15),
          // Carousel Auto scrolls every 5 seconds
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: carouselItems.length,
              itemBuilder: (context, index) {
                final item = carouselItems[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: item['color'],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      // Clips image to match rounded corners
                      borderRadius: BorderRadiusGeometry.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Image loaded from internet URL
                          Image.network(
                            item['image'],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              // Spinner while image loads
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              // Falls back to icon if image fails to load
                              return Center(
                                child: Icon(
                                  item['icon'],
                                  size: 80,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                          // Dark gradient overlay so label text is readable
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  // withOpacity is deprecated in newer Flutter versions, withValues is the replacement
                                  Colors.black.withValues(alpha: 0.6), // make color transparent
                                ],
                              ),
                            ),
                          ),
                          // Category label at bottom of card
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: Text(
                              item['label'],
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          // Dot indicators showing current carousel page
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              carouselItems.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 12 : 8,
                height: _currentPage == index ? 12 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.amber : Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Promotion Section
          Text(
            l10n.translate('promotions'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _promoCard(Icons.local_shipping, Colors.green, l10n.translate('freeDelivery'), l10n.translate('ordersOver100')),
                _promoCard(Icons.local_bar, Colors.purple, l10n.translate('alcoholDeal'), l10n.translate('alcoholDealDesc')),
                _promoCard(Icons.checkroom, Colors.orange, l10n.translate('clothingDeal'), l10n.translate('clothingDealDesc')),
                _promoCard(Icons.medical_services, Colors.red, l10n.translate('medicineDeal'), l10n.translate('medicineDealDesc')),
              ],
            ),
          ),
          // Start shopping Button
          ElevatedButton(
            onPressed: () {
              // Navigate to Shopping Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ShoppingPage())
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              elevation: 10,
              shadowColor: Colors.deepOrangeAccent,
              fixedSize: Size(200, 65),
            ),
            child: Text(
              l10n.translate('startShopping'),
              textAlign: TextAlign.center,
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
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(name), // shows parsed name
              accountEmail: Text(email), // shows full email below name
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.deepOrangeAccent,
                // Show first letter of name as avatar
                child: Text(
                  name.isNotEmpty ? name[0] : '?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.contact_mail, color: Colors.amber),
              title: Text(
                l10n.translate('aboutUsContact'),
                style: TextStyle(
                  color: Colors.teal,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Close drawer first
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AboutUsAndContactInfo(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.language, color: Colors.amber),
              title: Text(
                l10n.translate('language'),
                style: TextStyle(
                  color: Colors.teal,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: DropdownButton<String>(
                  value: Localizations.localeOf(context).languageCode,
                  underline: SizedBox(),
                  items: [
                    DropdownMenuItem(value: 'en', child: Text('🇨🇦 English')),
                    DropdownMenuItem(value: 'fr', child: Text('🇫🇷 Français')),
                    DropdownMenuItem(value: 'it', child: Text('🇮🇹 Italiano')),
                    DropdownMenuItem(value: 'de', child: Text('🇩🇪 Deutsch')),
                    DropdownMenuItem(value: 'ru', child: Text('🇷🇺 Русский')),
                    DropdownMenuItem(value: 'hr', child: Text('🇭🇷 Hrvatski')),
                    DropdownMenuItem(value: 'ja', child: Text('🇯🇵 日本語')),
                    DropdownMenuItem(value: 'es', child: Text('🇪🇸 Español')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      BalmartApp.setLocale(context, Locale(value));
                    }
                  }
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.pink),
              title: Text(
                l10n.translate('logout'),
                style: TextStyle(
                  color: Colors.teal,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                // Signs out from Firebase
                await FirebaseAuth.instance.signOut();

                // Goes back to login page and removes all previous screens
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false, // removes everything from stack
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
