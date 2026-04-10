import 'package:balmart/models/item.dart';

class Cart {
  final String userId;
  final List<Item> items;

  Cart({required this.userId, required this.items});

  double getTotal() {
    return items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }
}
