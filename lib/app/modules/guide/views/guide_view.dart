import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/guide_controller.dart';

class GuideView extends GetView<GuideController> {
  const GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('GuideView'),
      ),
    );
  }
}
