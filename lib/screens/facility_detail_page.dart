import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class FacilityDetailPage extends StatefulWidget {
  final String facilityId;
  FacilityDetailPage({required this.facilityId});

  @override
  _FacilityDetailPageState createState() => _FacilityDetailPageState();
}


class _FacilityDetailPageState extends State<FacilityDetailPage>
    with SingleTickerProviderStateMixin {
  bool _isReviewFormHover = false;
  bool _isQuestionFormHover = false;
  late TabController _tabController;
  Map<String, dynamic>? facility;

  List<dynamic> reviews = [];
  List<dynamic> questions = [];
  bool showReviewForm = false;
  bool showQuestionForm = false;
  int newRating = 0;
  String newReview = "";
  String newQuestion = "";
  String? accessToken;
  String? userName; // 👈 이름 저장


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchFacilityDetail();
    initializeAuthAndLoadData(); // ✅ 분리
  }

  Future<void> initializeAuthAndLoadData() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken');
    userName = prefs.getString('name');

    // ✅ accessToken 세팅 완료 후 호출
    await fetchReviews();
    await fetchMyQuestions();
  }


  Future<void> fetchFacilityDetail() async {
    try {
      final url = Uri.parse('http://192.168.0.83:8081/api/facility/${widget.facilityId}');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = json.decode(utf8.decode(res.bodyBytes));
        setState(() => facility = data);
      } else {
        print("❌ 실패: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ 오류 발생: $e");
    }
  }

  String _resolveImageUrl(String url) {
    if (url.startsWith("http")) return url;
    return "http://192.168.0.83:8081$url";
  }

  String? _getImageUrl() {
    if (facility == null) return null;
    if (facility!['facilityImages'] != null &&
        facility!['facilityImages'] is List &&
        facility!['facilityImages'].isNotEmpty) {
      final firstImage = facility!['facilityImages'][0];
      if (firstImage is Map && firstImage.containsKey('imageUrl')) {
        return _resolveImageUrl(firstImage['imageUrl']);
      }
    }
    if (facility!['imageUrls'] != null &&
        facility!['imageUrls'] is List &&
        facility!['imageUrls'].isNotEmpty) {
      return _resolveImageUrl(facility!['imageUrls'][0]);
    }
    if (facility!['image'] != null) {
      return _resolveImageUrl(facility!['image']);
    }
    return null;
  }
  Future<void> fetchReviews() async {
    try {
      final url = Uri.parse('http://192.168.0.83:8081/api/facility-reviews/${widget.facilityId}');

      // ✅ 헤더 조건부 구성
      final headers = {
        "Accept": "application/json",
        if (accessToken != null) "Authorization": "Bearer $accessToken", // 토큰 있으면만 넣음
      };

      final res = await http.get(url, headers: headers);
      final raw = utf8.decode(res.bodyBytes);

      print("📥 리뷰 응답: $raw");

      if (res.statusCode == 200) {
        final decoded = json.decode(raw);
        if (decoded is List) {
          setState(() => reviews = decoded);
        } else if (decoded is Map && decoded.containsKey('data')) {
          setState(() => reviews = decoded['data']);
        } else {
          print("⚠️ 예상치 못한 JSON 구조");
        }
      } else {
        print("❌ 응답 실패: ${res.statusCode}");
      }
    } catch (e) {
      print("❌ 예외 발생: $e");
    }
  }





  Future<void> submitReview() async {
    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("로그인이 필요합니다.")),
      );
      return;
    }

    final res = await http.post(
      Uri.parse('http://192.168.0.83:8081/api/facility-reviews'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        'facilityId': int.parse(widget.facilityId),
        'userName': userName ?? '익명',
        'rating': newRating,
        'content': newReview
      }),
    );

    if (res.statusCode == 200) {
      fetchReviews();
      setState(() {
        showReviewForm = false;
        newRating = 0;
        newReview = '';
      });
    }
  }


  Future<void> fetchMyQuestions() async {
    if (accessToken == null) return;

    final res = await http.get(
      Uri.parse('http://192.168.0.83:8081/api/questions/my'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (res.statusCode == 200) {
      final List data = json.decode(utf8.decode(res.bodyBytes));
      setState(() {
        questions = data.where((q) {
          return q['targetType'] == 'facility'
              && q['facilityId']?.toString() == widget.facilityId;
        }).toList();
      });
    }
  }





  Future<void> submitQuestion() async {
    if (accessToken == null) return;

    // facility 이름이 없으면 빈 문자열 처리
    final facilityName = facility?['name']?.toString() ?? '';

    // 동적으로 title 생성
    final dynamicTitle = facilityName.isNotEmpty
        ? '시설($facilityName) 문의'
        : '시설 문의';

    final res = await http.post(
      Uri.parse('http://192.168.0.83:8081/api/questions'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        'title': dynamicTitle,                      // 여기를 변경
        'content': newQuestion,
        'facilityId': int.parse(widget.facilityId),
      }),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final newData = json.decode(utf8.decode(res.bodyBytes));
      setState(() {
        questions.insert(0, newData);
        showQuestionForm = false;
        newQuestion = '';
      });
    } else {
      print("❌ 문의 등록 실패: ${res.statusCode}");
    }
  }






  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final imageUrl = _getImageUrl();

    return Scaffold(
      appBar: AppBar(
        title: Text('시설 상세정보'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: facility == null
          ? Center(child: CircularProgressIndicator())
          : NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null && imageUrl.isNotEmpty)
                  Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: 100),
                  )
                else
                  Icon(Icons.image_not_supported, size: 100),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _buildBasicInfoTable(),
                ),
              ],
            ),
          ),
          SliverPersistentHeader(
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.blue,
                tabs: const [
                  Tab(text: "시설 설명"),
                  Tab(text: "리뷰"),
                  Tab(text: "문의"),
                ],
              ),
            ),
            pinned: true,
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildFacilityDescription(),
            _buildReviewTab(),
            _buildQuestionTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("표준 정보", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        _buildInfoRow("시설명", facility?['name']),
        _buildInfoRow("설립년도", facility?['establishedYear']),
        _buildInfoRow("주소", facility?['address']),
        _buildInfoRow("연락처", facility?['phone']),
        _buildInfoRow("홈페이지 주소", facility?['homepage'], isLink: true),
        _buildInfoRow("평가등급", facility?['grade']),
      ],
    );
  }
  Widget _buildFacilityDescription() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection("", facility?['description']),
        _buildSection("진료시간", facility?['treatmentTime']),
        _buildSection("특장점", facility?['features']),
        _buildSection("평가등급", facility?['gradeDetail']),
        _buildSection("병상정보", facility?['bedInfo']),
        _buildSection("의료진 정보", facility?['doctors']),
        _buildSection("의료장비", facility?['equipments']),
        _buildSection("운영정보", facility?['operationInfo']),
        _buildSection("주차정보", facility?['parkingInfo']),
      ],
    );
  }

  Widget _buildReviewTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        if (reviews.isEmpty)
          Text("등록된 리뷰가 없습니다."),
        ...reviews.map((r) {
          final createdAt = r['createdAt']?.toString().split("T").first ?? "-";
          final rating = int.tryParse(r['rating']?.toString() ?? '') ?? 0;
          final userName = r['userName']?.toString() ?? '익명';
          final content = r['content']?.toString() ?? '';

          return Container(
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
                    Row(
                      children: List.generate(5, (i) => Icon(
                        Icons.star,
                        color: i < rating ? Colors.amber : Colors.grey[300],
                        size: 16,
                      )),
                    ),
                    SizedBox(width: 8),
                    Text(userName, style: TextStyle(fontWeight: FontWeight.bold)),
                    Spacer(),
                    Text(createdAt, style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),

                SizedBox(height: 8),
                Text(content),
              ],
            ),
          );
        }).toList(),

        // 👉 리뷰 작성 폼 or 버튼 (로그인 여부 판단)
        if (showReviewForm)
          _buildReviewForm()
        else
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: () {
                if (accessToken == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("리뷰 작성은 로그인 후 이용 가능합니다.")),
                  );
                  return;
                }
                setState(() => showReviewForm = true);
              },
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




  Widget _buildReviewForm() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isReviewFormHover = true),
      onExit:  (_) => setState(() => _isReviewFormHover = false),
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isReviewFormHover ? Colors.blue : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
          ],
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
              decoration: InputDecoration(
                hintText: "리뷰를 작성해주세요",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
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
                  Text("${q['userId']} · ${q['createdAt'].toString().substring(0, 10)}", style: TextStyle(fontSize: 12, color: Colors.grey)),
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
    return MouseRegion(
      onEnter: (_) => setState(() => _isQuestionFormHover = true),
      onExit:  (_) => setState(() => _isQuestionFormHover = false),
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isQuestionFormHover ? Colors.blue : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
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
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
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
    );
  }


  Widget _buildInfoRow(String label, dynamic value, {bool isLink = false}) {
    final displayText = (value == null || value.toString().trim().isEmpty)
        ? "-"
        : value.toString().trim();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: isLink && displayText != "-"
                ? InkWell(
              onTap: () => launchUrl(Uri.parse(
                displayText.startsWith("http")
                    ? displayText
                    : "https://$displayText",
              )),
              child: Text(
                displayText,
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            )
                : Text(displayText, style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, dynamic content, {bool isLink = false}) {
    String displayText = (content ?? '').toString().trim();

    return displayText.isNotEmpty
        ? Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 20),
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          MarkdownBody(
            data: displayText,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              p: TextStyle(fontSize: 14, height: 1.5),
              strong: TextStyle(fontWeight: FontWeight.bold),
              horizontalRuleDecoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 0.5, color: Colors.grey.shade400),
                ),
              ),
            ),
          ),
        ],
      ),
    )
        : SizedBox.shrink();
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
