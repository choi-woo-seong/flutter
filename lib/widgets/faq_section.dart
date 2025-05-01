import 'package:flutter/material.dart';

class FaqSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("자주 묻는 질문", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      children: [
        ListTile(title: Text("입소 기준이 어떻게 되나요?")),
        ListTile(title: Text("비용은 어떻게 산정되나요?")),
      ],
    );
  }
}
