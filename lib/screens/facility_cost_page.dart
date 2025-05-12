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
    final selectedRoomData = roomOptions.firstWhere((room) => room['value'] == selectedRoom);
    final int ownBurden = selectedRoomData['price'] as int;
    final int totalCost = ownBurden + salaryCost;

    return Scaffold(
      appBar: AppBar(
        title: Text("예상비용 살펴보기"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "아래 요양병원 비용은 보험범위 및 제재 적용여부에 따라 달라질 수 있으며 비급여항목은 제외된 예상비용입니다.",
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 24),

            // 병실 유형 선택
            Column(
              children: roomOptions.map((room) {
                final isSelected = room['value'] == selectedRoom;
                return Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: RadioListTile<String>(
                    value: room['value'] as String,
                    groupValue: selectedRoom,
                    activeColor: Colors.blue,
                    title: Text(room['label'] as String, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(room['sub'] as String),
                    secondary: Text(formatWon(room['price'] as int)),
                    onChanged: (value) {
                      setState(() {
                        selectedRoom = value!;
                      });
                    },
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 24),
            Divider(),
            Text("급여 입원비", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text("보험에 따른 본인부담금"),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("급여 입원비"),
                Text(formatWon(salaryCost)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("본인 부담금"),
                Text(formatWon(ownBurden)),
              ],
            ),
            Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("예상 월입원비", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("월 ${formatWon(totalCost)}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
            SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.grey[700]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "자세한 간병비는 시설에 문의해주세요.\n해당 병원의 상황에 따라 달라질 수 있습니다.",
                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              "예상비용은 실제 결제금액과 차이가 있을 수 있습니다.\n반드시 해당 병원과 상담 후 정확한 비용을 확인하시기 바랍니다.",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}