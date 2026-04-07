import 'package:flutter/material.dart';
import 'models/item.dart';

class ItemsCategoryDisplay extends StatefulWidget {
  final String category;
  final List<Item> items;

  const ItemsCategoryDisplay({
    required this.category,
    required this.items,
    super.key,
  });

  @override
  State<ItemsCategoryDisplay> createState() => _ItemsCategoryDisplayState();
}

class _ItemsCategoryDisplayState extends State<ItemsCategoryDisplay> {
  String itemSearch = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text(
            '$category Section',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              fontSize: 25,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Center(child: Column(children: [
      
      ])),
    );
  }
}
