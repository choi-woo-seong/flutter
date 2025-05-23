import 'package:flutter/material.dart';
import 'package:msy/screens/home_page.dart';
import 'screens/products_page.dart';
import 'screens/product_detail_page.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/signup_email_page.dart';
import 'screens/signup_password_page.dart';
import 'screens/signup_end_page.dart';
import 'screens/forgot_password_page.dart';
import 'screens/facility_detail_page.dart';
import 'screens/facility_cost_page.dart';
import 'screens/favorites_page.dart';
import 'screens/cart_page.dart';
import 'screens/cart_success_page.dart';
import 'screens/notices_page.dart';
import 'screens/notice_detail_page.dart';
import 'screens/videos_page.dart';
import 'screens/facility_list_page.dart';
import 'screens/care_grade_test_page.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('❌ Flutter Error: ${details.exception}');
  };

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '요양시설 정보 서비스',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/products': (context) => ProductsPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/signup-password': (context) => SignupPasswordPage(),
        '/signup-end': (context) => SignupEndPage(),
        '/forgot-password': (context) => ForgotPasswordPage(),
        '/facility-list': (context) => FacilityListPage(category: '요양병원'),
        '/facility-cost': (context) => FacilityCostPage(),
        '/favorites': (context) => FavoritesPage(),
        '/cart': (context) => CartPage(),
        '/cart-success': (context) => CartSuccessPage(),
        '/notices': (context) => NoticesPage(),
        '/videos': (context) => VideosPage(),
        '/care-test': (context) => CareGradeTestPage(),
      },
      onGenerateRoute: (settings) {
        // ✅ 상품 상세 페이지
        if (settings.name == '/product-detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ProductDetailPage(),
            settings: RouteSettings(arguments: args),
          );
        }

        // 이메일 인증 페이지
        if (settings.name == '/signup-email') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => SignupEmailPage(userData: args),
          );
        }

        // 공지사항 상세 페이지
        if (settings.name == '/notices-detail') {
          final notice = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => NoticeDetailPage(notice: notice),
          );
        }

        // 시설 상세 페이지
        if (settings.name == '/facility-detail') {
          final facilityId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => FacilityDetailPage(facilityId: facilityId),
          );
        }

        return null;
      },
    );
  }
}
