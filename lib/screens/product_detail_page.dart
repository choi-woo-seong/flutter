import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int quantity = 1;
  List<Map<String, dynamic>> reviews = [];
  List<Map<String, dynamic>> questions = [];
  bool showReviewForm = false;
  bool showQuestionForm = false;
  int newRating = 0;
  String newReview = "";
  String newQuestion = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void changeQuantity(int delta) {
    setState(() {
      quantity = (quantity + delta).clamp(1, 99);
    });
  }

  void submitReview() {
    if (newReview.isNotEmpty && newRating > 0) {
      setState(() {
        reviews.add({
          'userName': "나**",
          'rating': newRating,
          'content': newReview,
          'createdAt': DateTime.now().toIso8601String().substring(0, 10),
        });
        newReview = "";
        newRating = 0;
        showReviewForm = false;
      });
    }
  }

  void submitQuestion() {
    if (newQuestion.isNotEmpty) {
      setState(() {
        questions.add({
          'title': "문의",
          'content': newQuestion,
          'userName': "익명 사용자",
          'createdAt': DateTime.now().toIso8601String().substring(0, 10),
        });
        newQuestion = "";
        showQuestionForm = false;
      });
    }
  }

  Widget buildStarDisplay(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) => Icon(
        Icons.star,
        color: i < rating ? Colors.amber : Colors.grey[300],
        size: 18,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    double averageRating = reviews.isNotEmpty
        ? reviews.map((r) => r['rating'] as int).reduce((a, b) => a + b) / reviews.length
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('제품 목록'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,

      ),
      body: Column(
        children: [
          Image.asset('assets/images/supportive.png', height: 200),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("실버워커 (바퀴X) 노인용 보행기",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  children: [
                    buildStarDisplay(averageRating),
                    SizedBox(width: 8),
                    Text("${averageRating.toStringAsFixed(1)}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 4),
                    Text("(${reviews.length}개 리뷰)", style: TextStyle(color: Colors.grey[600]))
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("220,000원",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Text("80%",
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text("1,100,000원",
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ))
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text("수량:", style: TextStyle(fontSize: 16)),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => changeQuantity(-1),
                    ),
                    Text('$quantity'),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => changeQuantity(1),
                    ),
                  ],
                )
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.blue,
            tabs: const [
              Tab(text: "상세정보"),
              Tab(text: "리뷰"),
              Tab(text: "문의"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDescriptionTab(),
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
          onPressed: () {
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

  Widget _buildDescriptionTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text("\u{1F4E6} 제품 설명", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text("이 상품은 경량 접이식 보행 보조기로, 어르신들의 안전한 이동을 돕습니다."),
      ],
    );
  }

  Widget _buildReviewTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        if (reviews.isEmpty) Text("등록된 리뷰가 없습니다."),
        ...reviews.map((r) => Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  buildStarDisplay(r['rating']),
                  SizedBox(width: 8),
                  Text(r['userName'], style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  Text(r['createdAt'], style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              SizedBox(height: 8),
              Text(r['content']),
            ],
          ),
        )),
        if (showReviewForm) _buildReviewForm(),
        if (!showReviewForm)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: () => setState(() => showReviewForm = true),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48), backgroundColor: Colors.blue),
              child: Text("리뷰 작성", style: TextStyle(color: Colors.white)),
            ),
          ),
      ],
    );
  }

  Widget _buildReviewForm() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("리뷰 작성하기", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            children: List.generate(5, (i) => IconButton(
              icon: Icon(Icons.star, color: i < newRating ? Colors.amber : Colors.grey),
              onPressed: () => setState(() => newRating = i + 1),
            )),
          ),
          TextField(
            onChanged: (value) => setState(() => newReview = value),
            maxLines: 3,
            decoration: InputDecoration(hintText: "리뷰를 작성해주세요", border: OutlineInputBorder()),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: submitReview,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                child: Text("등록"),
              ),
              SizedBox(width: 12),
              TextButton(
                onPressed: () => setState(() => showReviewForm = false),
                child: Text("취소"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        if (questions.isEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("등록된 문의가 없습니다."),
              SizedBox(height: 12),
              if (!showQuestionForm)
                ElevatedButton(
                  onPressed: () => setState(() => showQuestionForm = true),
                  style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48), backgroundColor: Colors.blue),
                  child: Text("문의 작성", style: TextStyle(color: Colors.white)),
                ),
            ],
          )
        else
          ...questions.map((q) => Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(q['title'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(q['content']),
                  SizedBox(height: 8),
                  Text("${q['userName']} · ${q['createdAt']}", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          )),
        if (showQuestionForm) _buildQuestionForm(),
        if (questions.isNotEmpty && !showQuestionForm)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: () => setState(() => showQuestionForm = true),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 48), backgroundColor: Colors.blue),
              child: Text("문의 작성", style: TextStyle(color: Colors.white)),
            ),
          ),
      ],
    );
  }

  Widget _buildQuestionForm() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("문의 작성하기", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          TextField(
            onChanged: (value) => setState(() => newQuestion = value),
            maxLines: 3,
            decoration: InputDecoration(hintText: "문의 내용을 입력해주세요", border: OutlineInputBorder()),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: submitQuestion,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                child: Text("등록"),
              ),
              SizedBox(width: 12),
              TextButton(
                onPressed: () => setState(() => showQuestionForm = false),
                child: Text("취소"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
