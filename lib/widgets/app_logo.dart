import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../models/gate_kind.dart';
import '../painters/gate_shapes.dart';

// The round blue logo (a lighter blue in the dark version) with a white NAND gate symbol inside.
class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.palette.primary,
      ),
      child: CustomPaint(
        painter: _LogoGatePainter(),
      ),
    );
  }
}

// Draws the white NAND gate inside the logo.
class _LogoGatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Rect box = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: size.width * 0.78,
      height: size.height * 0.46,
    );
    GateShapes.draw(canvas, GateKind.nand, box, paint);
  }

  @override
  bool shouldRepaint(_LogoGatePainter oldDelegate) {
    return false;
  }
}
