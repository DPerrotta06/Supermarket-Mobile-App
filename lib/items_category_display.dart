import 'package:balmart/cartpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:balmart/models/cart.dart';
import 'package:provider/provider.dart';
import 'package:balmart/models/item.dart';
import 'package:flutter/material.dart';
import 'package:balmart/l10n/app_localizations.dart';


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

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    // Get Localization instance
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          backgroundColor: widget.headerColor,
          title: Text(
            '${widget.category[0].toUpperCase()}${widget.category.substring(1)} ${l10n.translate('section')}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              fontSize: 25,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CartPage()),
                );
              },
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
                  hintText: l10n.translate('searchItem'),
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
            return Center(child: Text(l10n.translate('noItemsFound')));
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
              final itemId = docs[index].id;
              final item = Item(
                id: itemId,
                name: data['name'] ?? '',
                price: (data['price'] as num).toDouble(),
                imageURL: data['imageUrl'] ?? '',
                category: data['category'] ?? '',
                quantity: data['quantity'] != null ? (data['quantity'] as num).toDouble() : null,
                size: data['size'] is List ? (data['size'] as List).join(', ') : data['size']?.toString(),
              );
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
                      '${l10n.translate('price')}: \$${data['price']}',
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
              widget.category == 'Alcohol'
              ? '${l10n.translate('qty')}: ${data['quantity'] ?? l10n.translate('naValue')} L'
                  : widget.category == 'Clothing'
              ? '${l10n.translate('size')}: ${data['size'] ?? l10n.translate('naValue')}'
                  : '${l10n.translate('qty')}: ${data['quantity'] ?? l10n.translate('naValue')} Kg',
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
                          _counterButton('+', () => cart.increment(item)),
                          SizedBox(width: 6),
                          Text('${cart.getQuantity(itemId)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 6),
                          _counterButton('-', () => cart.decrement(itemId)),
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
