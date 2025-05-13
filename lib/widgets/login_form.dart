import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool rememberMe = false;

  void handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final url = Uri.parse("http://192.168.0.67:8081/api/auth/login");

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "userId": email,
            "password": password,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final accessToken = data['token']; // ✅ 백엔드 구조에 맞춤

          // ✅ SharedPreferences에 토큰 저장
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', accessToken);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("로그인 성공")),
          );

          Navigator.pushReplacementNamed(context, '/'); // 홈으로 이동
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("로그인 실패: ${response.body}")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("오류 발생: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("아이디", style: TextStyle(fontSize: 12, color: Colors.black54)),
          SizedBox(height: 4),
          TextFormField(
            decoration: InputDecoration(
              hintText: "아이디를 입력하세요",
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            onSaved: (value) => email = value ?? '',
            validator: (value) => value == null || value.isEmpty ? "아이디를 입력하세요" : null,
          ),
          SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("비밀번호", style: TextStyle(fontSize: 12, color: Colors.black54)),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text("비밀번호 찾기", style: TextStyle(fontSize: 12, color: Colors.blue)),
                  ),
                ],
              ),
              SizedBox(height: 4),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "비밀번호를 입력하세요",
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onSaved: (value) => password = value ?? '',
                validator: (value) => value == null || value.isEmpty ? "비밀번호를 입력하세요" : null,
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: rememberMe,
                onChanged: (value) => setState(() => rememberMe = value ?? false),
                activeColor: Colors.blue,
              ),
              Text("로그인 상태 유지"),
            ],
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text("로그인"),
          ),
          SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(child: Divider(thickness: 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("또는"),
              ),
              Expanded(child: Divider(thickness: 1)),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFEE500),
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/kakao.png', width: 18, height: 18),
                SizedBox(width: 8),
                Text("카카오로 로그인"),
              ],
            ),
          ),
          SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/google.png', width: 23, height: 23),
                SizedBox(width: 8),
                Text("구글로 로그인"),
              ],
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, '/signup'),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14),
                  children: [
                    TextSpan(text: "아직 계정이 없으신가요? ", style: TextStyle(color: Colors.black)),
                    TextSpan(text: "회원가입", style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ 다른 페이지에서 JWT 가져올 수 있도록 함수 정의
Future<String?> getAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('accessToken');
}
