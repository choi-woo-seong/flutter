import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  int quantity = 1;
  int rating = 0;
  bool showReviewForm = false;
  bool showQuestionForm = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 임시 상품 데이터
    _tabController = TabController(length: 2, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상품 상세'),
        actions: [
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Image.asset('assets/images/supportive-stroll.png', height: 200),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "실버워커 (바퀴X) 노인용 보행기",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("가격: 220,000원", style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  IconButton(onPressed: () => changeQuantity(-1), icon: Icon(Icons.remove)),
                  Text('$quantity'),
                  IconButton(onPressed: () => changeQuantity(1), icon: Icon(Icons.add)),
                ],
              ),
            ],
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: '상세설명'),
              Tab(text: '리뷰 / 문의'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDescription(),
                _buildReviewsAndQuestions(),
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
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text("이 상품은 경량 접이식 보행 보조기로, 어르신들의 안전한 이동을 돕습니다."),
    );
  }

  Widget _buildReviewsAndQuestions() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          title: Text("⭐️⭐️⭐️⭐️☆"),
          subtitle: Text("아주 만족합니다."),
        ),
        ListTile(
          title: Text("문의: 무게는 몇 kg인가요?"),
          subtitle: Text("답변: 약 4.5kg입니다."),
        ),
        if (!showReviewForm)
          TextButton(
            onPressed: () => setState(() => showReviewForm = true),
            child: Text("리뷰 작성"),
          ),
        if (showReviewForm)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "리뷰 내용"),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {},
                child: Text("등록"),
              ),
            ],
          ),
      ],
    );
  }
}
