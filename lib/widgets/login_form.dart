import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool rememberMe = false;

  void handleLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 아이디 라벨
          Text("아이디", style: TextStyle(fontSize: 12, color: Colors.black54)),
          SizedBox(height: 4),

          // 아이디 입력 필드
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
              focusedBorder: OutlineInputBorder( // ✅ 추가: 포커스 시 파란색 테두리
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            onSaved: (value) => email = value ?? '',
            validator: (value) => value == null || value.isEmpty ? "아이디를 입력하세요" : null,
          ),

          SizedBox(height: 16),

          // 비밀번호 입력 + 찾기
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
                  focusedBorder: OutlineInputBorder( // ✅ 추가
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onSaved: (value) => password = value ?? '',
                validator: (value) => value == null || value.isEmpty ? "비밀번호를 입력하세요" : null,
              ),

            ],
          ),

          // 로그인 상태 유지
          Row(
            children: [
              Checkbox(
                value: rememberMe,
                onChanged: (value) => setState(() => rememberMe = value ?? false),
                activeColor: Colors.blue, // ✅ 체크 시 파란색으로 표시
              ),
              Text("로그인 상태 유지"),
            ],
          ),


          SizedBox(height: 12),

          // 로그인 버튼
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

          // 또는 구분선
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

          // 카카오 로그인
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
                Image.asset(
                  'assets/images/kakao.png',
                  width: 18,
                  height: 18,
                ),
                SizedBox(width: 8),
                Text("카카오로 로그인"),
              ],
            ),
          ),
          SizedBox(height: 8),

// 구글 로그인
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black, // ✅ 텍스트 색상: 검정
              padding: EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/google.png',
                  width: 23,
                  height: 23,
                ),
                SizedBox(width: 8),
                Text("구글로 로그인"),
              ],
            ),
          ),



          // 회원가입 링크 (부분 색상 분리)
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
