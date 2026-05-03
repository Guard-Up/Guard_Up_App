import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/analyzing_controller.dart';

class AnalyzingView extends GetView<AnalyzingController> {
  const AnalyzingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('AnalyzingView'),
      ),
    );
  }
}
