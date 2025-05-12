import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;

  BottomNavigation({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue, // ✅ 선택된 아이콘 및 텍스트 파란색
      unselectedItemColor: Colors.grey, // (선택사항) 비선택 아이콘 색
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "찜"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "장바구니"),
      ],
      onTap: (index) {
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
