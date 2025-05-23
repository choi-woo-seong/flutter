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
    final url = Uri.parse(
        'http://192.168.0.83:8081/api/notices?page=0&size=10&sort=createdAt,desc'
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
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
      setState(() => isLoading = false);
      print('📛 서버 응답 오류: ${response.statusCode}');
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
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: ListTile(
              title: Text(notice['title']),
              subtitle: Text(
                "날짜: ${notice['createdAt']} · 조회수: ${notice['views']}",
                style: TextStyle(fontSize: 12),
              ),
              onTap: () async {
                final noticeId = notice['id'];
                final incrementUrl = Uri.parse(
                    "http://192.168.0.83:8081/api/notices/$noticeId/views"
                );

                // 1) 서버에 조회수 올리기 시도
                try {
                  final incRes = await http.patch(incrementUrl);
                  if (incRes.statusCode >= 200 && incRes.statusCode < 400) {
                    // 로컬에선 성공 처리된 것으로 간주
                    setState(() {
                      notice['views'] = (notice['views'] as int) + 1;
                    });
                  } else {
                    print("조회수 증가 실패: ${incRes.statusCode}\n${incRes.body}");
                  }
                } catch (e) {
                  print("조회수 증가 예외: $e");
                }

                // 2) 상세 페이지로 이동 (돌아와도 목록을 다시 불러오지 않음)
                await Navigator.pushNamed(
                  context,
                  '/notices-detail',
                  arguments: notice,
                );
                // ★ fetchNotices(); 호출 제거!
              },
            ),
          );
        },
      ),
    );
  }
}
