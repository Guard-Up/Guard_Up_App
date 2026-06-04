import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_constants.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDefault,
      appBar: AppBar(
        title: const Text(
          '안심 계약 가디언',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.home, color: Colors.black),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Main tap',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _menuCard(
                    '계약서 분석',
                    Icons.document_scanner,
                    controller.onScanPressed,
                  ),
                  _menuCard(
                    '최근 분석 기록',
                    Icons.search,
                    controller.onHistoryPressed,
                  ),
                  _menuCard(
                    '피해 상담',
                    Icons.phone,
                    controller.onHelpsupportPressed,
                  ),
                  _menuCard(
                    '자립 지원 상담',
                    Icons.accessibility_new,
                    controller.onIndependencesupportPressed,
                  ),
                  _menuCard(
                    '도움말&가이드',
                    Icons.help_outline,
                    controller.onGuidePressed,
                  ),
                  // 디버그 빌드에서만 노출
                  if (kDebugMode)
                    _menuCard(
                      '[테스트] 결과 화면',
                      Icons.bug_report,
                      controller.onResultTestPressed,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) controller.onHistoryPressed();
          if (index == 1) controller.onScanPressed();
          if (index == 2) controller.onHelpsupportPressed();
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: '기록'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: '분석'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '상담'),
        ],
      ),
    );
  }

  Widget _menuCard(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
