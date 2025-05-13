import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NoticeBar extends StatefulWidget {
  @override
  _NoticeBarState createState() => _NoticeBarState();
}

class _NoticeBarState extends State<NoticeBar> {
  List<String> titles = [];
  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchTitles();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchTitles() async {
    try {
      final url = Uri.parse("http://192.168.0.83:8081/api/notices?page=0&size=5&sort=createdAt,desc");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData =
        json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> content = jsonData['content'];

        final recentTitles = content
            .map<String>((item) => item['title']?.toString() ?? "제목 없음")
            .toList();

        if (mounted) {
          setState(() {
            titles = recentTitles;
          });

          if (titles.isNotEmpty) startAutoScroll();
        }
      } else {
        print("❌ 응답 오류: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("❌ 공지 가져오기 실패: $e");
    }
  }

  void startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (_) {
      if (!mounted || titles.isEmpty) return;
      setState(() {
        currentIndex = (currentIndex + 1) % titles.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTitle = titles.isNotEmpty
        ? "공지: ${titles[currentIndex]}"
        : "공지사항을 불러오는 중...";

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.campaign, color: Colors.orange, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              currentTitle,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/notices'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              "더보기 >",
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
