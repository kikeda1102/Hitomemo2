import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:hito_memo_2/models/profile.dart';

// スコアの色を取得する関数
Color getScoreColor(num score) {
  double doubleScore = score.toDouble();
  if (doubleScore >= 80) {
    return const Color.fromARGB(255, 4, 205, 124); // Green
  } else if (doubleScore >= 30) {
    return const Color.fromARGB(255, 255, 196, 0); // Orange
  } else {
    return const Color.fromARGB(255, 244, 54, 95); // Red
  }
}

// スコア表示アイコン
Widget scoreIcon(Profile profile, double radius) {
  // スコアがnullの場合は何も表示しない
  if (profile.numberOfIncorrectTaps == null) {
    return const SizedBox.shrink();
  } else {
    return Stack(
      alignment: Alignment.center,
      children: [
        // バウムクーヘン
        BaumkuchenWidget(
          endAngle: profile.calculateCorrectRate() == 0
              ? 0
              : 2 * math.pi * (profile.calculateCorrectRate() ?? 0.0) / 100.0,
          radius: radius,
          thickness: 3,
          color: getScoreColor(profile.calculateCorrectRate() ?? 0.0),
        ),
        // 点数
        Text(
          // nullなら何も表示しない
          profile.numberOfIncorrectTaps == null
              ? ''
              : '${profile.calculateCorrectRate()}',
          style: TextStyle(
            color: getScoreColor(profile.calculateCorrectRate() ?? 0.0),
            fontSize: radius / 1.4,
          ),
        ),
      ],
    );
  }
}

// バウムクーヘン円グラフ
class BaumkuchenPainter extends CustomPainter {
  final double startAngle;
  final double endAngle;
  final double radius;
  final double thickness; // バウムクーヘンの厚み
  final Color color;

  BaumkuchenPainter({
    required this.startAngle,
    required this.endAngle,
    required this.radius,
    required this.thickness,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    // 中心座標
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final Rect outerRect =
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius);
    final double innerRadius = radius - thickness;
    final Rect innerRect =
        Rect.fromCircle(center: Offset(centerX, centerY), radius: innerRadius);
    // 円弧の描画
    canvas.drawArc(outerRect, startAngle, endAngle, true, paint);
    paint.color = Colors.white; // 内部の色を白に設定（透明でも可）
    canvas.drawCircle(innerRect.center, innerRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class BaumkuchenWidget extends StatelessWidget {
  final double endAngle;
  final double radius;
  final double thickness;
  final Color color;

  const BaumkuchenWidget({
    super.key,
    required this.endAngle,
    required this.radius,
    required this.thickness,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: CustomPaint(
        painter: BaumkuchenPainter(
          startAngle: -math.pi / 2,
          endAngle: endAngle,
          radius: radius,
          thickness: thickness,
          color: color,
        ),
      ),
    );
  }
}
