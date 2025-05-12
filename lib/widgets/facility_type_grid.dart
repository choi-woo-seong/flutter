import 'package:flutter/material.dart';
import '../screens/facility_list_page.dart'; // 리스트 페이지 import 추가

class FacilityTypeGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFacilityItem(
                icon: Icons.search,
                label: '시설찾기',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FacilityListPage(category: '요양병원'),
                    ),
                  );
                },
              ),
              _buildFacilityItem(
                imagePath: 'assets/images/hospital.png',
                label: '요양병원',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FacilityListPage(category: '요양병원'),
                    ),
                  );
                },
              ),
              _buildFacilityItem(
                imagePath: 'assets/images/nursing.png',
                label: '요양원',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FacilityListPage(category: '요양원'),
                    ),
                  );
                },
              ),
              _buildFacilityItem(
                imagePath: 'assets/images/silvertown.png',
                label: '실버타운',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FacilityListPage(category: '실버타운'),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityItem({
    IconData? icon,
    String? imagePath,
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            child: icon != null
                ? Icon(icon, size: 32, color: Colors.grey[700])
                : Image.asset(imagePath!, fit: BoxFit.contain),
          ),
          SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
