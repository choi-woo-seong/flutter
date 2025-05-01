import 'package:flutter/material.dart';

class NoticeBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber.shade100,
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(Icons.campaign, color: Colors.orange),
          SizedBox(width: 8),
          Expanded(child: Text("공지: 새로운 요양원 등록 혜택 안내 중입니다.")),
        ],
      ),
    );
  }
}
