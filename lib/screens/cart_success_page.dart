import 'package:flutter/material.dart';

class CartSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("주문 완료"),
        backgroundColor: Colors.white,      // ✅ 상단바 배경 흰색
        foregroundColor: Colors.black,      // ✅ 텍스트 및 아이콘 색 검정
        elevation: 1,   ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.blue, size: 80),
              SizedBox(height: 20),
              Text(
                "주문이 성공적으로 완료되었습니다!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                "주문 내역은 마이페이지에서 확인하실 수 있습니다.",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                icon: Icon(Icons.home),
                label: Text("홈으로 돌아가기"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,       // ✅ 파란색 배경
                  foregroundColor: Colors.white,      // ✅ 흰색 텍스트 및 아이콘
                ),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
