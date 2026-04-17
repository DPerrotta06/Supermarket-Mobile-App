import 'package:flutter/material.dart';
import 'items_category_display.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  // All Categories
  final List<Map<String, dynamic>> categories = [
    {'label': 'Fruits', 'color': Colors.red, 'icon': Icons.apple},
    {'label': 'Vegetables', 'color': Colors.green, 'icon': Icons.eco},
    {'label': 'Meat', 'color': Colors.brown, 'icon': Icons.set_meal},
    {'label': 'Dairy', 'color': Colors.lightBlue, 'icon': Icons.local_drink},
    {'label': 'Desserts', 'color': Colors.pink, 'icon': Icons.cake},
    {'label': 'Snacks', 'color': Colors.orange, 'icon': Icons.lunch_dining},
    {'label': 'Alcohol', 'color': Colors.purple, 'icon': Icons.local_bar},
    {'label': 'Toiletries', 'color': Colors.teal, 'icon': Icons.bathroom},
    {'label': 'Clothing', 'color': Colors.indigo, 'icon': Icons.checkroom},
    {
      'label': 'Medicine',
      'color': Colors.blueGrey,
      'icon': Icons.medical_services,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
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
                      category: category['label'],
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
                    category['label'],
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
