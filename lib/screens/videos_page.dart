import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideosPage extends StatelessWidget {
  final List<Map<String, String>> videos = [
    {
      'title': '2025년 바뀌는 노인복지혜택 미리 준비하고 제대로 알아보자',
      'duration': '5:20',
      'category': '정책',
      'views': '3,450',
      'uploadDate': '2025-04-10',
      'url': 'https://www.youtube.com/watch?v=MQtjDxHO-hc',
    },
    {
      'title': '노인복지법에 의한 노인복지시설의 종류 총정리',
      'duration': '8:45',
      'category': '시설 종류',
      'views': '1,280',
      'uploadDate': '2025-03-28',
      'url': 'https://www.youtube.com/watch?v=_QUQK4zs8dM',
    },
    {
      'title': '어르신, 노인복지시설 이렇게 이용해 주세요!',
      'duration': '6:10',
      'category': '이용 안내',
      'views': '2,150',
      'uploadDate': '2025-04-01',
      'url': 'https://www.youtube.com/watch?v=YXkftby8yE8',
    },
    {
      'title': '4가지 노인주거복지시설의 차이 (실버타운, 양로원, 요양원, 요양병원)',
      'duration': '7:32',
      'category': '주거 정보',
      'views': '4,750',
      'uploadDate': '2025-04-03',
      'url': 'https://www.youtube.com/watch?v=bl42kcYfdrg',
    },
    {
      'title': '노인복지 정책 완전 정리! 2025년 꼭 챙겨야 할 제도들',
      'duration': '9:05',
      'category': '정책 해설',
      'views': '3,980',
      'uploadDate': '2025-03-25',
      'url': 'https://www.youtube.com/watch?v=rGkNGK-9_lA',
    },
    {
      'title': '실버스테이? 정부지원 임대주택 정책 알아보기',
      'duration': '10:18',
      'category': '주거 지원',
      'views': '2,810',
      'uploadDate': '2025-03-18',
      'url': 'https://www.youtube.com/watch?v=EToTnW-DEyU',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('영상으로 만나는 요양정보'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          final videoId = Uri.parse(video['url']!).queryParameters['v'] ?? '';
          final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';

          return GestureDetector(
            onTap: () async {
              final url = Uri.parse(video['url']!);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
            },
            child: Card(
              color: Colors.white,
              elevation: 3,
              margin: EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          thumbnailUrl,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          color: Colors.black.withOpacity(0.7),
                          child: Text(
                            video['duration']!,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Icon(Icons.play_circle_fill, color: Colors.white, size: 48),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video['title']!,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text(video['category']!, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                            SizedBox(width: 8),
                            Text("조회수 ${video['views']}회", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            SizedBox(width: 8),
                            Text(video['uploadDate']!, style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
