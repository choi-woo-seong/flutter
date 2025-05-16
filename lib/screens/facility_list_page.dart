import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FacilityListPage extends StatefulWidget {
  final String category;
  FacilityListPage({required this.category});

  @override
  _FacilityListPageState createState() => _FacilityListPageState();
}

class _FacilityListPageState extends State<FacilityListPage> {
  late String currentCategory;
  List<Map<String, dynamic>> allFacilities = [];

  final List<String> categories = ['요양병원', '요양원', '실버타운'];
  final Set<int> likedIds = {};

  String? selectedSize;
  String? selectedGrade;
  String? selectedSort;
  String searchQuery = '';

  final Map<String, String> categoryToTypeMap = {
    '요양병원': 'NURSING_HOSPITAL',
    '요양원': 'NURSING_HOME',
    '실버타운': 'SILVERTOWN',
  };

  @override
  void initState() {
    super.initState();
    currentCategory = widget.category;
    fetchFacilities(currentCategory);
  }

  Future<void> fetchFacilities(String category) async {
    try {
      final apiType = categoryToTypeMap[category] ?? 'NURSING_HOSPITAL';
      final url = Uri.parse("http://192.168.0.83:8081/api/facility?type=$apiType");
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(res.bodyBytes));
        setState(() {
          allFacilities = data.cast<Map<String, dynamic>>();
        });
      } else {
        print("❌ 실패: \${res.statusCode}");
      }
    } catch (e) {
      print("❌ 오류 발생: $e");
    }
  }

  List<Map<String, dynamic>> getFilteredFacilities() {
    return allFacilities.where((facility) {
      final tags = (facility['tags'] is List) ? facility['tags'] as List : [];
      final name = facility['name']?.toString() ?? '';
      final address = facility['address']?.toString() ?? '';
      final tagText = tags.join(' ');

      final matchesSize = selectedSize == null || tags.contains(selectedSize);
      final matchesGrade = selectedGrade == null || tags.contains(selectedGrade);
      final matchesSearch = searchQuery.isEmpty ||
          name.contains(searchQuery) ||
          address.contains(searchQuery) ||
          tagText.contains(searchQuery);

      return matchesSize && matchesGrade && matchesSearch;
    }).toList()
      ..sort((a, b) {
        if (selectedSort == "추천순") return a['id'].compareTo(b['id']);
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

  @override
  Widget build(BuildContext context) {
    final filtered = getFilteredFacilities();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: currentCategory,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  currentCategory = value;
                  fetchFacilities(currentCategory);
                });
              }
            },
            items: categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/${category == '요양병원' ? 'hospital' : category == '요양원' ? 'nursing' : 'silvertown'}.png',
                      width: 20,
                      height: 20,
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
                _buildFilterButton("시설규모", () => _showFilterDialog("시설규모", ["대형", "중형", "소형"], selectedSize, (v) => setState(() => selectedSize = v))),
                SizedBox(width: 8),
                _buildFilterButton("평가등급", () => _showFilterDialog("평가등급", ["A", "B", "C", "D", "E", "등급제외"], selectedGrade, (v) => setState(() => selectedGrade = v))),
                Spacer(),
                _buildFilterButton("추천순", () => _showFilterDialog("정렬방식", ["조회순", "상담많은순", "찜많은순"], selectedSort, (v) => setState(() => selectedSort = v))),
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
                          onPressed: () => setState(() {
                            isLiked ? likedIds.remove(item['id']) : likedIds.add(item['id']);
                          }),
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

  String _resolveImageUrl(String url) {
    if (url.startsWith("http")) return url;
    return "http://192.168.0.83:8081$url";
  }
}
