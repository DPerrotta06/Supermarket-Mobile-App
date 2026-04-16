class Item {
  final String id;
  final String name;
  final double price;
  final String imageURL;
  final String category;
  final double? quantity;
  final String? size;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.imageURL,
    required this.category,
    required this.quantity,
    required this.size
  });
}
