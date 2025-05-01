import 'package:flutter/material.dart';
import 'package:mo/screens/home_page.dart';
import 'screens/products_page.dart';
import 'screens/product_detail_page.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/forgot_password_page.dart';
import 'screens/facility_detail_page.dart';
import 'screens/facility_review_page.dart';
import 'screens/facility_question_page.dart';
import 'screens/facility_cost_page.dart';
import 'screens/favorites_page.dart';
import 'screens/cart_page.dart';
import 'screens/notices_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '요양시설 정보 서비스',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/products': (context) => ProductsPage(),
        '/product-detail': (context) => ProductDetailPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/forgot-password': (context) => ForgotPasswordPage(),
        '/facility-detail': (context) => FacilityDetailPage(),
        '/facility-review': (context) => FacilityReviewPage(),
        '/facility-question': (context) => FacilityQuestionPage(),
        '/facility-cost': (context) => FacilityCostPage(),
        '/favorites': (context) => FavoritesPage(),
        '/cart': (context) => CartPage(),
        '/notices': (context) => NoticesPage(),
      },
    );
  }
}
