import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoSection extends StatelessWidget {
  final List<Map<String, String>> videos = [
    {
      'title': '노인복지 정책 및 지원금 안내',
      'url': 'https://www.youtube.com/watch?v=rGkNGK-9_lA',
    },
    {
      'title': '실버타운 vs 요양원 vs 요양병원',
      'url': 'https://www.youtube.com/watch?v=bl42kcYfdrg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // ✅ 흰 배경
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16), // ✅ 내부 여백
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목 + 더보기
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("영상으로 만나는 요양정보", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/videos');
                  },
                  child: Text("더보기 >", style: TextStyle(color: Colors.grey[600])),
                ),

              ],
            ),
            SizedBox(height: 12),
            // 가로 스크롤 썸네일
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: videos.length,
                separatorBuilder: (_, __) => SizedBox(width: 8),
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
                    child: Container(
                      width: 170,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  thumbnailUrl,
                                  height: 100,
                                  width: 170,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Icon(Icons.play_circle_fill, size: 40, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            video['title']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
