import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/facility_type_grid.dart';
import '../widgets/faq_section.dart';
import '../widgets/promotion_section.dart';
import '../widgets/notice_bar.dart';
import '../widgets/video_section.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/care_grade_test_banner.dart';
import '../widgets/home_product_section.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  bool isLoggedIn = false;
  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    setState(() {
      isLoggedIn = token != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          title: _isSearching
              ? TextField(
            controller: _searchController,
            decoration: InputDecoration(hintText: '검색어를 입력하세요', border: InputBorder.none),
            autofocus: true,
            onSubmitted: (value) => print('검색어: $value'),
          )
              : Image.asset('assets/images/logo.png', height: 40),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          scrolledUnderElevation: 0,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () => setState(() => _isSearching = !_isSearching),
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
                child: Text('메뉴', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              if (!isLoggedIn)
                ListTile(
                  leading: Icon(Icons.login),
                  title: Text('로그인'),
                  onTap: () => Navigator.pushNamed(context, '/login'),
                ),
              if (!isLoggedIn)
                ListTile(
                  leading: Icon(Icons.person_add),
                  title: Text('회원가입'),
                  onTap: () => Navigator.pushNamed(context, '/signup'),
                ),
              if (isLoggedIn)
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('로그아웃'),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('accessToken');
                    setState(() => isLoggedIn = false);
                    Navigator.pop(context); // 드로어 닫기
                  },
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
            HomeProductSection(),
            FaqSection(),
          ],
        ),
        bottomNavigationBar: BottomNavigation(currentIndex: 0),
      ),
    );
  }

}
