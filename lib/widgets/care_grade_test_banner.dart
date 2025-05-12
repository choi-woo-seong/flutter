import 'package:flutter/material.dart';

class CareGradeTestBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // ✅ VideoSection과 동일
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16), // ✅ 내부 여백 동일
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목
            Text(
              "맞춤 추천 서비스",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // ✅ VideoSection 제목 스타일
            ),
            SizedBox(height: 12),

            // 콘텐츠 박스 (요양등급 테스트)
            Container(
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.health_and_safety, color: Colors.green, size: 32),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("요양등급 테스트", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(
                          "간단한 테스트로 예상 요양등급을 확인해보세요.",
                          style: TextStyle(fontSize: 13),
                        ),
                        SizedBox(height: 6),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/care-test');
                          },
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: Text("테스트 시작하기 >", style: TextStyle(fontSize: 13, color: Colors.green)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
