import 'package:flutter/material.dart';
import 'items_category_display.dart';
import 'package:balmart/l10n/app_localizations.dart';


class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  // All Categories (Separate the Firestore key from the display label)
   List<Map<String, dynamic>> _getCategories(AppLocalizations l10n) => [
    {'label': l10n.translate('fruits'), 'firestoreKey': 'Fruit', 'color': Colors.red, 'icon': Icons.apple},
    {'label': l10n.translate('vegetables'), 'firestoreKey': 'Vegetable', 'color': Colors.green, 'icon': Icons.eco},
    {'label': l10n.translate('meat'), 'firestoreKey': 'Meat', 'color': Colors.brown, 'icon': Icons.set_meal},
    {'label': l10n.translate('dairy'), 'firestoreKey': 'Dairy', 'color': Colors.lightBlue, 'icon': Icons.local_drink},
    {'label': l10n.translate('desserts'), 'firestoreKey': 'Dessert', 'color': Colors.pink, 'icon': Icons.cake},
    {'label': l10n.translate('snacks'), 'firestoreKey': 'Snack', 'color': Colors.orange, 'icon': Icons.lunch_dining},
    {'label': l10n.translate('alcohol'), 'firestoreKey': 'Alcohol', 'color': Colors.purple, 'icon': Icons.local_bar},
    {'label': l10n.translate('toiletries'), 'firestoreKey': 'Toiletry', 'color': Colors.teal, 'icon': Icons.bathroom},
    {'label': l10n.translate('clothing'), 'firestoreKey': 'Clothing', 'color': Colors.indigo, 'icon': Icons.checkroom},
    {'label': l10n.translate('medicine'), 'firestoreKey': 'Medicine', 'color': Colors.blueGrey, 'icon': Icons.medical_services,},
  ];

  @override
  Widget build(BuildContext context) {
    // Get Localization instance
    final l10n = AppLocalizations.of(context);
    // Built with translations
    final categories = _getCategories(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.translate('categories'),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          // 2 columns
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2, // Controls height of each button
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ElevatedButton(
              onPressed: () {
                // Opens category items page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ItemsCategoryDisplay(
                      category: category['firestoreKey'], // Firestore key stays in English
                      // Match firestore category field
                      headerColor: category['color'],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: category['color'],
                elevation: 6,
                shadowColor: Colors.black45,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(category['icon'], size: 48, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    category['label'], // shows translated name
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
