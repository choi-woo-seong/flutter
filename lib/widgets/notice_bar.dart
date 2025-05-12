import 'package:flutter/material.dart';

class NoticeBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), // 높이 ↓
      child: Row(
        children: [
          Icon(Icons.campaign, color: Colors.orange, size: 18), // 아이콘 크기 ↓
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "공지: 새로운 요양원 등록 혜택 안내 중입니다.",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500), // 텍스트 크기 ↓
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/notices');
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero, // 텍스트 버튼 패딩 제거
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
