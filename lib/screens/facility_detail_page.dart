import 'package:flutter/material.dart';
import 'facility_cost_page.dart';

class FacilityDetailPage extends StatefulWidget {
  @override
  _FacilityDetailPageState createState() => _FacilityDetailPageState();
}

class _FacilityDetailPageState extends State<FacilityDetailPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late Map<String, dynamic> facility;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    facility = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('시설 목록'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Image.asset(
            facility['image'],
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 100),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              facility['name'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.blue,
            tabs: const [
              Tab(text: "기본정보"),
              Tab(text: "비용안내"),
              Tab(text: "리뷰"),
              Tab(text: "문의"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInfoTab(),
                _buildCostOverviewTab(context),
                FacilityReviewSection(),
                FacilityQuestionSection(),
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
        Text("📍 주소: ${facility['address']}", style: TextStyle(fontSize: 16)),
        SizedBox(height: 12),
        Text("🏷️ 태그", style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 6,
          children: List<Widget>.from(
            (facility['tags'] as List).map((tag) => Chip(
              label: Text(tag, style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.grey[100],
            )),
          ),
        ),
        SizedBox(height: 16),
        Text("ℹ️ 이 시설은 노인복지를 위한 다양한 프로그램과 서비스를 제공합니다.", style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildCostOverviewTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text("입소안내", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        Text("입소대상", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("65세 이상의 치매 또는 중증질환을 앓고 계신 어르신으로 장기요양 1~4등급(시설급여) 받으신 분"),
        SizedBox(height: 12),
        Text("입소절차", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("1. 입소신청 및 상담\n2. 기초상담 및 시설 투어\n3. 입소전 건강검진 및 코로나 검사\n4. 입소 관련 서류 제출\n5. 입소 일정 조율 및 입소"),
        SizedBox(height: 12),
        Text("입소준비서류", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("1. 건강검진서\n2. 코로나 검사 결과지\n3. 장기요양인정서\n4. 복용약\n5. 주민등록등본\n6. 보호자 인적사항\n7. 기타 안전 물품 등"),
        SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FacilityCostPage(facilityId: facility['id'].toString()),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text("상세 비용 정보 보기", style: TextStyle(color: Colors.white)),
          ),
        )
      ],
    );
  }
}




// ... (기존 import 및 상단 생략)

class FacilityReviewSection extends StatefulWidget {
  @override
  _FacilityReviewSectionState createState() => _FacilityReviewSectionState();
}

class _FacilityReviewSectionState extends State<FacilityReviewSection> {
  List<Map<String, dynamic>> reviews = [];
  bool showForm = false;
  int newRating = 0;
  String newContent = "";

  double get averageRating {
    if (reviews.isEmpty) return 0;
    return reviews.map((r) => r['rating'] as int).reduce((a, b) => a + b) / reviews.length;
  }

  void submitReview() {
    if (newContent.isNotEmpty && newRating > 0) {
      setState(() {
        reviews.add({
          'userName': "나**",
          'rating': newRating,
          'content': newContent,
          'createdAt': DateTime.now().toIso8601String().substring(0, 10),
        });
        newContent = "";
        newRating = 0;
        showForm = false;
      });
    }
  }

  Widget buildStarDisplay(int rating) {
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
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text("리뷰", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),

        if (reviews.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  buildStarDisplay(averageRating.round()),
                  SizedBox(width: 8),
                  Text("${averageRating.toStringAsFixed(1)}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 4),
                  Text("(${reviews.length}개)", style: TextStyle(color: Colors.grey[600]))
                ],
              ),
              SizedBox(height: 12),
            ],
          ),

        if (reviews.isEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("등록된 리뷰가 없습니다."),
              SizedBox(height: 12),
            ],
          ),

        Column(
          children: reviews.map((r) => Container(
            margin: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    buildStarDisplay(r['rating'] as int),
                    SizedBox(width: 8),
                    Text(r['userName'] as String, style: TextStyle(fontWeight: FontWeight.bold)),
                    Spacer(),
                    Text(r['createdAt'] as String, style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 8),
                Text(r['content'] as String),
              ],
            ),
          )).toList(),
        ),


        if (showForm)
          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, // 완전한 흰색 배경
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,   // 부드러운 회색 그림자
                  blurRadius: 4,           // 그림자 흐림 정도
                  offset: Offset(0, 2),    // 수직 방향 아래로 그림자
                )
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("리뷰 작성하기", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  children: List.generate(5, (i) => IconButton(
                    icon: Icon(
                      Icons.star,
                      color: i < newRating ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () => setState(() => newRating = i + 1),
                  )),
                ),
                TextField(
                  onChanged: (value) => setState(() => newContent = value),
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "리뷰를 작성해주세요",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
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
                      onPressed: () => setState(() => showForm = false),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black, // 텍스트 색상
                      ),
                      child: Text("취소"),
                    ),

                  ],
                )
              ],
            ),
          ),
        if (!showForm)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: () => setState(() => showForm = true),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                backgroundColor: Colors.blue,
              ),
              child: Text("리뷰 작성", style: TextStyle(color: Colors.white)),
            ),
          ),

      ],
    );
  }
}


class FacilityQuestionSection extends StatefulWidget {
  @override
  _FacilityQuestionSectionState createState() => _FacilityQuestionSectionState();
}

class _FacilityQuestionSectionState extends State<FacilityQuestionSection> {
  List<Map<String, dynamic>> questions = [];
  bool showForm = false;
  String newQuestion = "";

  void submitQuestion() {
    if (newQuestion.isNotEmpty) {
      setState(() {
        questions.add({
          'title': "문의", 'content': newQuestion,
          'userName': "익명 사용자", 'createdAt': DateTime.now().toIso8601String().substring(0, 10), 'isPrivate': false,
        });
        newQuestion = "";
        showForm = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Text("문의", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),

        if (questions.isEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("등록된 문의가 없습니다."),
              SizedBox(height: 12),
              if (!showForm) // ✅ 입력 폼 안 보일 때만 버튼 보이게
                ElevatedButton(
                  onPressed: () => setState(() => showForm = true),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                    backgroundColor: Colors.blue,
                  ),
                  child: Text("문의 작성", style: TextStyle(color: Colors.white)),
                ),
            ],
          )

        else
          Column(
            children: questions.map((q) => Card(
              color: Colors.white, // ✅ 흰색 배경
              elevation: 2,        // ✅ 리뷰 카드와 동일한 그림자
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // ✅ 모서리 둥글게
              ),
              margin: EdgeInsets.only(bottom: 12), // ✅ 카드 간 간격 통일
              child: ListTile(
                title: Text(q['title'] as String, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(q['content'] as String),
                    SizedBox(height: 8),
                    Text(
                      "${q['userName']} · ${q['createdAt']}",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )).toList(),
          ),


        if (showForm)
          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, // 완전한 흰색 배경
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,   // 부드러운 회색 그림자
                  blurRadius: 4,           // 그림자 흐림 정도
                  offset: Offset(0, 2),    // 수직 방향 아래로 그림자
                )
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("문의 작성하기", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                TextField(
                  onChanged: (value) => setState(() => newQuestion = value),
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "문의 내용을 입력해주세요",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 12),
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
                      onPressed: () => setState(() => showForm = false),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black, // 텍스트 색상
                      ),
                      child: Text("취소"),
                    ),

                  ],
                )
              ],
            ),
          ),

        if (questions.isNotEmpty && !showForm)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child:  ElevatedButton(
              onPressed: () => setState(() => showForm = true),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48), // ✅ 너비 꽉차게, 높이는 48
                backgroundColor: Colors.blue,
              ),
              child: Text("문의 작성", style: TextStyle(color: Colors.white)),
            ),
          ),
      ],
    );
  }
}

