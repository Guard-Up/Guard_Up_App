import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              '분석 기록',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // 🌟 Obx 내부의 데이터가 컨트롤러에 의해 바뀌면 이 부분만 실시간으로 다시 그려집니다.
            Expanded(
              child: Obx(() {
                // 1. 로딩 중일 때
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. 기록이 하나도 없을 때
                if (controller.historyList.isEmpty) {
                  return const Center(
                    child: Text('최근 분석 기록이 존재하지 않습니다.', style: TextStyle(color: Colors.grey)),
                  );
                }

                // 3. 데이터가 있을 때 리스트 출력
                return ListView.separated(
                  itemCount: controller.historyList.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: Color(0xFFF0F0F0),
                    thickness: 1,
                    height: 24,
                  ),
                  itemBuilder: (context, index) {
                    final item = controller.historyList[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Icon(item.icon, color: Colors.black87, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 16, color: Colors.black, height: 1.3),
                              children: [
                                TextSpan(text: '${item.type} : ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: item.address),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(item.date, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: item.chipColor, borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            item.statusText,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: item.textColor),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}