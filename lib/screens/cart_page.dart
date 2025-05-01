import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cart = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false;
        cart = [
          {
            'id': '1',
            'name': '실버워커 노인용 보행기',
            'price': 220000,
            'quantity': 1,
            'image': 'assets/images/supportive-stroll.png',
          },
          {
            'id': '2',
            'name': '의료용 실버워커',
            'price': 100000,
            'quantity': 2,
            'image': 'assets/images/elderly-woman-using-walker.png',
          },
        ];
      });
    });
  }

  void removeFromCart(String id) {
    setState(() {
      cart.removeWhere((item) => item['id'] == id);
    });
  }

  void updateQuantity(String id, int delta) {
    setState(() {
      final index = cart.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        cart[index]['quantity'] += delta;
        if (cart[index]['quantity'] < 1) cart[index]['quantity'] = 1;
      }
    });
  }

  int calculateTotal() {
    return cart.fold(0, (total, item) {
      final price = int.tryParse(item['price'].toString()) ?? 0;
      final quantity = int.tryParse(item['quantity'].toString()) ?? 0;
      return total + (price * quantity);
    });
  }

  String formatPrice(int price) {
    return NumberFormat('#,###').format(price) + '원';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('장바구니')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cart.isEmpty
          ? Center(child: Text("장바구니가 비어 있습니다."))
          : ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final item = cart[index];
          return Card(
            child: ListTile(
              leading: Image.asset(item['image'], width: 50, height: 50),
              title: Text(item['name']),
              subtitle: Text('${formatPrice(item['price'])}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => updateQuantity(item['id'], -1),
                  ),
                  Text('${item['quantity']}'),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => updateQuantity(item['id'], 1),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => removeFromCart(item['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: cart.isEmpty ? null : () {
            // 주문 처리 로직
          },
          child: Text("총 결제금액: ${formatPrice(calculateTotal())} - 주문하기"),
        ),
      ),
    );
  }
}
