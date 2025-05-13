import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NoticesPage extends StatefulWidget {
  @override
  _NoticesPageState createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesPage> {
  List<Map<String, dynamic>> allNotices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotices();
  }

  Future<void> fetchNotices() async {
    try {
      final url = Uri.parse(
          'http://192.168.0.83:8081/api/notices?page=0&size=10&sort=createdAt,desc');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // ✅ 인코딩 보정
        final Map<String, dynamic> data =
        json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> content = data['content'];

        setState(() {
          allNotices = content.map<Map<String, dynamic>>((item) {
            return {
              'id': item['id'],
              'title': item['title'] ?? '',
              'createdAt': item['createdAt'] ?? '',
              'views': item['views'] ?? 0,
              'content': item['content'] ?? '',
            };
          }).toList();
          isLoading = false;
        });
      } else {
        print('📛 서버 응답 오류: ${response.statusCode}');
        print('본문: ${response.body}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('❌ 예외 발생: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("공지사항"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : allNotices.isEmpty
          ? Center(child: Text("공지사항이 없습니다."))
          : ListView.builder(
        itemCount: allNotices.length,
        itemBuilder: (context, index) {
          final notice = allNotices[index];
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(notice['title']),
              subtitle: Text(
                "날짜: ${notice['createdAt']} · 조회수: ${notice['views']}",
                style: TextStyle(fontSize: 12),
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/notices-detail',
                  arguments: notice,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
