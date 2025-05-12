import 'package:flutter/material.dart';

class CareGradeTestPage extends StatefulWidget {
  @override
  _CareGradeTestPageState createState() => _CareGradeTestPageState();
}

class _CareGradeTestPageState extends State<CareGradeTestPage> {
  int currentQuestionIndex = 0;
  List<int> answers = [];
  bool showResult = false;
  int totalScore = 0;

  final List<Map<String, dynamic>> questions = [
    {
      "category": "신체기능",
      "title": "옷 입기",
      "description": "옷 입기, 양말·신발 신기, 단추 채우기, 지퍼 올리기 등",
      "options": [
        {"value": 0, "label": "완전자립", "description": "도움 없이 혼자서 가능"},
        {"value": 3, "label": "부분도움", "description": "일부 도움이 필요함"},
        {"value": 7, "label": "완전도움", "description": "전적으로 다른 사람의 도움이 필요함"},
      ]
    },
    {
      "category": "신체기능",
      "title": "세수하기",
      "description": "세수, 양치질, 머리감기, 면도, 화장하기 등",
      "options": [
        {"value": 0, "label": "완전자립", "description": "도움 없이 혼자서 가능"},
        {"value": 3, "label": "부분도움", "description": "일부 도움이 필요함"},
        {"value": 7, "label": "완전도움", "description": "전적으로 다른 사람의 도움이 필요함"},
      ]
    },
    {
      "category": "신체기능",
      "title": "목욕하기",
      "description": "목욕이나 샤워하기, 몸 씻기 등",
      "options": [
        {"value": 0, "label": "완전자립", "description": "도움 없이 혼자서 가능"},
        {"value": 3, "label": "부분도움", "description": "일부 도움이 필요함"},
        {"value": 7, "label": "완전도움", "description": "전적으로 다른 사람의 도움이 필요함"},
      ]
    },
    {
      "category": "신체기능",
      "title": "식사하기",
      "description": "음식 섭취, 식사도구 사용, 음식 자르기 등",
      "options": [
        {"value": 0, "label": "완전자립", "description": "도움 없이 혼자서 가능"},
        {"value": 3, "label": "부분도움", "description": "일부 도움이 필요함"},
        {"value": 7, "label": "완전도움", "description": "전적으로 다른 사람의 도움이 필요함"},
      ]
    },
    {
      "category": "신체기능",
      "title": "체위변경하기",
      "description": "누웠다가 앉기, 앉았다가 일어서기 등",
      "options": [
        {"value": 0, "label": "완전자립", "description": "도움 없이 혼자서 가능"},
        {"value": 3, "label": "부분도움", "description": "일부 도움이 필요함"},
        {"value": 7, "label": "완전도움", "description": "전적으로 다른 사람의 도움이 필요함"},
      ]
    },
    {
      "category": "신체기능",
      "title": "이동하기",
      "description": "방 안에서 걷기, 이동하기 등",
      "options": [
        {"value": 0, "label": "완전자립", "description": "도움 없이 혼자서 가능"},
        {"value": 3, "label": "부분도움", "description": "일부 도움이 필요함"},
        {"value": 7, "label": "완전도움", "description": "전적으로 다른 사람의 도움이 필요함"},
      ]
    },
    {
      "category": "신체기능",
      "title": "화장실 이용하기",
      "description": "화장실 가기, 대소변 후 닦고 옷 입기, 기저귀 교환하기 등",
      "options": [
        {"value": 0, "label": "완전자립", "description": "도움 없이 혼자서 가능"},
        {"value": 3, "label": "부분도움", "description": "일부 도움이 필요함"},
        {"value": 7, "label": "완전도움", "description": "전적으로 다른 사람의 도움이 필요함"},
      ]
    },
    {
      "category": "인지기능",
      "title": "방금 전에 들었던 이야기나 일을 잊는다",
      "description": "단기 기억력 저하",
      "options": [
        {"value": 0, "label": "완전자립", "description": "도움 없이 혼자서 가능"},
        {"value": 3, "label": "부분도움", "description": "일부 도움이 필요함"},
        {"value": 7, "label": "완전도움", "description": "전적으로 다른 사람의 도움이 필요함"},
      ]
    },
    {
      "category": "인지기능",
      "title": "오늘이 며칠인지, 무슨 요일인지 모른다",
      "description": "시간 지남력 저하",
      "options": [
        {"value": 0, "label": "완전자립", "description": "도움 없이 혼자서 가능"},
        {"value": 3, "label": "부분도움", "description": "일부 도움이 필요함"},
        {"value": 7, "label": "완전도움", "description": "전적으로 다른 사람의 도움이 필요함"},
      ]
    },
    {
      "category": "인지기능",
      "title": "자신이 있는 장소를 알지 못한다",
      "description": "장소 지남력 저하",
      "options": [
        {"value": 0, "label": "완전자립", "description": "도움 없이 혼자서 가능"},
        {"value": 3, "label": "부분도움", "description": "일부 도움이 필요함"},
        {"value": 7, "label": "완전도움", "description": "전적으로 다른 사람의 도움이 필요함"},
      ]
    },
    {
      "category": "인지기능",
      "title": "자신의 이름을 기억하지 못한다",
      "description": "사람 지남력 저하",
      "options": [
        {"value": 0, "label": "완전자립", "description": "도움 없이 혼자서 가능"},
        {"value": 3, "label": "부분도움", "description": "일부 도움이 필요함"},
        {"value": 7, "label": "완전도움", "description": "전적으로 다른 사람의 도움이 필요함"},
      ]
    },
    {
      "category": "문제행동",
      "title": "같은 질문을 반복하거나 같은 말을 반복한다",
      "description": "반복적 행동",
      "options": [
        {"value": 0, "label": "완전자립", "description": "도움 없이 혼자서 가능"},
        {"value": 3, "label": "부분도움", "description": "일부 도움이 필요함"},
        {"value": 7, "label": "완전도움", "description": "전적으로 다른 사람의 도움이 필요함"},
      ]
    },
    {
      "category": "문제행동",
      "title": "길을 잃거나 헤맨다",
      "description": "반복적 행동",
      "options": [
        {"value": 0, "label": "완전자립", "description": "도움 없이 혼자서 가능"},
        {"value": 3, "label": "부분도움", "description": "일부 도움이 필요함"},
        {"value": 7, "label": "완전도움", "description": "전적으로 다른 사람의 도움이 필요함"},
      ]
    },
    {
      "category": "문제행동",
      "title": "폭언이나 위협적인 행동을 한다",
      "description": "공격적 행동",
      "options": [
        {"value": 0, "label": "완전자립", "description": "도움 없이 혼자서 가능"},
        {"value": 3, "label": "부분도움", "description": "일부 도움이 필요함"},
        {"value": 7, "label": "완전도움", "description": "전적으로 다른 사람의 도움이 필요함"},
      ]
    },
    {
      "category": "간호처치",
      "title": "하루에 한 번 이상 체위변경이 필요하다",
      "description": "체위변경",
      "options": [
        {"value": 0, "label": "완전자립", "description": "도움 없이 혼자서 가능"},
        {"value": 3, "label": "부분도움", "description": "일부 도움이 필요함"},
        {"value": 7, "label": "완전도움", "description": "전적으로 다른 사람의 도움이 필요함"},
      ]
    },
  ];

  final List<Map<String, dynamic>> gradeStandards = [
    {"grade": "1등급", "minScore": 95, "description": "심신의 기능상태 장애로 일상생활에서 전적으로 다른 사람의 도움이 필요한 자"},
    {"grade": "2등급", "minScore": 75, "description": "심신의 기능상태 장애로 일상생활에서 상당 부분 다른 사람의 도움이 필요한 자"},
    {"grade": "3등급", "minScore": 60, "description": "심신의 기능상태 장애로 일상생활에서 부분적으로 다른 사람의 도움이 필요한 자"},
    {"grade": "4등급", "minScore": 51, "description": "심신의 기능상태 장애로 일상생활에서 일정 부분 다른 사람의 도움이 필요한 자"},
    {"grade": "5등급", "minScore": 45, "description": "치매환자로서 일상생활에서 다른 사람의 도움이 필요한 자"},
    {"grade": "인지지원등급", "minScore": 45, "description": "치매환자로서 장기요양인정 점수가 45점 미만인 자"},
  ];

  @override
  void initState() {
    super.initState();
    answers = List.filled(questions.length, -1);
  }

  void selectOption(int value) {
    setState(() {
      answers[currentQuestionIndex] = value;
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      calculateResult();
    }
  }

  void prevQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  void calculateResult() {
    totalScore = answers.fold(0, (sum, item) => sum + (item >= 0 ? item : 0));
    setState(() {
      showResult = true;
    });
  }

  Map<String, dynamic> determineGrade(int score) {
    return gradeStandards.firstWhere(
          (standard) => score >= standard["minScore"],
      orElse: () => {"grade": "등급 외", "description": "장기요양인정 점수가 45점 미만으로 등급 판정 기준에 해당하지 않습니다."},
    );
  }

  void restartTest() {
    setState(() {
      answers = List.filled(questions.length, -1);
      currentQuestionIndex = 0;
      totalScore = 0;
      showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showResult) {
      final result = determineGrade(totalScore);
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text("테스트 결과"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: BoxConstraints(maxWidth: 500),
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("테스트 결과", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text("장기요양인정 점수", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  SizedBox(height: 8),
                  Text("${((totalScore / 105) * 100).round()}점",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),

                  SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text("예상 등급", style: TextStyle(fontSize: 14, color: Colors.black87)),
                        SizedBox(height: 4),
                        Text(result["grade"], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                        SizedBox(height: 4),
                        Text(result["description"], style: TextStyle(fontSize: 13, color: Colors.black87), textAlign: TextAlign.center),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "주의사항",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "이 테스트는 간단한 모의테스트로, 실제 장기요양등급 판정과는 차이가 있을 수 있습니다.\n정확한 등급 사항 판정을 위해서는 국민건강보험공단에 장기요양인정 신청을 하시기 바랍니다.",
                                style: TextStyle(fontSize: 12, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),


                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: restartTest,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text("테스트 다시 하기"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            foregroundColor: Colors.black, // ✅ 텍스트 색상 검정
                          ),
                          child: Text("홈으로 돌아가기"),
                        ),
                      ),
                    ],
                  )

                ],
              ),
            ),
          ),
        ),
      );
    }


    final question = questions[currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(title: Text("장기요양등급 모의테스트"),
        backgroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 진행 상태
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("진행 상태", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text("${currentQuestionIndex + 1} / ${questions.length}",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
            SizedBox(height: 4),
            LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              backgroundColor: Colors.grey[200],
            ),
            SizedBox(height: 16),

            // 카테고리
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                question["category"],
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 13),
              ),
            ),
            SizedBox(height: 12),

            Text(question["title"], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(question["description"], style: TextStyle(color: Colors.black87)),
            SizedBox(height: 20),

            // 선택지
            ...List.generate((question["options"] as List).length, (i) {
              final option = question["options"][i];
              final isSelected = answers[currentQuestionIndex] == option["value"];
              return GestureDetector(
                onTap: () => selectOption(option["value"]),
                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected ? Colors.blue[50] : Colors.white,
                    border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        color: isSelected ? Colors.blue : Colors.grey,
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(option["label"], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text(option["description"], style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),

            Spacer(),

            // 하단 버튼
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: currentQuestionIndex > 0 ? prevQuestion : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                    ),
                    child: Text("이전"),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: answers[currentQuestionIndex] != -1 ? nextQuestion : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(currentQuestionIndex == questions.length - 1 ? "결과 보기" : "다음"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}