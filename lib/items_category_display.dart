import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemsCategoryDisplay extends StatefulWidget {
  final String category;
  final Color headerColor;

  const ItemsCategoryDisplay({
    super.key,
    required this.category,
    required this.headerColor,
  });

  @override
  State<ItemsCategoryDisplay> createState() => _ItemsCategoryDisplayState();
}

class _ItemsCategoryDisplayState extends State<ItemsCategoryDisplay> {
  String _itemSearch = '';
  final TextEditingController _searchController = TextEditingController();
  final Map<String, int> _itemCounters = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          backgroundColor: widget.headerColor,
          title: Text(
            '${widget.category[0].toUpperCase()}${widget.category.substring(1)} Section',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              fontSize: 25,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.shopping_cart_sharp, color: Colors.white),
            ),
          ],
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(36),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Search for an item here',
                  hintStyle: TextStyle(fontFamily: 'Poppins'),
                  prefixIcon: Icon(Icons.search, color: Colors.amber),
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(90),
                    borderSide: BorderSide(color: Colors.black54, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onChanged: (value) => setState(() {
                  _itemSearch = value;
                }),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('items')
            .where('category', isEqualTo: widget.category)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
                valueColor: AlwaysStoppedAnimation(Colors.orangeAccent),
              ),
            );
          }
          var docs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return (data['name'] ?? '').toString().toLowerCase().contains(
              _itemSearch.toLowerCase(),
            );
          }).toList();
          if (docs.isEmpty) {
            return const Center(child: Text('No items found.'));
          }
          return GridView.builder(
            padding: EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.5,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return Card(
                color: Colors.lightBlueAccent,
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(12),
                          child: Image.network(
                            data['imageUrl'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      data['name'] ?? '',
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Price: \$${data['price']}',
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.category == 'Alcohol'
                          ? 'Qty: ${data['quantity'] ?? 'N/A'} L'
                          : widget.category == 'Clothing'
                          ? 'Size: ${data['size'] ?? 'N/A'}'
                          : 'Qty: ${data['quantity'] ?? 'N/A'} g',
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontFamily: 'Poppins',
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _counterButton('+', () => _increment(docs[index].id)),
                          SizedBox(width: 6),
                          Text('${_itemCounters[docs[index].id] ?? 0}'),
                          SizedBox(width: 6),
                          _counterButton('-', () => _decrement(docs[index].id)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _increment(String itemId) => setState(() {
    _itemCounters[itemId] = (_itemCounters[itemId] ?? 0) + 1;
  });

  void _decrement(String itemId) => setState(() {
    (_itemCounters[itemId] ?? 0) > 0
        ? _itemCounters[itemId] = _itemCounters[itemId]! - 1
        : _itemCounters[itemId] = 0;
  });

  Widget _counterButton(String label, VoidCallback onPress) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: 40,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          color: Colors.green,
          borderRadius: BorderRadius.circular(50),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            color: Colors.orange,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
