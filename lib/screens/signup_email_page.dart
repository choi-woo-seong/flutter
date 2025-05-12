import 'package:flutter/material.dart';

class SignupEmailPage extends StatefulWidget {
  final String email; // 이전 페이지에서 넘긴 이메일

  SignupEmailPage({required this.email});

  @override
  _SignupEmailPageState createState() => _SignupEmailPageState();
}

class _SignupEmailPageState extends State<SignupEmailPage> {
  final _formKey = GlobalKey<FormState>();
  String verificationCode = '';

  void handleVerify() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: 인증 코드 검증 로직 또는 서버 요청
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("인증 성공"),
        backgroundColor: Colors.blue,
        ),
      );
      // 다음 페이지로 이동
      Navigator.pushNamed(context, '/signup-password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("이메일 인증"),
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
                  Text(
                    "입력하신 이메일로 인증번호가 발송되었습니다.\n이메일 주소: ${widget.email}",
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(height: 24),
                  Text("인증번호", style: TextStyle(fontSize: 12, color: Colors.black54)),
                  SizedBox(height: 6),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "인증번호 입력",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder( // ✅ 포커스 시 파란 테두리
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    validator: (value) => value != null && value.length == 6 ? null : "6자리 인증번호를 입력하세요.",
                    onSaved: (val) => verificationCode = val ?? '',
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: handleVerify,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text("인증 확인"),
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
