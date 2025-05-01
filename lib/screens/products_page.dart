import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Map<String, String>> products = [];
  bool showFilters = false;

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
            'image': 'assets/images/supportive-stroll.png',
            'category': '보행보조기',
          },
          {
            'id': '2',
            'name': '의료용 실버워커(MASSAGE 722F) 노인용 보행기',
            'price': '100,000원',
            'discount': '50%',
            'image': 'assets/images/elderly-woman-using-walker.png',
            'category': '보행보조기',
          },
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("보조기기 목록"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          if (showFilters) _buildFilterSection(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Image.asset(product['image']!, width: 50, height: 50),
                    title: Text(product['name']!),
                    subtitle: Text("가격: ${product['price']} (할인: ${product['discount']})"),
                    trailing: Icon(Icons.favorite_border),
                    onTap: () => Navigator.pushNamed(context, '/product-detail'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_list),
        onPressed: () {
          setState(() {
            showFilters = !showFilters;
          });
        },
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Text("필터 (예: 가격, 카테고리 등)", style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          // 여기에 실제 필터 UI 위젯 추가 가능
        ],
      ),
    );
  }
}
