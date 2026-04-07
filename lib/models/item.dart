class Item {
  final String name;
  final double price;
  final String imageURL;
  int quantity;

  Item({
    required this.name,
    required this.price,
    required this.imageURL,
    this.quantity = 0,
  });
}
