import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "찜"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "장바구니"),
      ],
      currentIndex: 0,
      onTap: (index) {
        // 페이지 이동 처리 예시
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/');
            break;
          case 1:
            Navigator.pushNamed(context, '/favorites');
            break;
          case 2:
            Navigator.pushNamed(context, '/cart');
            break;
        }
      },
    );
  }
}
