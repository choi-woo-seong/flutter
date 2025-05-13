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
        Text("요양병원은 의료기관으로 치료가 필요하다면 요양병원으로, 요양원은 장기요양기관으로 돌봄케어가 필요하다면 요양원으로 모시는 것이 좋아요."),
        SizedBox(height: 8),
        Text("어르신 상태에 따라 다르기 때문에 전문가 상담을 추천드립니다."),
        SizedBox(height: 8),
        Text("또하나의가족 맞춤요양상담팀을 통해 적합한 요양시설을 추천받아보세요."),
      ],
    ),
    Faq(
      id: "faq-2",
      question: "요양병원 비용은 얼마인가요?",
      answer: [
        Text("요양병원 입원환자는 기본적으로 입원 일당 정액 수가를 적용합니다."),
        Text("하지만 병원마다 간병비, 재활치료 여부 등으로 인해 차이가 납니다."),
        Text("평균적으로는 월 150만~200만 원 선이며, 정확한 상담이 필요합니다."),
      ],
    ),
    Faq(
      id: "faq-3",
      question: "요양원에 들어가려면 어떻게 하나요?",
      answer: [
        Text("국민건강보험공단의 80~100% 지원을 받아 입소가능한 조건은 장기요양 1~2등급 또는 3~5등급 중 '시설급여 인정 수급자'입니다."),
      ],
    ),
    Faq(
      id: "faq-4",
      question: "어디로 모셔야 할지 모르겠어요.",
      answer: [
        Text("시설보다는 집에서 돌볼지, 요양원이나 병원이 적합한지 고민되실 수 있습니다."),
        Text("가정 상황과 어르신 건강 상태를 종합적으로 고려해 결정하세요."),
        Text("전문 상담을 통해 적절한 요양서비스를 추천받을 수 있어요."),
      ],
    ),
    Faq(
      id: "faq-5",
      question: "방문요양보호사에게 어디까지 부탁해도 되나요?",
      answer: [
        Text("개인위생활동, 외출동행, 청소, 말벗 등 지원합니다."),
        Text("가족 심부름 등은 요청하면 안 됩니다."),
      ],
    ),
    Faq(
      id: "faq-6",
      question: "노인유치원에서는 어떤 서비스를 제공하나요?",
      answer: [
        Text("주야간보호 서비스로 신체/정신 활동 지원과 송영서비스, 프로그램 체험이 가능합니다."),
      ],
    ),
    Faq(
      id: "faq-7",
      question: "휠체어 신청을 하고 싶어요. 무료로 지원 가능한가요?",
      answer: [
        Text("장기요양 수급자라면 연간 한도액 160만 원 내에서 신청 가능합니다."),
        Text("요양번호와 보호자 연락처로 추가 품목 확인이 가능합니다."),
      ],
    ),
    Faq(
      id: "faq-8",
      question: "실버타운과 요양원의 차이점은 무엇인가요?",
      answer: [
        Text("요양원은 돌봄이 필요한 어르신 대상, 실버타운은 자립 생활 가능한 어르신 대상입니다."),
      ],
    ),
    Faq(
      id: "faq-9",
      question: "양로원은 누가 들어갈 수 있나요?",
      answer: [
        Text("일상생활 가능한 65세 이상 어르신 중 기초수급자 또는 부양의무자가 없는 분이 입소 가능합니다."),
      ],
    ),
    Faq(
      id: "faq-10",
      question: "요양원 입소 시 준비물이 있나요?",
      answer: [
        Text("서류(장기요양인정서 등), 의류, 위생용품, 복약지도서, 보조기기 등이 필요합니다."),
      ],
    ),
  ];

  int visibleCount = 3;
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
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("자주 궁금해하는 질문", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
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
                        Expanded(child: Text(faq.question, style: TextStyle(fontSize: 14))),
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
            if (visibleCount < faqs.length)
              Center(
                child: TextButton(
                  onPressed: () => setState(() => visibleCount = faqs.length),
                  child: Text("더 많은 질문 보기", style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
