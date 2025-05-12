import 'package:flutter/material.dart';

class Faq {
  final String id;
  final String question;
  final List<Widget> answer;

  Faq({required this.id, required this.question, required this.answer});
}

class FaqSection extends StatefulWidget {
  @override
  _FaqSectionState createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  final List<Faq> faqs = [
    Faq(
      id: "faq-1",
      question: "요양병원? 요양원? 어디로 모셔야 할지 고민이에요.",
      answer: [
        Text("요양병원은 의료기관으로 치료가 필요하다면 요양병원, 요양원은 돌봄 케어가 필요하다면 요양원으로 모시는 것이 좋아요."),
        SizedBox(height: 8),
        Text("어르신 상태에 따라 다르기 때문에 전문가 상담을 추천드립니다."),
      ],
    ),
    Faq(
      id: "faq-2",
      question: "요양병원 비용은 얼마인가요?",
      answer: [
        Text("입원 일당 정액 수가를 적용하되, 간병비·재활치료 등 상태에 따라 달라요."),
        SizedBox(height: 8),
        Text("평균적으로는 월 150만~200만원 선입니다."),
      ],
    ),
    Faq(
      id: "faq-3",
      question: "요양원에 들어가려면 어떻게 하나요?",
      answer: [
        Text("장기요양 1~5등급 중 시설급여 인정 수급자만 입소 가능해요."),
      ],
    ),
    Faq(
      id: "faq-6",
      question: "요양시설에 입소하면 면회는 언제 가능하나요?",
      answer: [
        Text("시설마다 면회시간이 다르지만, 일반적으로 평일/주말 오전 9시~오후 6시 사이가 많습니다."),
        SizedBox(height: 8),
        Text("코로나 이후 일부 제한이 있을 수 있으니 사전 확인이 필요해요."),
      ],
    ),
    Faq(
      id: "faq-7",
      question: "장기요양등급 신청은 어떻게 하나요?",
      answer: [
        Text("국민건강보험공단에 전화 또는 온라인으로 신청할 수 있으며, 등급판정조사를 거쳐 등급이 결정됩니다."),
        SizedBox(height: 8),
        Text("보통 신청 후 2~3주 정도 소요돼요."),
      ],
    ),

    // 추가 FAQ는 원하면 계속 확장 가능
  ];

  int visibleCount = 2;
  String? openFaqId;

  void togglePanel(String id) {
    setState(() {
      openFaqId = openFaqId == id ? null : id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleFaqs = faqs.take(visibleCount).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("자주 궁금해하는 질문", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),

            // FAQ 리스트
            ...visibleFaqs.map((faq) => Column(
              children: [
                Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.symmetric(horizontal: 0),
                    title: Row(
                      children: [
                        Icon(Icons.help_outline, size: 18, color: Colors.blue),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(faq.question, style: TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 26.0, bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: faq.answer,
                        ),
                      )
                    ],
                  ),
                ),
                Divider(height: 1, color: Colors.grey.shade300),
              ],
            )),

            // 더보기 버튼
            if (visibleCount < faqs.length)
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      visibleCount = faqs.length;
                    });
                  },
                  child: Text("더 많은 질문 보기", style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                ),
              ),
          ],
        ),
      ),
    );
  }


}
