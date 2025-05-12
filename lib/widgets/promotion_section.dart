import 'package:flutter/material.dart';

class PromotionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFF9C4), // 연노랑 배경
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 왼쪽 텍스트 + 태그
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _buildTag('요양 고민', Colors.orange),
                    _buildTag('상담', Colors.pink),
                    _buildTag('정보', Colors.blue),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  '함께 소통해요!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // 오른쪽 이미지 (사이즈 제한 + 로딩 에러 대응)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset('assets/images/main.png', // 올바른 파일명 사용
              width: 100,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 80,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: Icon(Icons.error, color: Colors.red),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
