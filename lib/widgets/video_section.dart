import 'package:flutter/material.dart';

class VideoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("소개 영상", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Container(
            color: Colors.black12,
            height: 200,
            child: Center(child: Icon(Icons.play_circle_fill, size: 50)),
          ),
        ],
      ),
    );
  }
}
