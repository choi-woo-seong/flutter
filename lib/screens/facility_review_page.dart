import 'package:flutter/material.dart';

class FacilityReviewPage extends StatefulWidget {
  @override
  _FacilityReviewPageState createState() => _FacilityReviewPageState();
}

class _FacilityReviewPageState extends State<FacilityReviewPage> {
  List<Map<String, dynamic>> reviews = [];
  bool isLoading = true;
  int newRating = 5;
  String newContent = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false;
        reviews = [
          {
            'id': 1,
            'userName': "김철수",
            'rating': 5,
            'content': "어머니를 모시고 있는데 시설이 깨끗하고 직원분들이 친절해서 만족합니다.",
            'createdAt': "2023-05-15T09:30:00Z",
          },
          {
            'id': 2,
            'userName': "이영희",
            'rating': 4,
            'content': "위생 상태가 좋아요. 다만 프로그램이 좀 더 다양했으면 좋겠어요.",
            'createdAt': "2023-05-16T14:20:00Z",
          },
        ];
      });
    });
  }

  void submitReview() {
    if (newContent.isNotEmpty) {
      setState(() {
        reviews.add({
          'id': reviews.length + 1,
          'userName': "익명 사용자",
          'rating': newRating,
          'content': newContent,
          'createdAt': DateTime.now().toIso8601String(),
        });
        newContent = "";
        newRating = 5;
      });
    }
  }

  String getStars(int count) {
    return "⭐️" * count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("시설 리뷰")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
        padding: EdgeInsets.all(16),
        children: [
          ...reviews.map((review) => Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text("${review['userName']} - ${getStars(review['rating'])}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review['content']),
                  SizedBox(height: 4),
                  Text(review['createdAt'].toString(), style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          )),
          Divider(),
          Text("리뷰 작성", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          DropdownButton<int>(
            value: newRating,
            onChanged: (value) => setState(() => newRating = value ?? 5),
            items: List.generate(5, (i) => i + 1)
                .map((val) => DropdownMenuItem(value: val, child: Text("$val 점")))
                .toList(),
          ),
          TextField(
            onChanged: (val) => setState(() => newContent = val),
            decoration: InputDecoration(
              labelText: "내용",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 8),
          ElevatedButton(onPressed: submitReview, child: Text("등록")),
        ],
      ),
    );
  }
}
