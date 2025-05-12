import 'package:flutter/material.dart';
import 'notice_detail_page.dart';

class NoticesPage extends StatelessWidget {
  final List<Map<String, dynamic>> allNotices = [
    {
      'id': 1,
      'title': "[공지] 직방 동행봉사 정보 및 이벤트 수신 안내",
      'date': "2025.04.15",
      'views': 245,
      'content': "동행봉사와 관련된 자세한 내용과 이벤트 정보를 확인하세요.",
    },
    {
      'id': 2,
      'title': "[공지] 직방 개인정보 처리방침 (2024/12/31) 개정 안내",
      'date': "2025.04.10",
      'views': 187,
      'content': "2024년 12월 31일부터 적용되는 새로운 개인정보 처리방침입니다.",
    },
    {
      'id': 3,
      'title': "[공지] 직방 개인정보 처리방침 (2024/11/01) 개정 안내",
      'date': "2025.04.05",
      'views': 203,
      'content': "2024년 11월 01일자 개인정보 방침 개정사항 안내드립니다.",
    },
    {
      'id': 4,
      'title': "[공지][일부] 단지 설계해 정보 리뉴얼 및 업데이트 자료 안내",
      'date': "2025.03.28",
      'views': 156,
      'content': "단지 설계 정보 리뉴얼 내용과 자료 업데이트 내역 안내드립니다.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("공지사항"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: allNotices.length,
        itemBuilder: (context, index) {
          final notice = allNotices[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: ListTile(
              title: Text(notice['title']),
              subtitle: Text("날짜: ${notice['date']} · 조회수: ${notice['views']}"),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/notices-detail',
                  arguments: notice, // ✅ Map 전체를 arguments로 넘김
                );
              },
            ),
          );
        },
      ),
    );
  }
}
