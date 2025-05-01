import 'package:flutter/material.dart';

class FacilityTypeGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("시설 유형", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(4, (index) {
              return Card(
                child: Center(child: Text("시설 ${index + 1}")),
              );
            }),
          ),
        ],
      ),
    );
  }
}
