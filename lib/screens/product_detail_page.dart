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
  bool _isReviewFormHover = false;
  bool _isQuestionFormHover = false;
  late TabController _tabController;
  int quantity = 1;
  Map<String, dynamic>? product;
  List<Map<String, dynamic>> reviews = [];
  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;
  bool isInitialized = false;
  bool showReviewForm = false;
  bool showQuestionForm = false;
  int newRating = 0;
  String newReview = '';
  String newQuestion = '';
  String? accessToken;
  String? userName;
  int? userId; // ← 여기에 선언


  final numberFormat = NumberFormat("#,###", "ko_KR");

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // initializeAuth(); ← ❌ 이거 제거!
  }

  Future<void> initializeAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    final id = prefs.getInt('userId');
    final name = prefs.getString('name');

    print("🧑 accessToken: $token");
    print("🧑 userId: $id");
    print("🧑 userName: $name");

    setState(() {
      accessToken = token;
      userId = id;
      userName = name;
    });
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic> && args.containsKey('id')) {
        final productId = args['id'];

        initializeAuth().then((_) async {
          await fetchProductDetail(productId);
          await fetchReviews(productId);

          // 👉 로그인 되어 있을 때만 질문 불러오기
          if (accessToken != null) {
            await fetchMyQuestions(productId);
          }

          // ✅ 어떤 경우든 isLoading 해제
          setState(() {
            isInitialized = true;
            isLoading = false;
          });
        });
      } else {
        Navigator.pop(context);
      }
    }
  }




  Future<void> fetchProductDetail(int id) async {
    final res = await http.get(Uri.parse("http://192.168.0.83:8081/api/products/$id"));
    if (res.statusCode == 200) {
      setState(() {
        product = json.decode(utf8.decode(res.bodyBytes));
        isLoading = false;
      });
    }
  }

// 리뷰 조회 수정
  Future<void> fetchReviews(int id) async {
    final res = await http.get(Uri.parse("http://192.168.0.83:8081/api/reviews/product/$id"));
    if (res.statusCode == 200) {
      setState(() {
        reviews = List<Map<String, dynamic>>.from(json.decode(utf8.decode(res.bodyBytes)));
      });
    }
  }

  Future<void> fetchMyQuestions(int productId) async {
    if (accessToken == null) return;

    final res = await http.get(
      Uri.parse("http://192.168.0.83:8081/api/questions/my"),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (res.statusCode == 200) {
      final data = json.decode(utf8.decode(res.bodyBytes)) as List;
      setState(() {
        questions = data.where((q) {
          // productId가 일치하는 것만
          return q['productId']?.toString() == productId.toString();
        }).map((e) => Map<String, dynamic>.from(e)).toList();
      });
    }
  }




  Future<void> submitReview() async {
    if (accessToken == null) return;
    final res = await http.post(
      Uri.parse("http://192.168.0.83:8081/api/reviews"), // 🔁 변경
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        'productId': product!['id'],
        'userName': userName ?? '익명',
        'rating': newRating,
        'content': newReview
      }),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      fetchReviews(product!['id']);
      setState(() {
        showReviewForm = false;
        newRating = 0;
        newReview = '';
      });
    }
  }

  Future<void> submitQuestion() async {
    if (accessToken == null) return;

    // ① product 이름 꺼내기
    final productName = product?['name']?.toString() ?? '';

    // ② 동적 제목 생성
    final dynamicTitle = productName.isNotEmpty
        ? '$productName 문의'
        : '상품 문의';

    final res = await http.post(
      Uri.parse("http://192.168.0.83:8081/api/questions"),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        'title': dynamicTitle,       // ← 여기 적용
        'content': newQuestion,
        'productId': product!['id'],
      }),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      await fetchMyQuestions(product!['id']);
      setState(() {
        showQuestionForm = false;
        newQuestion = '';
      });
    } else {
      print("❌ 문의 등록 실패: ${res.statusCode}");
    }
  }





  Future<void> addToCart(int productId, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken') ?? '';
    final res = await http.post(
      Uri.parse("http://192.168.0.83:8081/api/cart"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({"productId": productId, "quantity": quantity}),
    );
    if (res.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("장바구니에 담겼습니다"),
          content: Text("지금 장바구니로 이동하시겠습니까?"),
          actions: [
            // 계속 구경하기: 배경 없이 검정 텍스트
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,      // 텍스트 검정
                backgroundColor: Colors.transparent, // 배경 투명
              ),
              child: Text("계속 구경하기"),
            ),
            // 장바구니로 이동: 파란 배경, 흰 텍스트
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/cart');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,    // 배경 파랑
                foregroundColor: Colors.white,   // 텍스트 흰색
              ),
              child: Text("장바구니로 이동"),
            ),
          ],
        ),
      );
    }
  }


  void changeQuantity(int delta) {
    setState(() {
      quantity = (quantity + delta).clamp(1, 99);
    });
  }

  String _resolveImageUrl(String rawUrl) {
    if (rawUrl.startsWith('http')) return rawUrl;
    return "http://192.168.0.83:8081$rawUrl";
  }

  Widget buildStarDisplay(dynamic ratingValue) {
    final double rating = (ratingValue is int)
        ? ratingValue.toDouble()
        : (ratingValue as double? ?? 0.0);

    return Row(
      children: List.generate(5, (i) => Icon(
        Icons.star,
        color: i < rating ? Colors.amber : Colors.grey[300],
        size: 18,
      )),
    );
  }

  Widget _buildReviewTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        if (reviews.isEmpty)
          Text("등록된 리뷰가 없습니다."),
        ...reviews.map((r) => Container(
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  buildStarDisplay(r['rating']),
                  SizedBox(width: 8),
                  Text(r['userName'] ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  Text(r['createdAt'].toString().split("T").first,
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              SizedBox(height: 8),
              Text(r['content'] ?? ''),
            ],
          ),
        )),
        if (showReviewForm)
          MouseRegion(
            onEnter: (_) => setState(() => _isReviewFormHover = true),
            onExit:  (_) => setState(() => _isReviewFormHover = false),
            child: Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isReviewFormHover ? Colors.blue : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("리뷰 작성하기", style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: List.generate(5, (i) => IconButton(
                      icon: Icon(Icons.star, color: i < newRating ? Colors.amber : Colors.grey),
                      onPressed: () => setState(() => newRating = i + 1),
                    )),
                  ),
                  TextField(
                    onChanged: (val) => setState(() => newReview = val),
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "리뷰를 작성해주세요",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: submitReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("등록"),
                      ),
                      SizedBox(width: 12),
                      TextButton(
                        onPressed: () => setState(() => showReviewForm = false),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black, // 취소 버튼 글씨 검정
                        ),
                        child: Text("취소"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        else
          ElevatedButton(
            onPressed: () => setState(() => showReviewForm = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 48),
            ),
            child: Text("리뷰 작성"),
          ),
      ],
    );
  }

  Widget _buildQuestionTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        if (questions.isEmpty)
          Text("등록된 문의가 없습니다."),
        ...questions.map((q) => Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(q['title'], style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(q['content']),
              SizedBox(height: 8),
              // 이름 대신 아이디만 표시
              Text(
                "${q['userId']} · ${q['createdAt'].toString().split('T').first}",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        )),
        if (showQuestionForm)
          MouseRegion(
            onEnter: (_) => setState(() => _isQuestionFormHover = true),
            onExit:  (_) => setState(() => _isQuestionFormHover = false),
            child: Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isQuestionFormHover ? Colors.blue : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("문의 작성하기", style: TextStyle(fontWeight: FontWeight.bold)),
                  TextField(
                    onChanged: (val) => setState(() => newQuestion = val),
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "문의 내용을 입력해주세요",
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: submitQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("등록"),
                      ),
                      SizedBox(width: 12),
                      TextButton(
                        onPressed: () => setState(() => showQuestionForm = false),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black, // 취소 버튼 글씨 검정
                        ),
                        child: Text("취소"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        else
          ElevatedButton(
            onPressed: () => setState(() => showQuestionForm = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 48),
            ),
            child: Text("문의 작성"),
          ),


      ],
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
                        style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough)),
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
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,      // ★ 선택된 탭 밑줄 색
              indicatorWeight: 3.0,             // ★ 밑줄 두께
              tabs: [
                Tab(text: "상세정보"),
                Tab(text: "리뷰"),
                Tab(text: "문의"),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      Text(product!['description'] ?? '상품 설명이 없습니다.'),
                    ],
                  ),
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
          onPressed: () async => await addToCart(product!['id'], quantity),
        ),
      ),
    );
  }
}
