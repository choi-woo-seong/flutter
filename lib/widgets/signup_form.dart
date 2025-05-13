import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  int currentStep = 0;

  String username = '';
  String email = '';
  String phone = '';
  String code = '';
  String password = '';
  String confirmPassword = '';
  String error = '';

  void nextStep() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => currentStep++);
    }
  }

  Future<void> completeSignup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (password != confirmPassword) {
        setState(() => error = "비밀번호가 일치하지 않습니다.");
        return;
      }

      final url = Uri.parse("http://192.168.0.67:8081/api/auth/register");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": username,
          "password": password,
          "email": email,
          "phone": phone,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("회원가입 성공")),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() => error = "회원가입 실패: ${response.body}");
      }
    }
  }

  List<String> stepTitles = ["기본 정보", "이메일 인증", "비밀번호 설정", "가입 완료"];

  List<Widget> buildStepContent() {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("아이디"),
          _buildTextField(
            hint: "아이디 (4자 이상)",
            onSave: (val) => username = val!,
            validator: (val) => val == null || val.length < 4 ? "4자 이상 입력하세요" : null,
          ),
          SizedBox(height: 16),
          _buildLabel("이메일"),
          _buildTextField(
            hint: "이메일 입력",
            keyboardType: TextInputType.emailAddress,
            onSave: (val) => email = val!,
            validator: (val) => val == null || val.isEmpty ? "이메일 입력" : null,
          ),
          SizedBox(height: 16),
          _buildLabel("휴대폰 번호"),
          _buildTextField(
            hint: "010-1234-5678",
            keyboardType: TextInputType.phone,
            onSave: (val) => phone = val!,
            validator: (val) => val == null || val.isEmpty ? "번호 입력" : null,
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("인증번호 입력"),
          _buildTextField(
            hint: "6자리 숫자",
            onSave: (val) => code = val!,
            validator: (val) => val == null || val.length != 6 ? "6자리 입력" : null,
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("비밀번호"),
          _buildTextField(
            hint: "비밀번호 입력",
            obscure: true,
            onSave: (val) => password = val!,
            validator: (val) => val == null || val.length < 8 ? "8자 이상 입력" : null,
          ),
          SizedBox(height: 16),
          _buildLabel("비밀번호 확인"),
          _buildTextField(
            hint: "비밀번호 확인",
            obscure: true,
            onSave: (val) => confirmPassword = val!,
            validator: (val) => val == null || val.isEmpty ? "확인 입력" : null,
          ),
        ],
      ),
      Center(
        child: Column(
          children: [
            Icon(Icons.check_circle, size: 80, color: Colors.blue),
            SizedBox(height: 16),
            Text("회원가입이 완료되었습니다!", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    ];
  }

  Widget _buildTextField({
    String? hint,
    bool obscure = false,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
    FormFieldSetter<String>? onSave,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSave,
    );
  }

  Widget _buildLabel(String text) =>
      Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500));

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        4,
            (index) => _buildStepCircle(index + 1, index <= currentStep, stepTitles[index]),
      ),
    );
  }

  Widget _buildStepCircle(int step, bool isActive, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: isActive ? Colors.blue : Colors.grey[300],
          radius: 14,
          child: Text(
            '$step',
            style: TextStyle(color: isActive ? Colors.white : Colors.black54, fontSize: 12),
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.black87)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = buildStepContent();

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStepIndicator(),
              SizedBox(height: 16),
              if (error.isNotEmpty)
                Text(error, style: TextStyle(color: Colors.red)),
              SizedBox(height: 8),
              content[currentStep],
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: currentStep == 3 ? completeSignup : nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  currentStep == 3 ? "완료" : "다음",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}