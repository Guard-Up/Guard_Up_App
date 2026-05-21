import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // 배경색
      appBar: AppBar(
        title: const Text('안심 계약 가디언', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.home, color: Colors.black))],
        backgroundColor: Colors.white, elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.all(8.0), child: Text('Main tap', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _menuCard('계약서 분석', Icons.document_scanner, controller.goToAnalysis),
                  _menuCard('최근 기록', Icons.search, controller.goToHistory),
                  _menuCard('피해 상담', Icons.phone, () {}),
                  _menuCard('자립 지원 상담', Icons.accessibility_new, () {}),
                  _menuCard('도움말&가이드', Icons.help_outline, () {}),
                ],
              ),
            ),
          ],
        ),
      ),
      // ... (위쪽 코드 동일)
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.tabIndex.value,
        onTap: (index) => controller.onTabTapped(index), // 👈 컨트롤러 함수 호출
        type: BottomNavigationBarType.fixed, // 탭이 3개 이상일 때 스타일 유지
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: '기록'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: '분석'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '상담'),
        ],
      )),
    );
  }

  // 메뉴 카드 디자인 함수
  Widget _menuCard(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon, size: 40), const SizedBox(height: 10), Text(title, style: const TextStyle(fontWeight: FontWeight.bold))],
        ),
      ),
    );
  }
}