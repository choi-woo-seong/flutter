// 생략된 import 동일
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final res = await http.get(
        Uri.parse("http://192.168.0.83:8081/api/bookmarks"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(res.bodyBytes));
        setState(() {
          favorites = data.map<Map<String, String>>((item) => {
            'id': item['facilityId'].toString(),
            'name': item['name'] ?? '이름 없음',
            'image': item['imageUrls'] ?? '',
          }).toList();
          isLoading = false;
        });
      } else {
        print("❌ 찜 목록 조회 실패: ${res.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("❌ 예외 발생: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> toggleLike(int facilityId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) return;

    final url = Uri.parse("http://192.168.0.83:8081/api/bookmarks/$facilityId");

    try {
      final res = await http.delete(
        url,
        headers: {"Authorization": "Bearer $token"},
      );
      print("🗑️ 찜 삭제 응답 코드: ${res.statusCode}");
    } catch (e) {
      print("❌ 찜 삭제 예외: $e");
    }
  }

  void removeFavorite(String id) {
    setState(() {
      favorites.removeWhere((item) => item['id'] == id);
    });
  }

  // ✅ 전체 삭제 (deleteAll 경로로 수정 완료)
  void clearFavorites() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("전체 삭제"),
        content: Text("찜한 모든 항목을 삭제하시겠습니까?"),
        actions: [
          // 취소 버튼 글씨 검정으로 스타일 적용
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, // 텍스트 검정
            ),
            child: Text("취소"),
          ),
          TextButton(
            onPressed: () async {
              try {
                final prefs = await SharedPreferences.getInstance();
                final token = prefs.getString('accessToken') ?? '';
                final res = await http.delete(
                  Uri.parse("http://192.168.0.83:8081/api/bookmarks/deleteAll"),
                  headers: {"Authorization": "Bearer $token"},
                );
                if (res.statusCode == 200 || res.statusCode == 204) {
                  setState(() => favorites.clear());
                } else {
                  print("❌ 전체 삭제 실패: ${res.statusCode}");
                }
              } catch (e) {
                print("❌ 예외 발생: $e");
              }
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
          if (favorites.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: clearFavorites,
              tooltip: "전체 삭제",
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
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: item['image'] != null && item['image']!.isNotEmpty
                  ? Image.network(item['image']!, width: 50, height: 50)
                  : Icon(Icons.image, size: 50),
              title: Text(item['name'] ?? ''),
              trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () async {
                  final id = int.tryParse(item['id'] ?? '');
                  if (id != null) {
                    await toggleLike(id);
                    removeFavorite(item['id']!);
                  }
                },
              ),
              onTap: () => Navigator.pushNamed(context, '/facility-detail', arguments: item['id']),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigation(currentIndex: 1),
    );
  }
}
