import 'package:flutter/material.dart';

class NoticesPage extends StatefulWidget {
  @override
  _NoticesPageState createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesPage> {
  List<Map<String, dynamic>> notices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 400), () {
      setState(() {
        isLoading = false;
        notices = [
          {
            'id': 1,
            'title': "[공지] 직방 동행봉사 정보 및 이벤트 수신 안내",
            'date': "2025.04.15",
            'views': 245,
          },
          {
            'id': 2,
            'title': "[공지] 직방 개인정보 처리방침 (2024/12/31) 개정 안내",
            'date': "2025.04.10",
            'views': 187,
          },
          {
            'id': 3,
            'title': "[공지] 직방 개인정보 처리방침 (2024/11/01) 개정 안내",
            'date': "2025.04.05",
            'views': 203,
          },
          {
            'id': 4,
            'title': "[공지][일부] 단지 설계해 정보 리뉴얼 및 업데이트 자료 안내",
            'date': "2025.03.28",
            'views': 156,
          },
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("공지사항")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: notices.length,
        itemBuilder: (context, index) {
          final notice = notices[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                notice['title'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text("날짜: ${notice['date']} · 조회수: ${notice['views']}"),
              onTap: () {
                // 추후 상세 페이지 이동
              },
            ),
          );
        },
      ),
    );
  }
}
