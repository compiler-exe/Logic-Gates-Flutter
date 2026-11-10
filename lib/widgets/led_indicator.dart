import 'package:flutter/material.dart';

import '../app/app_theme.dart';

// A glowing circle with a label under it. Red means 0, green means 1.
// If [onTap] is given, tapping the circle or its label calls it.
// Input LEDs get an onTap. Output LEDs do not.
class LedIndicator extends StatelessWidget {
  // true = 1 (green), false = 0 (red).
  final bool isOn;

  // Example: 'A' or 'Cout'. The value is added automatically: 'A: 1'.
  final String label;

  // Null for output LEDs, which the user cannot change.
  final VoidCallback? onTap;

  const LedIndicator({
    super.key,
    required this.isOn,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color fillColor = isOn ? AppColors.ledOn : AppColors.ledOff;
    final Color borderColor =
        isOn ? AppColors.ledOnBorder : AppColors.ledOffBorder;
    final String valueText = isOn ? '1' : '0';

    return Semantics(
      button: onTap != null,
      label: '$label $valueText',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: fillColor,
                  border: Border.all(color: borderColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: fillColor.withValues(alpha: 0.55),
                      blurRadius: 14,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$label: $valueText',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.palette.headingText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
