import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, String>> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false;
        favorites = [
          {
            'id': '1',
            'name': '실버워커 (바퀴X) 노인용 보행기',
            'image': 'assets/images/supportive-stroll.png',
          },
          {
            'id': '2',
            'name': '의료용 실버워커',
            'image': 'assets/images/elderly-woman-using-walker.png',
          },
        ];
      });
    });
  }

  void removeFavorite(String id) {
    setState(() {
      favorites.removeWhere((item) => item['id'] == id);
    });
  }

  void handleClearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("전체 삭제"),
        content: Text("찜한 모든 항목을 삭제하시겠습니까?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("취소"),
          ),
          TextButton(
            onPressed: () {
              setState(() => favorites.clear());
              Navigator.pop(context);
            },
            child: Text("삭제"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("찜한 목록"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: favorites.isEmpty ? null : handleClearAll,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : favorites.isEmpty
          ? Center(child: Text("찜한 항목이 없습니다."))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final item = favorites[index];
          return Card(
            child: ListTile(
              leading: Image.asset(item['image']!, width: 50, height: 50),
              title: Text(item['name']!),
              trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => removeFavorite(item['id']!),
              ),
              onTap: () => Navigator.pushNamed(context, '/product-detail'),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "찜"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "장바구니"),
        ],
        currentIndex: 1,
        onTap: (index) {
          // 페이지 이동 처리
        },
      ),
    );
  }
}
