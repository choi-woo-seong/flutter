import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';

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
            'name': '포레스토 요양병원',
            'image': 'assets/images/modern_hospital.png',
          },
          {
            'id': '2',
            'name': '행복 요양원',
            'image': 'assets/images/modern_nursing.png',
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
        backgroundColor: Colors.white,
        title: Text("전체 삭제", style: TextStyle(color: Colors.black)),
        content: Text("찜한 모든 항목을 삭제하시겠습니까?", style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("취소", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              setState(() => favorites.clear());
              Navigator.pop(context);
            },
            child: Text("삭제", style: TextStyle(color: Colors.red)),
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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
      bottomNavigationBar: BottomNavigation(currentIndex: 1),
    );
  }
}
