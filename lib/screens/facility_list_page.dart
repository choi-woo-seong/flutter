import 'package:flutter/material.dart';

class FacilityListPage extends StatefulWidget {
  final String category;
  FacilityListPage({required this.category});

  @override
  _FacilityListPageState createState() => _FacilityListPageState();
}

class _FacilityListPageState extends State<FacilityListPage> {
  late String currentCategory;
  final List<String> categories = ['요양병원', '요양원', '실버타운'];
  final Set<int> likedIds = {}; // 찜 상태 저장용

  // 필터 상태 변수들
  String? selectedSize;
  String? selectedGrade;
  String? selectedSpecial;
  String? selectedSort;
  String searchQuery = '';


  final List<Map<String, dynamic>> allFacilities = [
    {
      'id': 1,
      'category': '요양병원',
      'name': '프레스토요양병원',
      'address': '서울특별시 강남구 도산대로 209',
      'tags': ['등급제외', '소형', '설립 8년', '재활', '치매'],
      'image': 'assets/images/modern_hospital.png',
    },
    {
      'id': 2,
      'category': '요양원',
      'name': '행복요양원',
      'address': '서울특별시 송파구 올림픽로 300',
      'tags': ['2등급', '중형', '설립 10년', '호스피스'],
      'image': 'assets/images/modern_nursing.png',
    },
    {
      'id': 3,
      'category': '실버타운',
      'name': '골든실버타운',
      'address': '경기도 성남시 수정구 성남대로 400',
      'tags': ['1등급', '대형', '설립 5년', '레저', '커뮤니티'],
      'image': 'assets/images/modern_silvertown.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    currentCategory = widget.category;
  }

  List<Map<String, dynamic>> getFilteredFacilities() {
    List<Map<String, dynamic>> filtered = allFacilities.where((facility) {
      final matchesCategory = facility['category'] == currentCategory;
      final tags = facility['tags'] as List;
      final matchesSize = selectedSize == null || tags.contains(selectedSize);
      final matchesGrade = selectedGrade == null || tags.contains(selectedGrade);
      final matchesSpecial = selectedSpecial == null || tags.contains(selectedSpecial);
      final name = facility['name'].toString();
      final address = facility['address'].toString();
      final tagText = tags.join(' ');
      final matchesSearch = searchQuery.isEmpty ||
          name.contains(searchQuery) ||
          address.contains(searchQuery) ||
          tagText.contains(searchQuery);

      return matchesCategory && matchesSize && matchesGrade && matchesSpecial && matchesSearch;
    }).toList();

    if (selectedSort != null) {
      switch (selectedSort) {
        case "추천순":
          filtered.sort((a, b) => a['id'].compareTo(b['id'])); // 예시
          break;
        case "조회순":
        case "상담많은순":
        case "후기많은순":
        case "찜많은순":
          filtered = filtered.reversed.toList(); // 예시 정렬
          break;
      }
    }

    return filtered;
  }


  void _showFilterDialog(
      String title,
      List<String> options,
      String? selected,
      void Function(String?) onSelect,
      ) {
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
                        shape: StadiumBorder(
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        onSelected: (_) {
                          setModalState(() {
                            selectedLocal = opt;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setModalState(() => selectedLocal = null);
                        },
                        child: Text("초기화", style: TextStyle(color: Colors.black)),
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          onSelect(selectedLocal); // 부모에 값 전달
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
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
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4 - 20, // ✅ 한 줄에 4개 배치되도록 너비 조정
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          side: BorderSide(color: Colors.white),
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(fontSize: 12)),
            Icon(Icons.arrow_drop_down),
          ],
        ),
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 28, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: DropdownButtonHideUnderline(
          child: Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.white),
            child: DropdownButton<String>(
              value: currentCategory,
              onChanged: (value) {
                if (value != null) setState(() => currentCategory = value);
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
                      Text(category, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() => searchQuery = value);
                  },
                  decoration: InputDecoration(
                    hintText: "검색어 입력",
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildFilterButton(
                      "시설규모",
                          () => _showFilterDialog(
                        "시설규모",
                        ["대형", "중형", "소형"],
                        selectedSize,
                            (v) => setState(() => selectedSize = v),
                      ),
                    ),
                    _buildFilterButton(
                      "평가등급",
                          () => _showFilterDialog(
                        "평가등급",
                        ["1등급", "2등급", "3등급", "4등급", "5등급", "등급제외"],
                        selectedGrade,
                            (v) => setState(() => selectedGrade = v),
                      ),
                    ),
                    _buildFilterButton(
                      "특화영역",
                          () => _showFilterDialog(
                        "특화영역",
                        ["재활", "치매", "호스피스", "장기입원"],
                        selectedSpecial,
                            (v) => setState(() => selectedSpecial = v),
                      ),
                    ),
                    _buildFilterButton(
                      "정렬방식",
                          () => _showFilterDialog(
                        "정렬방식",
                        ["추천순", "조회순", "상담많은순", "후기많은순", "찜많은순"],
                        selectedSort,
                            (v) => setState(() => selectedSort = v),
                      ),
                    ),
                  ],

                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];
                final isLiked = likedIds.contains(item['id']);

                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(12),
                  child: Stack(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 16, right: 56, top: 12, bottom: 12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item['image'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 80),
                          ),
                        ),
                        title: Text(item['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['address'], style: TextStyle(fontSize: 12)),
                            Wrap(
                              spacing: 6,
                              children: item['tags'].map<Widget>((tag) => Chip(
                                label: Text(tag, style: TextStyle(fontSize: 10)),
                                backgroundColor: Colors.grey[100],
                              )).toList(),
                            ),
                          ],
                        ),
                        onTap: () => Navigator.pushNamed(context, '/facility-detail', arguments: item),
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
}
