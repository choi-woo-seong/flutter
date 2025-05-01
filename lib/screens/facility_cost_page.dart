import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FacilityCostPage extends StatefulWidget {
  final String facilityId;

  const FacilityCostPage({super.key, this.facilityId = "1"});

  @override
  State<FacilityCostPage> createState() => _FacilityCostPageState();
}

class _FacilityCostPageState extends State<FacilityCostPage> {
  String selectedRoom = "general";
  final int salaryCost = 598393;

  final List<Map<String, dynamic>> roomOptions = [
    {
      "value": "general",
      "label": "일반실 (4인실)",
      "sub": "급여(31일 기준)",
      "price": 0,
    },
    {
      "value": "semi",
      "label": "상급병실/2인실",
      "sub": "급여(2인실비)",
      "price": 1240000,
    },
    {
      "value": "premium",
      "label": "상급병실/3인실",
      "sub": "급여(3인실비)",
      "price": 620000,
    },
  ];

  String formatWon(int value) {
    return NumberFormat('#,###', 'ko_KR').format(value) + "원";
  }

  @override
  Widget build(BuildContext context) {
    final facilityType = widget.facilityId == "2" ? "요양원" : "요양병원";

    final selectedRoomData = roomOptions.firstWhere(
          (room) => room['value'] == selectedRoom,
    );

    final int ownBurden = selectedRoomData['price'] as int;
    final int totalCost = ownBurden + salaryCost;

    return Scaffold(
      appBar: AppBar(
        title: Text("이용 요금 안내"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$facilityType 시설",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text("병실 유형 선택", style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: selectedRoom,
              items: roomOptions.map((room) {
                return DropdownMenuItem<String>(
                  value: room['value'] as String,
                  child: Text(room['label'] as String),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedRoom = value;
                  });
                }
              },
            ),
            SizedBox(height: 24),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("급여 비용: ${formatWon(salaryCost)}"),
                    SizedBox(height: 8),
                    Text("본인부담금: ${formatWon(ownBurden)}"),
                    Divider(height: 24),
                    Text(
                      "총 비용: ${formatWon(totalCost)}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
