import 'package:balmart/models/cart.dart';
import 'package:balmart/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:balmart/models/item.dart';
import 'package:balmart/l10n/app_localizations.dart';


class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  // Checks which promotions apply based on cart contents
  List<String> _getAppliedPromotions(List<Map<String, dynamic>> items, AppLocalizations l10n) {
    List<String> applied = [];

    // Free delivery if total over $100
    double originalTotal = items.fold(
      0,
      (sum,item) => sum + (item['item'] as Item).price * (item['cartQty'] as int? ?? 0));
    if (originalTotal >= 100) {
      applied.add(l10n.translate('freeDelivery'));
    }

    // Count alcohol units
    int alcoholCount = items
        .where((item) => (item['item'] as Item).category == 'Alcohol')
        .fold(0, (sum,item) => sum + (item['cartQty'] as int? ?? 0));
    if (alcoholCount >= 3) {
      applied.add(l10n.translate('alcoholDeal'));
    }

    // Count Clothing units
    int clothingCount = items
        .where((item) => (item['item'] as Item).category == 'Clothing')
        .fold(0, (sum,item) => sum + (item['cartQty'] as int? ?? 0));
    if(clothingCount >= 2) {
      applied.add(l10n.translate('clothingDeal'));
    }

    // Count Medicine
    int medicineCount = items
        .where((item) => (item['item'] as Item).category == 'Medicine')
        .fold(0, (sum,item) => sum + (item['cartQty'] as int? ?? 0));
    if (medicineCount >= 3) {
      applied.add(l10n.translate('medicineDeal'));
    }
    return applied;
  }

  // Calculate discounted total
  double _getDiscountedTotal(List<Map<String, dynamic>> items, double originalTotal) {
    double discount = 0;

    // Alcohol
    final alcoholItems = items
        .where((item) => (item['item'] as Item).category == 'Alcohol')
        .toList();
    int alcoholCount = alcoholItems.fold(0, (sum, item) => sum + (item['cartQty'] as int? ?? 0));
    if (alcoholCount >= 3) {
      double cheapest = alcoholItems
          .map((e) => (e['item'] as Item).price)
          .reduce((a, b) => a < b ? a : b);
      discount += cheapest;
    }

    // Clothing
    final clothingItems = items
        .where((item) => (item['item'] as Item).category == 'Clothing')
        .toList();
    int clothingCount = clothingItems.fold(0, (sum, item) => sum + (item['cartQty'] as int? ?? 0));
    if (clothingCount >= 2) {
      double cheapest = clothingItems
          .map((e) => (e['item'] as Item).price)
          .reduce((a, b) => a < b ? a : b);
      discount += cheapest;
    }

    // Medicine
    final medicineItems = items
        .where((item) => (item['item'] as Item).category == 'Medicine')
        .toList();
    int medicineCount = medicineItems.fold(0, (sum, item) => sum + (item['cartQty'] as int? ?? 0));
    if (medicineCount >= 3) {
      double cheapest = medicineItems
          .map((e) => (e['item'] as Item).price)
          .reduce((a, b) => a < b ? a : b);
      discount += cheapest;
    }
    return originalTotal - discount;
  }

  // Shipping for orders under $100 ($5.99 standard)
  double _getShipping(double subtotal) {
    return subtotal >= 100 ? 0.0 : 5.99;
  }

  // Quebec Tax (15%)
  double _getTax(double subtotal) {
    return subtotal * 0.15;
  }

  @override
  Widget build(BuildContext context) {
    // Watch cart so UI updates live
    final cart = Provider.of<Cart>(context);
    final items = cart.cartItems;
    final discountedTotal = _getDiscountedTotal(items, cart.total);
    // Get Localization instance
    final l10n = AppLocalizations.of(context);

    final appliedPromos = _getAppliedPromotions(items, l10n);
    final shipping = _getShipping(discountedTotal);
    final tax = _getTax(discountedTotal);
    final finalTotal = discountedTotal + shipping + tax;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.translate('myCart'),
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins'
            ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: items.isEmpty ? Center(
        child: Text(
          l10n.translate('cartEmpty'),
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins'
          ),
        ),
      ) : Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
              colors: [
                Colors.white,
                Colors.lightBlueAccent,
                Colors.lightGreenAccent,
                Colors.orangeAccent,
              ],
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context,index) {
            final entry = items[index];
            final item = entry['item'];
            final quantity = (entry['cartQty'] as int?) ?? 0;

            return Card(
              margin: EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.imageURL,
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported),
                  ),
                ),
                title: Text(
                  item.name,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '\$${item.price.toStringAsFixed(2)} x $quantity = \$${(item.price * quantity).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.green,
                  ),
                ),
                trailing: IconButton(
                  // remove item from cart
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => cart.removeItem(item.id),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        color: Colors.orangeAccent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // Show applied promos box if any promos
            if (appliedPromos.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.translate('appliedPromotions'),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    ...appliedPromos.map(
                          (promo) => Text(
                        promo,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],

            // Show original total crossed out if discount applied
            if (discountedTotal < cart.total)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.translate('original'),
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    '\$${cart.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: Colors.white70,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Colors.white70,
                    ),
                  ),
                ],
              ),

            // Discounted Subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.translate('subtotal'),
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '\$${discountedTotal.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            // Shipping Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.translate('shipping'),
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
                Text(
                  shipping == 0 ? l10n.translate('free') : '\$${shipping.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: shipping == 0 ? Colors.greenAccent : Colors.white,
                    fontWeight: shipping == 0 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),

            // Tax Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.translate('tax'),
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
                Text(
                  '\$${tax.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Divider(color: Colors.white54),

            // Final Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.translate('total'),
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '\$${finalTotal.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Checkout button goes to payment page
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shadowColor: Colors.deepOrangeAccent,
                    elevation: 15,
                  ),
                onPressed: items.isEmpty ? null : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PaymentPage(userCart: cart, discountedTotal: finalTotal)),
                    );
                },
                child: Text(
                  l10n.translate('proceedToCheckout'),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
