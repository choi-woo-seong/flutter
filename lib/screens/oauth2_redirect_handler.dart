import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OAuth2RedirectHandler extends StatefulWidget {
  final Uri uri;

  const OAuth2RedirectHandler({super.key, required this.uri});

  @override
  State<OAuth2RedirectHandler> createState() => _OAuth2RedirectHandlerState();
}

class _OAuth2RedirectHandlerState extends State<OAuth2RedirectHandler> {
  @override
  void initState() {
    super.initState();
    handleOAuthRedirect();
  }

  Future<void> handleOAuthRedirect() async {
    final token = widget.uri.queryParameters['token'];
    final error = widget.uri.queryParameters['error'];

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("소셜 로그인 실패: $error")),
      );
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', token);

      // 향후 관리자 체크 로직 가능
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
