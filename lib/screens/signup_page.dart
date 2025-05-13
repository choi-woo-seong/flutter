import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String phone = '';

  void handleNext() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // ✅ 이메일 인증 페이지로 이동
      Navigator.pushNamed(
        context,
        '/signup-email',
        arguments: {
          'username': username,
          'email': email,
          'phone': phone,
        },
      );
    }
  }

  Widget buildStepIndicator() {
    List<String> steps = ["기본 정보", "이메일 인증", "비밀번호 설정", "가입 완료"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(steps.length, (index) {
        bool isCurrent = index == 0;
        return Column(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: isCurrent ? Colors.blue : Colors.grey.shade300,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: isCurrent ? Colors.white : Colors.black54,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              steps[index],
              style: TextStyle(
                fontSize: 12,
                color: isCurrent ? Colors.black : Colors.grey,
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("회원가입"),
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
                  buildStepIndicator(),
                  SizedBox(height: 24),
                  Text("아이디", style: TextStyle(fontSize: 12, color: Colors.black54)),
                  SizedBox(height: 6),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "아이디 (4자 이상)",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) =>
                    value != null && value.length >= 4 ? null : "아이디는 4자 이상이어야 합니다.",
                    onSaved: (val) => username = val ?? '',
                  ),
                  SizedBox(height: 16),
                  Text("이메일", style: TextStyle(fontSize: 12, color: Colors.black54)),
                  SizedBox(height: 6),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "이메일 입력",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) =>
                    value != null && value.contains('@') ? null : "유효한 이메일을 입력하세요.",
                    onSaved: (val) => email = val ?? '',
                  ),
                  SizedBox(height: 16),
                  Text("핸드폰 번호", style: TextStyle(fontSize: 12, color: Colors.black54)),
                  SizedBox(height: 6),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "010-1234-5678",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) =>
                    value != null && value.length >= 10 ? null : "휴대폰 번호를 입력하세요.",
                    onSaved: (val) => phone = val ?? '',
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: handleNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text("다음", style: TextStyle(fontWeight: FontWeight.bold)),
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
