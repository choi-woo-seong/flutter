import 'package:flutter/material.dart';

class NoticeDetailPage extends StatelessWidget {
  final Map<String, dynamic> notice;

  NoticeDetailPage({required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("공지사항"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: Colors.white,
          child: Table(
            columnWidths: {
              0: IntrinsicColumnWidth(),
              1: FlexColumnWidth(),
            },
            border: TableBorder.all(color: Colors.grey.shade300),
            children: [
              _buildRow("제목", notice['title'] ?? "제목 없음"),
              _buildRow("등록일", notice['date'] ?? "-"),
              _buildRow("조회수", "${notice['views'] ?? 0}"),
              TableRow(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    // ⛔ 회색 제거 → 흰색
                    color: Colors.white,
                    child: Text("내용", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Text(
                      notice['content'] ?? "공지사항 내용이 없습니다.",
                      style: TextStyle(height: 1.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildRow(String label, String value) {
    return TableRow(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          color: Colors.white, // ⛔ 회색 제거 → 흰색
          child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Text(value),
        ),
      ],
    );
  }
}
