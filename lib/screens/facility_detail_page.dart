import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
  late TabController _tabController;
  Map<String, dynamic>? facility;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchFacilityDetail();
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
                  Tab(text: "비용 안내"),
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
            Center(child: Text("비용 안내 준비 중")),
            Center(child: Text("리뷰 준비 중")),
            Center(child: Text("문의 준비 중")),
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
                style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline),
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
      padding: const EdgeInsets.only(bottom: 24.0), // 각 섹션 하단 여백
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
                  top: BorderSide(
                    width: 0.5, // 회색 선 얇게
                    color: Colors.grey.shade400,
                  ),
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
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
