import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupPasswordPage extends StatefulWidget {
  @override
  _SignupPasswordPageState createState() => _SignupPasswordPageState();
}

class _SignupPasswordPageState extends State<SignupPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String password = '';
  String confirmPassword = '';
  String error = '';

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (password != confirmPassword) {
        setState(() => error = "비밀번호가 일치하지 않습니다.");
        return;
      }

      final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      final username = args['username']!;
      final email = args['email']!;
      final phone = args['phone']!;

      final response = await http.post(
        Uri.parse("http://192.168.0.67:8081/api/auth/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": username,
          "email": email,
          "phone": phone,
          "password": password,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.pushNamed(context, '/signup-end');
      } else {
        setState(() => error = "회원가입 실패: ${response.body}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("비밀번호 설정"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Container(
            constraints: BoxConstraints(maxWidth: 400),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("비밀번호", style: TextStyle(fontSize: 12, color: Colors.black54)),
                  SizedBox(height: 6),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "비밀번호 입력 (8자 이상)",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (val) => val != null && val.length >= 8 ? null : "8자 이상 입력",
                    onSaved: (val) => password = val ?? '',
                  ),
                  SizedBox(height: 16),
                  Text("비밀번호 확인", style: TextStyle(fontSize: 12, color: Colors.black54)),
                  SizedBox(height: 6),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "비밀번호 다시 입력",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (val) => val != null && val.isNotEmpty ? null : "확인 입력",
                    onSaved: (val) => confirmPassword = val ?? '',
                  ),
                  if (error.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Text(error, style: TextStyle(color: Colors.red)),
                  ],
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text("완료"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
