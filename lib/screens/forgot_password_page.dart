import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String email = '';
  String error = '';

  void handleSubmit() {
    if (email.isEmpty) {
      setState(() => error = "이메일을 입력해주세요.");
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("인증 코드가 이메일로 전송되었습니다.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("비밀번호 찾기"),
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
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("비밀번호 찾기",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Text(
                  "가입 시 등록한 이메일을 입력하시면 비밀번호 재설정 안내 메일을 보내드립니다.",
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                SizedBox(height: 24),
                Text("이메일", style: TextStyle(fontSize: 12, color: Colors.black54)),
                SizedBox(height: 6),
                TextField(
                  onChanged: (val) => email = val,
                  decoration: InputDecoration(
                    hintText: "이메일을 입력하세요",
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                if (error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(error, style: TextStyle(color: Colors.red)),
                  ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text("인증 코드 받기"),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("로그인 페이지로 돌아가기",
                      style: TextStyle(color: Colors.blue, fontSize: 13)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
