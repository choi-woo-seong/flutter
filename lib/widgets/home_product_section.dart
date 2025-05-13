import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeProductSection extends StatefulWidget {
  @override
  _HomeProductSectionState createState() => _HomeProductSectionState();
}

class _HomeProductSectionState extends State<HomeProductSection> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final url = Uri.parse('http://192.168.0.83:8081/api/products');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(res.bodyBytes));
        setState(() {
          products = data.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        print("❌ 상품 불러오기 실패: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ 상품 요청 오류: $e");
    }
  }

  String resolveImageUrl(String url) {
    return url.startsWith('http') ? url : 'http://192.168.0.83:8081$url';
  }

  int toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("인기 제품 추천 상품", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ]),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("요양원 입소 전 준비하세요.",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/products'),
                    child: Text("스토어 바로가기 >", style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final discountPrice = toInt(product['discountPrice']);
                  final originalPrice = toInt(product['price']);
                  final discountPercent = originalPrice > 0
                      ? (100 - (discountPrice / originalPrice * 100)).round()
                      : 0;

                  final imageUrl = (product['images'] != null &&
                      product['images'] is List &&
                      product['images'].isNotEmpty)
                      ? resolveImageUrl(product['images'][0])
                      : '';

                  return Container(
                    width: 170,
                    margin: EdgeInsets.only(right: 12),
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/product-detail',
                          arguments: {'id': product['id']},
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                              child: imageUrl.isNotEmpty
                                  ? Image.network(
                                imageUrl,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                                  : Container(
                                height: 120,
                                color: Colors.grey.shade200,
                                child: Icon(Icons.image_not_supported),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(product['name'] ?? '',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        "${numberFormat.format(discountPrice)}원",
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "${numberFormat.format(originalPrice)}원",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            decoration: TextDecoration.lineThrough),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "$discountPercent% 할인",
                                    style: TextStyle(color: Colors.red, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
