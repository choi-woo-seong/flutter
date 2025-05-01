import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  int step = 1;
  String email = '';
  String verificationCode = '';
  String newPassword = '';
  String confirmPassword = '';
  String error = '';
  bool isLoading = false;
  bool isCodeSent = false;

  void handleEmailSubmit() {
    if (email.isEmpty) {
      setState(() => error = "이메일을 입력해주세요.");
      return;
    }
    setState(() {
      isCodeSent = true;
      step = 2;
      error = '';
    });
  }

  void handleCodeVerify() {
    if (verificationCode.isEmpty) {
      setState(() => error = "인증번호를 입력해주세요.");
      return;
    }
    setState(() {
      step = 3;
      error = '';
    });
  }

  void handlePasswordReset() {
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() => error = "비밀번호를 모두 입력해주세요.");
      return;
    }
    if (newPassword != confirmPassword) {
      setState(() => error = "비밀번호가 일치하지 않습니다.");
      return;
    }

    // 비밀번호 재설정 요청 보내기 (추후 API 연동)
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("비밀번호가 재설정되었습니다.")));
    Navigator.pop(context);
  }

  Widget buildStepContent() {
    switch (step) {
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("이메일 입력", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              onChanged: (val) => email = val,
              decoration: InputDecoration(labelText: "이메일 주소"),
            ),
            SizedBox(height: 12),
            ElevatedButton(onPressed: handleEmailSubmit, child: Text("인증번호 받기")),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("인증번호 입력", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              onChanged: (val) => verificationCode = val,
              decoration: InputDecoration(labelText: "인증번호"),
            ),
            SizedBox(height: 12),
            ElevatedButton(onPressed: handleCodeVerify, child: Text("다음")),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("새 비밀번호 설정", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              obscureText: true,
              onChanged: (val) => newPassword = val,
              decoration: InputDecoration(labelText: "새 비밀번호"),
            ),
            SizedBox(height: 8),
            TextField(
              obscureText: true,
              onChanged: (val) => confirmPassword = val,
              decoration: InputDecoration(labelText: "비밀번호 확인"),
            ),
            SizedBox(height: 12),
            ElevatedButton(onPressed: handlePasswordReset, child: Text("비밀번호 재설정")),
          ],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("비밀번호 찾기")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(error, style: TextStyle(color: Colors.red)),
              ),
            buildStepContent(),
          ],
        ),
      ),
    );
  }
}
