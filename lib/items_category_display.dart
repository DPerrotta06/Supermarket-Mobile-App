import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models/item.dart';

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
  late Future<List<Item>> futureItems;

  @override //initialize the futureItems that are coming from the database because they can always update
  void initState() {
    super.initState();
    futureItems = _fetchItems();
  }

  //reading items from the database
  Future<List<Item>> _fetchItems() async {
    final response = await FirebaseFirestore.instance
        .collection('items')
        .where('category', isEqualTo: widget.category)
        .get();
    return response.docs
        .map(
          (itemData) => Item(
            id: itemData.id,
            name: itemData['name'],
            price: itemData['price'],
            imageURL: itemData['imageURL'],
            category: itemData['category'],
            quantity: itemData['quantity'],
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          backgroundColor: widget.headerColor,
          title: Text(
            //to make first letter uppercase of the desired produce section
            '${widget.category[0].toUpperCase()}${widget.category.substring(1)} Section',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              fontSize: 25,
            ),
          ),
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
      body: FutureBuilder<List<Item>>(
        future: futureItems,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var items = snapshot.data!
                .where(
                  (item) => item.name.toLowerCase().contains(
                    _itemSearch.toLowerCase(),
                  ),
                )
                .toList();
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(15),
                  child: ListTile(
                    leading: Image.network(snapshot.data![index].imageURL),
                    title: Text(
                      snapshot.data![index].name,
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    subtitle: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Price: \$${snapshot.data![index].price}',
                            style: TextStyle(
                              color: Colors.amberAccent,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          TextSpan(
                            text: 'Qty: ${snapshot.data![index].quantity}g',
                            style: TextStyle(
                              color: Colors.amberAccent,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _counterButton(
                          '+',
                          () => _increment(snapshot.data![index].id),
                        ),
                        Text('${_itemCounters[snapshot.data![index].id] ?? 0}'),
                        _counterButton(
                          '-',
                          () => _decrement(snapshot.data![index].id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  void _increment(String itemId) => setState(() {
    _itemCounters[itemId] = (_itemCounters[itemId] ?? 0) + 1;
  });

  void _decrement(String itemId) => setState(() {
    ((_itemCounters[itemId] ?? 0) > 0)
        ? _itemCounters[itemId] = (_itemCounters[itemId]! - 1)
        : _itemCounters[itemId] = 0;
  });

  Widget _counterButton(String label, VoidCallback onPress) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: 40,
        height: 30,
        decoration: BoxDecoration(border: Border.all(color: Colors.green)),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            color: Colors.orangeAccent,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
