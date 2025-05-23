import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FacilityListPage extends StatefulWidget {
  final String category;
  FacilityListPage({required this.category});

  @override
  _FacilityListPageState createState() => _FacilityListPageState();

}

class _FacilityListPageState extends State<FacilityListPage> {

  // 한글 라벨을 백엔드 코드로 매핑
  final Map<String, String> sizeLabelToCode = {
    "대형": "LARGE",
    "중형": "MEDIUM",
    "소형": "SMALL",
  };

  final Map<String, String> gradeLabelToCode = {
    "A": "1",
    "B": "2",
    "C": "3",
    "D": "4",
    "E": "5",
    "등급제외": "등급제외",  // 빈 문자열이면 등급 제외
  };

  // 백엔드 코드 → 한글/영문 라벨 (새로 추가)
  final Map<String, String> codeToGradeLabel = {
    "1": "A",
    "2": "B",
    "3": "C",
    "4": "D",
    "5": "E",
    "등급제외": "등급제외",
  };

  late String currentCategory;
  List<Map<String, dynamic>> allFacilities = [];

  final List<String> categories = ['요양병원', '요양원', '실버타운'];
  final Set<int> likedIds = {}; // ✅ 초기 찜 ID 저장용

  String? selectedSize;
  String? selectedGrade;
  String? selectedSort;
  String searchQuery = '';

  final Map<String, String> categoryToTypeMap = {
    '요양병원': 'NURSING_HOSPITAL',
    '요양원': 'NURSING_HOME',
    '실버타운': 'SILVER_TOWN',
  };

  @override
  void initState() {
    super.initState();
    currentCategory = widget.category;
    fetchFacilities(currentCategory);
    initLikedIds(); // ✅ 찜된 ID들 초기 세팅
  }

  // ✅ 찜한 시설 ID 목록 가져오기
  Future<void> initLikedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null) return;

    final res = await http.get(
      Uri.parse("http://192.168.0.83:8081/api/bookmarks"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(res.bodyBytes));
      setState(() {
        likedIds.addAll(data.map<int>((e) => e['facilityId'] as int));
      });
    } else {
      print("❌ 찜 ID 초기화 실패: ${res.statusCode}");
    }
  }

  Future<void> fetchFacilities(String category) async {
    final apiType = categoryToTypeMap[category] ?? 'NURSING_HOSPITAL';
    final String? sizeCode = selectedSize != null
        ? sizeLabelToCode[selectedSize!]
        : null;

    // 서버엔 type, size 만 전달
    final params = {
      'type': apiType,
      if (sizeCode != null) 'size': sizeCode,
    };

    final uri = Uri.http('192.168.0.83:8081', '/api/facility', params);
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      setState(() {
        allFacilities = List<Map<String, dynamic>>.from(
            json.decode(utf8.decode(res.bodyBytes))
        );
      });
    } else {
      print("❌ 시설 목록 로드 실패: ${res.statusCode}");
    }
  }





  // ✅ 찜 추가/해제
  Future<void> toggleLike(dynamic facilityIdRaw) async {
    final facilityId = (facilityIdRaw is int)
        ? facilityIdRaw
        : int.tryParse(facilityIdRaw.toString());

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null || facilityId == null) return;

    final isLiked = likedIds.contains(facilityId);
    final url = Uri.parse("http://192.168.0.83:8081/api/bookmarks/$facilityId");

    final res = await (isLiked
        ? http.delete(url, headers: {"Authorization": "Bearer $token"})
        : http.post(url, headers: {"Authorization": "Bearer $token"}));

    print("🔁 요청 상태: ${res.statusCode}");

    if (res.statusCode == 200 || res.statusCode == 204) {
      setState(() {
        isLiked ? likedIds.remove(facilityId) : likedIds.add(facilityId);
      });
    } else {
      print("❌ 찜 처리 실패: ${res.statusCode}");
    }
  }

  List<Map<String, dynamic>> getFilteredFacilities() {
    return allFacilities.where((f) {
      final sizeValue  = f['facilitySize']?.toString() ?? '';
      final gradeValue = f['grade']?.toString()       ?? '';
      final name       = f['name']?.toString()        ?? '';
      final address    = f['address']?.toString()     ?? '';

      // size 필터 (기존)
      final String? sizeCode = selectedSize != null
          ? sizeLabelToCode[selectedSize!]
          : null;
      final matchesSize = sizeCode == null || sizeValue == sizeCode;

      // grade 필터: A~E vs 등급제외 vs 미선택
      bool matchesGrade;
      if (selectedGrade == null) {
        // 필터 미선택
        matchesGrade = true;
      } else if (selectedGrade == "등급제외") {
        // grade 값이 없거나 빈 문자열인 것만
        matchesGrade = gradeValue.isEmpty;
      } else {
        // A~E 선택 시, 코드 비교
        final code = gradeLabelToCode[selectedGrade]!;
        matchesGrade = gradeValue == code;
      }

      // 검색어 필터 (기존)
      final matchesSearch = searchQuery.isEmpty
          || name.contains(searchQuery)
          || address.contains(searchQuery);

      return matchesSize && matchesGrade && matchesSearch;
    }).toList()
      ..sort((a, b) {
        if (selectedSort == "추천순") {
          return a['id'].compareTo(b['id']);
        }
        return 0;
      });
  }





  void _showFilterDialog(String title, List<String> options, String? selected, void Function(String?) onSelect) {
    showDialog(
      context: context,
      builder: (context) {
        String? selectedLocal = selected;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: TextStyle(color: Colors.black)),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 8,
                    children: options.map((opt) {
                      final isSelected = selectedLocal == opt;
                      return ChoiceChip(
                        label: Text(
                          opt,
                          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                        ),
                        selected: isSelected,
                        showCheckmark: false,
                        selectedColor: Colors.blue,
                        backgroundColor: Colors.white,
                        shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
                        onSelected: (_) {
                          setModalState(() => selectedLocal = opt);
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => setModalState(() => selectedLocal = null),
                        child: Text("초기화", style: TextStyle(color: Colors.black)),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          onSelect(selectedLocal);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                        child: Text("적용하기"),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterButton(String label, void Function() onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        side: BorderSide(color: Colors.grey.shade300),
        shape: StadiumBorder(),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 12)),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  String _resolveImageUrl(String url) {
    if (url.startsWith("http")) return url;
    return "http://192.168.0.83:8081$url";
  }

  @override
  Widget build(BuildContext context) {
    final filtered = getFilteredFacilities();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: DropdownButtonHideUnderline(
          child: // build() 안의 AppBar > DropdownButton
          DropdownButton<String>(
            value: currentCategory,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  currentCategory  = value;
                  selectedSize     = null;  // ← 이전 필터 초기화
                  selectedGrade    = null;  // ← 이전 필터 초기화
                  selectedSort     = null;  // ← (원하시면 정렬도 초기화)
                  searchQuery      = '';    // ← (원하시면 검색어도 초기화)
                });
                fetchFacilities(value);
              }
            },
            items: categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/${category == '요양병원' ? 'hospital' : category == '요양원' ? 'nursing' : 'silvertown'}.png',
                      width: 20, height: 20,
                    ),
                    SizedBox(width: 6),
                    Text(category, style: TextStyle(fontSize: 18)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: InputDecoration(
                  hintText: "검색어 입력",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                _buildFilterButton(
                  "시설규모",
                      () => _showFilterDialog(
                    "시설규모",
                    ["대형", "중형", "소형"],
                    selectedSize,
                        (v) {
                      setState(() => selectedSize = v);
                      fetchFacilities(currentCategory);
                    },
                  ),
                ),
                SizedBox(width: 8),
                _buildFilterButton(
                  "평가등급",
                      () => _showFilterDialog(
                    "평가등급",
                    ["A", "B", "C", "D", "E", "등급제외"],
                    selectedGrade,
                        (v) => setState(() {
                      // “등급제외”면 null, 아니면 그대로
                      selectedGrade = (v == "등급제외") ? null : v;
                      // 서버 재호출은 필요 없습니다
                    }),
                  ),
                ),


                Spacer(),
                _buildFilterButton(
                  "추천순",
                      () => _showFilterDialog(
                    "정렬방식",
                    ["조회순", "리뷰순", "찜많은순"],
                    selectedSort,
                        (v) {
                      setState(() => selectedSort = v);
                      fetchFacilities(currentCategory);
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];
                final isLiked = likedIds.contains(item['id']);
                String? imageUrl;

                if (item['imageUrls'] != null && item['imageUrls'] is List && item['imageUrls'].isNotEmpty) {
                  imageUrl = item['imageUrls'][0];
                } else if (item['image'] != null) {
                  imageUrl = item['image'];
                }

                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(12),
                  child: Stack(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 16, right: 56, top: 12, bottom: 12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: (imageUrl != null && imageUrl.toString().isNotEmpty)
                              ? Image.network(
                            _resolveImageUrl(imageUrl),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 80),
                          )
                              : Icon(Icons.image_not_supported, size: 80),
                        ),
                        title: Text(item['name'] ?? ''),
                        subtitle: Text(item['address'] ?? ''),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/facility-detail',
                            arguments: item['id'].toString(),
                          );
                        },
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => toggleLike(item['id']),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
