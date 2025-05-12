import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ 추가: 상태바 색상 고정용
import '../widgets/facility_type_grid.dart';
import '../widgets/faq_section.dart';
import '../widgets/promotion_section.dart';
import '../widgets/notice_bar.dart';
import '../widgets/video_section.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/care_grade_test_banner.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> products = [
    {
      'id': '1',
      'name': '실버워커 (바퀴X) 노인용 보행기 경량 접이식 보행보조기',
      'price': '220,000원',
      'discount': '80%',
      'image': 'assets/images/supportive.png',
    },
    {
      'id': '2',
      'name': '의료용 실버워커(MASSAGE 722F) 노인용 보행기',
      'price': '100,000원',
      'discount': '50%',
      'image': 'assets/images/elderly.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // ✅ 상태바 배경 흰색
        statusBarIconBrightness: Brightness.dark, // ✅ 아이콘 검정
      ),
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          title: _isSearching
              ? TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '검색어를 입력하세요',
              border: InputBorder.none,
            ),
            autofocus: true,
            onSubmitted: (value) {
              print('검색어: $value');
            },
          )
              : Image.asset('assets/images/logo.png', height: 40),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white, // ✅ 이거 없으면 회색 비침 가능
          scrolledUnderElevation: 0,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black), // ✅ 아이콘 색상도 고정
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
            ),
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
          ],
        ),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  '메뉴',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: Icon(Icons.login),
                title: Text('로그인'),
                onTap: () => Navigator.pushNamed(context, '/login'),
              ),
              ListTile(
                leading: Icon(Icons.person_add),
                title: Text('회원가입'),
                onTap: () => Navigator.pushNamed(context, '/signup'),
              ),
              ListTile(
                leading: Icon(Icons.home_work),
                title: Text('시설 목록'),
                onTap: () => Navigator.pushNamed(context, '/facility-list'),
              ),
              ListTile(
                leading: Icon(Icons.shopping_bag),
                title: Text('상품 목록'),
                onTap: () => Navigator.pushNamed(context, '/products'),
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('공지사항'),
                onTap: () => Navigator.pushNamed(context, '/notices'),
              ),
            ],
          ),
        ),
        body: ListView(
          children: [
            Divider(height: 1, color: Colors.grey.shade300),
            NoticeBar(),
            Divider(height: 1, color: Colors.grey.shade300),
            PromotionSection(),
            FacilityTypeGrid(),
            VideoSection(),
            CareGradeTestBanner(),
            _buildProductSection(context),
            FaqSection(),
          ],
        ),
        bottomNavigationBar: BottomNavigation(currentIndex: 0),
      ),
    );
  }

  Widget _buildProductSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("인기 제품 추천 상품",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "요양원 입소 전 준비하세요.",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      padding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/products');
                    },
                    child: Text("스토어 바로가기 >",
                        style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Container(
                    width: 170,
                    margin: EdgeInsets.only(right: 12),
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/product-detail');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                  child: Image.asset(
                                    product['image']!,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name']!,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    product['price']!,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    product['discount']!,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12),
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
      ),
    );
  }
}
