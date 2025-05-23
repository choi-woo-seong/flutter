import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/bottom_navigation.dart';

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
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final res = await http.get(
        Uri.parse("http://192.168.0.83:8081/api/cart"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(res.bodyBytes));
        setState(() {
          cart = data.map((item) => Map<String, dynamic>.from(item)).toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        print("❌ 장바구니 불러오기 실패: ${res.statusCode}");
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("❌ 예외 발생: $e");
    }
  }

  Future<void> removeFromCart(int productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final res = await http.delete(
        Uri.parse("http://192.168.0.83:8081/api/cart/$productId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        setState(() => cart.removeWhere((item) => item['productId'] == productId));
      }
    } catch (e) {
      print("❌ 삭제 실패: $e");
    }
  }

  Future<void> updateQuantity(int productId, int newQty) async {
    if (newQty < 1) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final res = await http.put(
        Uri.parse("http://192.168.0.83:8081/api/cart"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "productId": productId,
          "quantity": newQty,
        }),
      );

      if (res.statusCode == 200) {
        print("✅ 수량 변경 성공: $newQty");
        await fetchCartItems();
      } else {
        print("❌ 수량 변경 실패 코드: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ 수량 변경 예외 발생: $e");
    }
  }

  int calculateTotal() {
    return cart.fold(0, (total, item) {
      final price = (item['unitPrice'] is num)
          ? (item['unitPrice'] as num).toInt()
          : double.tryParse(item['unitPrice'].toString())?.toInt() ?? 0;
      final quantity = int.tryParse(item['quantity'].toString()) ?? 0;
      return total + (price * quantity);
    });
  }

  String formatPrice(int price) {
    return NumberFormat('#,###').format(price) + '원';
  }

  void clearCart() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("전체 삭제"),
        content: Text("장바구니의 모든 항목을 삭제하시겠습니까?"),
        actions: [
          // 취소 버튼 글씨 검정으로 스타일 적용
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, // 텍스트 검정
            ),
            child: Text("취소"),
          ),
          TextButton(
            onPressed: () async {
              try {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('accessToken') ?? '';
                final res = await http.delete(
                  Uri.parse("http://192.168.0.83:8081/api/cart"),
                  headers: {"Authorization": "Bearer $token"},
                );
                if (res.statusCode == 200) {
                  setState(() => cart.clear());
                }
              } catch (e) {
                print("❌ 전체 삭제 실패: $e");
              }
              Navigator.pop(context);
            },
            child: Text("삭제", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("장바구니"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: cart.isEmpty ? null : clearCart,
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cart.isEmpty
          ? Center(child: Text("장바구니가 비어 있습니다."))
          : ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final item = cart[index];
          final name = item['productName'] ?? "이름 없음";
          final price = (item['unitPrice'] is num)
              ? (item['unitPrice'] as num).toInt()
              : double.tryParse(item['unitPrice'].toString())?.toInt() ?? 0;
          final quantity = int.tryParse(item['quantity'].toString()) ?? 0;
          final imageUrl = item['imageUrls'] != null && item['imageUrls'].isNotEmpty
              ? item['imageUrls'][0]
              : null;

          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imageUrl != null
                      ? Image.network(imageUrl, width: 50, height: 50)
                      : Icon(Icons.image_not_supported),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(formatPrice(price * quantity),
                                style: TextStyle(fontSize: 14)),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: quantity > 1
                                  ? () => updateQuantity(item['productId'], quantity - 1)
                                  : null,
                            ),
                            Text('$quantity'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () =>
                                  updateQuantity(item['productId'], quantity + 1),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () =>
                                  removeFromCart(item['productId']),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: cart.isEmpty
                  ? null
                  : () {
                Navigator.pushNamed(context, '/cart-success');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text("총 결제금액: ${formatPrice(calculateTotal())} - 주문하기"),
            ),
          ),
          BottomNavigation(currentIndex: 2),
        ],
      ),
    );
  }
}
