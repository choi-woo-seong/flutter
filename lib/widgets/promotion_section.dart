import 'package:flutter/material.dart';
import 'dart:async';

class PromotionSection extends StatefulWidget {
  @override
  _PromotionSectionState createState() => _PromotionSectionState();
}

class _PromotionSectionState extends State<PromotionSection> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<String> _images = [
    'assets/images/img.png',
    'assets/images/img_1.png',
    'assets/images/img_2.png',
    'assets/images/img_3.png',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _images.length - 1) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _currentPage = 0;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 160,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: PageView.builder(
              controller: _pageController,
              itemCount: _images.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return Image.asset(
                  _images[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Center(child: Icon(Icons.broken_image)),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_images.length, (index) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 10 : 8,
              height: _currentPage == index ? 10 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.blue : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}
