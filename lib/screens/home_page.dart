import 'package:flutter/material.dart';
import '../widgets/facility_type_grid.dart';
import '../widgets/faq_section.dart';
import '../widgets/promotion_section.dart';
import '../widgets/notice_bar.dart';
import '../widgets/video_section.dart';
import '../widgets/bottom_navigation.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, String>> products = [
    {
      'id': '1',
      'name': '실버워커 (바퀴X) 노인용 보행기 경량 접이식 보행보조기',
      'price': '220,000원',
      'discount': '80%',
      'image': 'assets/images/supportive-stroll.png',
    },
    {
      'id': '2',
      'name': '의료용 실버워커(MASSAGE 722F) 노인용 보행기',
      'price': '100,000원',
      'discount': '50%',
      'image': 'assets/images/elderly-woman-using-walker.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo.png', height: 40),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          NoticeBar(),
          PromotionSection(),
          FacilityTypeGrid(),
          _buildProductSection(context),
          VideoSection(),
          FaqSection(),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Widget _buildProductSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("추천 보조기기", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Column(
            children: products.map((product) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Image.asset(product['image']!, width: 50, height: 50),
                  title: Text(product['name']!),
                  subtitle: Text("가격: ${product['price']} (할인: ${product['discount']})"),
                  onTap: () {
                    Navigator.pushNamed(context, '/product-detail');
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
