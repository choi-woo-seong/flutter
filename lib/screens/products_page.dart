import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Map<String, String>> products = [];
  bool showFilters = false;
  String selectedSort = "인기순";
  String selectedCategory = "전체";
  String searchQuery = ""; // ✅ 검색어 상태 추가

  final List<String> sortOptions = ["인기순", "최신순", "가격 낮은순", "가격 높은순"];
  final List<String> categories = ["전체", "보행보조기", "침대", "목욕용품", "지팡이", "휠체어"];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        products = [
          {
            'id': '1',
            'name': '실버워커 (바퀴X) 노인용 보행기 경량 접이식 보행보조기',
            'price': '220,000원',
            'discount': '80%',
            'image': 'assets/images/supportive.png',
            'category': '보행보조기',
          },
          {
            'id': '2',
            'name': '의료용 실버워커(MASSAGE 722F) 노인용 보행기',
            'price': '100,000원',
            'discount': '50%',
            'image': 'assets/images/elderly.png',
            'category': '보행보조기',
          },
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 카테고리 + 검색 + 정렬 반영한 필터
    List<Map<String, String>> filteredProducts = products.where((p) {
      final matchesCategory = selectedCategory == "전체" || p['category'] == selectedCategory;
      final matchesSearch = searchQuery.isEmpty || p['name']!.contains(searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();

    // ✅ 간단한 정렬 예시
    if (selectedSort == "가격 낮은순") {
      filteredProducts.sort((a, b) =>
          _parsePrice(a['price']!).compareTo(_parsePrice(b['price']!)));
    } else if (selectedSort == "가격 높은순") {
      filteredProducts.sort((a, b) =>
          _parsePrice(b['price']!).compareTo(_parsePrice(a['price']!)));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        leading: BackButton(),
        title: Text("요양용품 스토어", style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => setState(() => searchQuery = value),
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
                SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => setState(() => showFilters = !showFilters),
                      icon: Icon(Icons.filter_list, color: Colors.black),
                      label: Text("필터", style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey.shade300),
                        elevation: 0,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Theme(
                          data: Theme.of(context).copyWith(canvasColor: Colors.white),
                          child: DropdownButton<String>(
                            value: selectedSort,
                            onChanged: (value) => setState(() => selectedSort = value!),
                            items: sortOptions.map((sort) => DropdownMenuItem(
                              value: sort,
                              child: Text(sort),
                            )).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (showFilters)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  final isSelected = category == selectedCategory;
                  return ChoiceChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => setState(() => selectedCategory = category),
                    selectedColor: Colors.blue,
                    backgroundColor: Colors.white,
                    shape: StadiumBorder(
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    showCheckmark: false,
                  );
                }).toList(),
              ),
            ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: Image.asset(product['image']!, width: 50, height: 50),
                    title: Text(product['name']!),
                    subtitle: Text("가격: ${product['price']} (할인: ${product['discount']})"),
                    onTap: () => Navigator.pushNamed(context, '/product-detail'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int _parsePrice(String price) {
    return int.tryParse(price.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
  }
}
