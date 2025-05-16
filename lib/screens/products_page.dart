import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Map<String, dynamic>> products = [];
  bool showFilters = false;
  String selectedSort = "인기순";
  String selectedCategory = "전체";
  String searchQuery = "";

  final List<String> sortOptions = ["인기순", "최신순", "가격 낮은순", "가격 높은순"];
  final List<String> categories = ["전체", "이동보조", "욕실용품", "침실용품", "일상생활용품", "의료용품"];
  final numberFormat = NumberFormat("#,###", "ko_KR");

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final url = Uri.parse('http://192.168.0.83:8081/api/products');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          products = data.cast<Map<String, dynamic>>();
        });
      } else {
        print("📛 상품 불러오기 실패: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ 상품 로드 중 오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProducts = products.where((p) {
      final matchesCategory =
          selectedCategory == "전체" || p['categoryName'] == selectedCategory;
      final matchesSearch = searchQuery.isEmpty ||
          p['name']?.toString().contains(searchQuery) == true;
      return matchesCategory && matchesSearch;
    }).toList();

    if (selectedSort == "가격 낮은순") {
      filteredProducts.sort((a, b) =>
          _parsePrice(a['discountPrice']).compareTo(_parsePrice(b['discountPrice'])));
    } else if (selectedSort == "가격 높은순") {
      filteredProducts.sort((a, b) =>
          _parsePrice(b['discountPrice']).compareTo(_parsePrice(a['discountPrice'])));
    } else if (selectedSort == "최신순") {
      filteredProducts.sort((a, b) {
        final aDate = DateTime.tryParse(a['createdAt'] ?? '') ?? DateTime(2000);
        final bDate = DateTime.tryParse(b['createdAt'] ?? '') ?? DateTime(2000);
        return bDate.compareTo(aDate);
      });
    } else if (selectedSort == "인기순") {
      filteredProducts.sort((a, b) =>
          (b['popularity'] ?? 0).compareTo(a['popularity'] ?? 0));
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
                        child: DropdownButton<String>(
                          value: selectedSort,
                          onChanged: (value) => setState(() => selectedSort = value!),
                          items: sortOptions
                              .map((sort) => DropdownMenuItem(value: sort, child: Text(sort)))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showFilters)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((category) {
                  final isSelected = category == selectedCategory;
                  return ChoiceChip(
                    label: Text(
                      category,
                      style: TextStyle(color: isSelected ? Colors.white : Colors.black),
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
                final p = filteredProducts[index];
                final image = _getProductImage(p);

                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/product-detail',
                      arguments: {'id': p['id']},
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          image,
                          SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    p['name'] ?? '',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${_formatPrice(p['discountPrice'])}원",
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "${_formatPrice(p['price'])}원",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int _parsePrice(dynamic price) {
    if (price == null) return 0;
    if (price is int) return price;
    if (price is double) return price.toInt();
    return int.tryParse(price.toString().replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
  }

  String _formatPrice(dynamic price) {
    return numberFormat.format(_parsePrice(price));
  }

  String _resolveImageUrl(String rawUrl) {
    if (rawUrl.startsWith('http')) return rawUrl;
    return "http://192.168.0.83:8081$rawUrl";
  }

  Widget _getProductImage(Map<String, dynamic> p) {
    String? imageUrl;

    if (p['imageUrls'] != null &&
        p['imageUrls'] is List &&
        p['imageUrls'].isNotEmpty) {
      imageUrl = p['imageUrls'][0];
    } else if (p['images'] != null &&
        p['images'] is List &&
        p['images'].isNotEmpty) {
      imageUrl = p['images'][0];
    } else if (p['imageUrl'] != null) {
      imageUrl = p['imageUrl'];
    } else if (p['image'] != null) {
      imageUrl = p['image'];
    }

    return imageUrl != null
        ? Image.network(_resolveImageUrl(imageUrl),
        width: 80, height: 80, fit: BoxFit.cover)
        : Icon(Icons.image_not_supported, size: 50);
  }
}
