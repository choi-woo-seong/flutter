import 'package:flutter/material.dart';

class FacilityDetailPage extends StatefulWidget {
  @override
  _FacilityDetailPageState createState() => _FacilityDetailPageState();
}

class _FacilityDetailPageState extends State<FacilityDetailPage>
    with SingleTickerProviderStateMixin {
  bool isFavorite = false;
  bool showReviewForm = false;
  bool showQuestionForm = false;
  int rating = 0;

  late TabController _tabController;

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

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("시설 상세"),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: Column(
        children: [
          Image.asset('assets/images/facility_sample.png', height: 200, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "행복한 실버타운 노인복지센터",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "정보"),
              Tab(text: "리뷰"),
              Tab(text: "문의"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInfoTab(),
                _buildReviewTab(),
                _buildQuestionTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text("주소: 서울시 강남구 어딘가로 123", style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Text("운영시간: 평일 9시 ~ 18시", style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Text("전화번호: 02-123-4567", style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Text("설명: 노인복지센터입니다. 건강하고 행복한 노후를 지원합니다."),
      ],
    );
  }

  Widget _buildReviewTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          title: Text("⭐️⭐️⭐️⭐️☆"),
          subtitle: Text("시설이 청결하고 직원분들이 친절해요."),
        ),
        if (!showReviewForm)
          TextButton(
            onPressed: () => setState(() => showReviewForm = true),
            child: Text("리뷰 작성"),
          ),
        if (showReviewForm)
          Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: "리뷰 내용"),
              ),
              SizedBox(height: 8),
              ElevatedButton(onPressed: () {}, child: Text("등록")),
            ],
          ),
      ],
    );
  }

  Widget _buildQuestionTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          title: Text("문의: 식사는 어떤 방식인가요?"),
          subtitle: Text("답변: 영양사 관리 하에 3식 제공됩니다."),
        ),
        if (!showQuestionForm)
          TextButton(
            onPressed: () => setState(() => showQuestionForm = true),
            child: Text("문의 작성"),
          ),
        if (showQuestionForm)
          Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: "문의 내용"),
              ),
              SizedBox(height: 8),
              ElevatedButton(onPressed: () {}, child: Text("보내기")),
            ],
          ),
      ],
    );
  }
}
