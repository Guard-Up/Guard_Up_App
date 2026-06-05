import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/scan_controller.dart';

class ScanView extends GetView<ScanController> {
  const ScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final error = controller.cameraError.value;
        if (error != null) {
          return _buildErrorBody(error);
        }
        if (!controller.isInitialized.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        // isInitialized == true 일 때만 도달 → cameraController는 null이 아님이 보장됨
        // 하지만 방어적으로 null 체크 유지
        final cam = controller.cameraController;
        if (cam == null) {
          return _buildErrorBody('카메라를 시작할 수 없습니다.');
        }
        return Stack(
          fit: StackFit.expand,
          children: [
            CameraPreview(cam),
            const _ScanOverlay(),
            const Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Text(
                '서류를 안내선 안에 맞춰주세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Center(
                child: Obx(
                  () => GestureDetector(
                    onTap: controller.isCapturing.value
                        ? null
                        : controller.onCapturePressed,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.isCapturing.value
                                ? Colors.white54
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 8,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildErrorBody(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_photography_outlined,
                color: Colors.white54, size: 64),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            OutlinedButton(
              onPressed: controller.retryCamera,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              ),
              child: const Text('다시 시도'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                '돌아가기',
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanOverlay extends StatelessWidget {
  const _ScanOverlay();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ScanOverlayPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _ScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const horizontalPadding = 24.0;
    final cutoutWidth = size.width - horizontalPadding * 2;
    final cutoutHeight = cutoutWidth * 1.42;
    final cutoutLeft = horizontalPadding;
    final cutoutTop = (size.height - cutoutHeight) / 2;
    final cutoutRect = Rect.fromLTWH(
      cutoutLeft,
      cutoutTop,
      cutoutWidth,
      cutoutHeight,
    );
    const radius = Radius.circular(8);

    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(cutoutRect, radius))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(
      overlayPath,
      Paint()..color = Colors.black.withValues(alpha: 0.55),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(cutoutRect, radius),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    const cornerLen = 24.0;
    final corner = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final l = cutoutLeft;
    final t = cutoutTop;
    final r = cutoutLeft + cutoutWidth;
    final b = cutoutTop + cutoutHeight;

    canvas.drawLine(Offset(l, t + cornerLen), Offset(l, t), corner);
    canvas.drawLine(Offset(l, t), Offset(l + cornerLen, t), corner);
    canvas.drawLine(Offset(r - cornerLen, t), Offset(r, t), corner);
    canvas.drawLine(Offset(r, t), Offset(r, t + cornerLen), corner);
    canvas.drawLine(Offset(l, b - cornerLen), Offset(l, b), corner);
    canvas.drawLine(Offset(l, b), Offset(l + cornerLen, b), corner);
    canvas.drawLine(Offset(r, b - cornerLen), Offset(r, b), corner);
    canvas.drawLine(Offset(r, b), Offset(r - cornerLen, b), corner);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
