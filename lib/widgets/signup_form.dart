import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';

  void handleSignup() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (password != confirmPassword) {
        setState(() => error = "비밀번호가 일치하지 않습니다.");
        return;
      }
      setState(() => error = "");
      // 실제 회원가입 API 연동은 여기에서 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("회원가입 완료: $email")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(error, style: TextStyle(color: Colors.red)),
            ),
          TextFormField(
            decoration: InputDecoration(labelText: "이름"),
            onSaved: (value) => name = value ?? '',
            validator: (value) => value == null || value.isEmpty ? "이름을 입력하세요" : null,
          ),
          SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(labelText: "이메일"),
            keyboardType: TextInputType.emailAddress,
            onSaved: (value) => email = value ?? '',
            validator: (value) => value == null || value.isEmpty ? "이메일을 입력하세요" : null,
          ),
          SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(labelText: "비밀번호"),
            obscureText: true,
            onSaved: (value) => password = value ?? '',
            validator: (value) => value == null || value.length < 6 ? "6자 이상 입력하세요" : null,
          ),
          SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(labelText: "비밀번호 확인"),
            obscureText: true,
            onSaved: (value) => confirmPassword = value ?? '',
            validator: (value) => value == null || value.isEmpty ? "비밀번호 확인을 입력하세요" : null,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: handleSignup,
            child: Text("회원가입"),
          ),
        ],
      ),
    );
  }
}
