import 'package:flutter/material.dart';

class FacilityQuestionPage extends StatefulWidget {
  @override
  _FacilityQuestionPageState createState() => _FacilityQuestionPageState();
}

class _FacilityQuestionPageState extends State<FacilityQuestionPage> {
  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;
  String newTitle = "";
  String newContent = "";
  bool isPrivate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false;
        questions = [
          {
            'id': 1,
            'title': "입소 절차에 대해 문의드립니다",
            'content': "어머니(85세)를 모시고 싶은데 입소 절차와 필요한 서류에 대해 알고 싶습니다.",
            'userName': "김철수",
            'createdAt': "2023-05-20T10:15:00Z",
            'isPrivate': false,
          },
          {
            'id': 2,
            'title': "면회 시간은 어떻게 되나요?",
            'content': "주말에도 면회가 가능한가요?",
            'userName': "이영희",
            'createdAt': "2023-05-21T13:45:00Z",
            'isPrivate': true,
          },
        ];
      });
    });
  }

  void submitQuestion() {
    if (newTitle.isNotEmpty && newContent.isNotEmpty) {
      setState(() {
        questions.add({
          'id': questions.length + 1,
          'title': newTitle,
          'content': newContent,
          'userName': "익명 사용자",
          'createdAt': DateTime.now().toIso8601String(),
          'isPrivate': isPrivate,
        });
        newTitle = "";
        newContent = "";
        isPrivate = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("시설 문의")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
        padding: EdgeInsets.all(16),
        children: [
          ...questions.map((q) => Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(q['isPrivate'] ? "(비공개) ${q['title']}" : q['title']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q['content']),
                  SizedBox(height: 4),
                  Text("${q['userName']} · ${q['createdAt'].toString().substring(0, 10)}",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          )),
          Divider(),
          Text("문의 작성", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          TextField(
            onChanged: (val) => setState(() => newTitle = val),
            decoration: InputDecoration(labelText: "제목", border: OutlineInputBorder()),
          ),
          SizedBox(height: 8),
          TextField(
            onChanged: (val) => setState(() => newContent = val),
            decoration: InputDecoration(labelText: "내용", border: OutlineInputBorder()),
            maxLines: 3,
          ),
          Row(
            children: [
              Switch(value: isPrivate, onChanged: (val) => setState(() => isPrivate = val)),
              Text("비공개 문의")
            ],
          ),
          ElevatedButton(onPressed: submitQuestion, child: Text("보내기")),
        ],
      ),
    );
  }
}
