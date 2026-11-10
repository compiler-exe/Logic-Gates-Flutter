import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../models/ic_pin_info.dart';
import '../painters/ic_pin_painter.dart';
import 'section_card.dart';

// Card with the pin diagram of an IC chip.
class PinDiagramCard extends StatelessWidget {
  final IcPinInfo pinInfo;

  const PinDiagramCard({super.key, required this.pinInfo});

  @override
  Widget build(BuildContext context) {
    const Size designSize = IcPinPainter.designSize;

    return SectionCard(
      heading: 'Pin Diagram (${pinInfo.icNumber})',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${pinInfo.chipDescription}. 14-pin chip, seen from above '
            'with the notch at the top. Pin 14 is VCC (+5 V) and '
            'pin 7 is GND (0 V).',
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: context.palette.bodyText,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: AspectRatio(
                aspectRatio: designSize.width / designSize.height,
                child: CustomPaint(
                  painter: IcPinPainter(
                    pinInfo: pinInfo,
                    palette: context.palette,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
