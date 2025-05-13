import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ProductDetailPage extends StatefulWidget {
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int quantity = 1;
  Map<String, dynamic>? product;
  List<Map<String, dynamic>> reviews = [];
  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;
  bool isInitialized = false;

  final numberFormat = NumberFormat("#,###", "ko_KR");

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic> && args.containsKey('id')) {
        final productId = args['id'];
        fetchProductDetail(productId);
        fetchReviews(productId);
        fetchQuestions(productId);
        isInitialized = true;
      } else {
        print("❌ 전달된 arguments가 null이거나 형식이 잘못되었습니다.");
        Navigator.pop(context);
      }
    }
  }

  Future<void> fetchProductDetail(int id) async {
    try {
      final res = await http.get(Uri.parse("http://192.168.0.83:8081/api/products/$id"));
      if (res.statusCode == 200) {
        setState(() {
          product = json.decode(utf8.decode(res.bodyBytes));
          isLoading = false;
        });
      }
    } catch (e) {
      print("❌ 상품 상세 오류: $e");
    }
  }

  Future<void> fetchReviews(int id) async {
    try {
      final res = await http.get(Uri.parse("http://192.168.0.83:8081/api/products/$id/reviews"));
      if (res.statusCode == 200) {
        setState(() {
          reviews = List<Map<String, dynamic>>.from(json.decode(utf8.decode(res.bodyBytes)));
        });
      }
    } catch (e) {
      print("❌ 리뷰 오류: $e");
    }
  }

  Future<void> fetchQuestions(int id) async {
    try {
      final res = await http.get(Uri.parse("http://192.168.0.83:8081/api/products/$id/questions"));
      if (res.statusCode == 200) {
        setState(() {
          questions = List<Map<String, dynamic>>.from(json.decode(utf8.decode(res.bodyBytes)));
        });
      }
    } catch (e) {
      print("❌ 문의 오류: $e");
    }
  }

  Future<void> addToCart(int productId, int quantity) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final res = await http.post(
        Uri.parse("http://192.168.0.83:8081/api/cart"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "productId": productId,
          "quantity": quantity,
        }),
      );

      if (res.statusCode == 200) {
        print("🛒 장바구니 담기 완료");
      } else {
        print("❌ 장바구니 실패: ${res.statusCode}");
        print("응답: ${res.body}");
      }
    } catch (e) {
      print("❌ 네트워크 오류: $e");
    }
  }

  void changeQuantity(int delta) {
    setState(() {
      quantity = (quantity + delta).clamp(1, 99);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _resolveImageUrl(String rawUrl) {
    if (rawUrl.startsWith('http')) return rawUrl;
    return "http://192.168.0.83:8081$rawUrl";
  }

  Widget buildStarDisplay(double rating) {
    return Row(
      children: List.generate(5, (i) => Icon(
        Icons.star,
        color: i < rating ? Colors.amber : Colors.grey[300],
        size: 18,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || product == null) {
      return Scaffold(
        appBar: AppBar(title: Text('제품 상세')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    double averageRating = reviews.isNotEmpty
        ? reviews.map((r) => r['rating'] as int).reduce((a, b) => a + b) / reviews.length
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(product!['name'] ?? '제품 상세'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          product!['images'] != null && product!['images'].isNotEmpty
              ? Image.network(
            _resolveImageUrl(product!['images'][0]),
            height: 200,
            fit: BoxFit.cover,
          )
              : SizedBox(height: 200, child: Icon(Icons.image, size: 100)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product!['name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  children: [
                    buildStarDisplay(averageRating),
                    SizedBox(width: 6),
                    Text("${averageRating.toStringAsFixed(1)}  (${reviews.length}개 리뷰)",
                        style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text("${numberFormat.format((product!['discountPrice'] as num).toInt())}원",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Text("${numberFormat.format((product!['price'] as num).toInt())}원",
                        style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        )),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text("수량:", style: TextStyle(fontSize: 16)),
                    IconButton(onPressed: () => changeQuantity(-1), icon: Icon(Icons.remove)),
                    Text("$quantity"),
                    IconButton(onPressed: () => changeQuantity(1), icon: Icon(Icons.add)),
                  ],
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: "상세정보"),
              Tab(text: "리뷰"),
              Tab(text: "문의"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Text(product!['description'] ?? '상품 설명이 없습니다.'),
                  ],
                ),
                _buildReviewTab(),
                _buildQuestionTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton.icon(
          icon: Icon(Icons.shopping_cart),
          label: Text("장바구니 담기"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 48),
          ),
          onPressed: () async {
            await addToCart(product!['id'], quantity);
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("장바구니에 담겼습니다"),
                content: Text("지금 장바구니로 이동하시겠습니까?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("계속 구경하기", style: TextStyle(color: Colors.black)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/cart');
                    },
                    child: Text("장바구니로 이동", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReviewTab() {
    if (reviews.isEmpty) return Center(child: Text("등록된 리뷰가 없습니다."));
    return ListView(
      padding: EdgeInsets.all(16),
      children: reviews.map((r) => Card(
        margin: EdgeInsets.only(bottom: 12),
        child: ListTile(
          title: Row(
            children: [
              buildStarDisplay(r['rating']),
              SizedBox(width: 8),
              Text(r['userName']),
              Spacer(),
              Text(r['createdAt'], style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(r['content']),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildQuestionTab() {
    if (questions.isEmpty) return Center(child: Text("등록된 문의가 없습니다."));
    return ListView(
      padding: EdgeInsets.all(16),
      children: questions.map((q) => Card(
        margin: EdgeInsets.only(bottom: 12),
        child: ListTile(
          title: Text(q['title']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(q['content']),
              SizedBox(height: 8),
              Text("${q['userName']} · ${q['createdAt']}",
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      )).toList(),
    );
  }
}
