import 'package:flutter/material.dart';
import '../widgets/signup_form.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("회원가입"),
        elevation: 1,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: SignupForm(),
          ),
        ),
      ),
      backgroundColor: Colors.grey[50],
    );
  }
}
