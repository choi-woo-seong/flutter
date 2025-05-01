import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

  void handleLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // 여기에 로그인 처리 로직 추가
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("로그인 시도: $email")),
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
          TextFormField(
            decoration: InputDecoration(labelText: "이메일"),
            keyboardType: TextInputType.emailAddress,
            onSaved: (value) => email = value ?? '',
            validator: (value) =>
            value == null || value.isEmpty ? "이메일을 입력하세요" : null,
          ),
          SizedBox(height: 12),
          TextFormField(
            decoration: InputDecoration(labelText: "비밀번호"),
            obscureText: true,
            onSaved: (value) => password = value ?? '',
            validator: (value) =>
            value == null || value.isEmpty ? "비밀번호를 입력하세요" : null,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: handleLogin,
            child: Text("로그인"),
          ),
        ],
      ),
    );
  }
}
