import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logic_gates_flutter/app/app_theme.dart';

// The contrast ratio of two colors, from 1 (identical) to 21 (black on white).
double contrastRatio(Color first, Color second) {
  final double firstLuminance = first.computeLuminance();
  final double secondLuminance = second.computeLuminance();
  final double lighter =
      firstLuminance > secondLuminance ? firstLuminance : secondLuminance;
  final double darker =
      firstLuminance > secondLuminance ? secondLuminance : firstLuminance;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  final Map<String, AppPalette> palettes = {
    'light': AppPalette.light,
    'dark': AppPalette.dark,
  };

  group('text is easy to read in both versions', () {
    palettes.forEach((String name, AppPalette palette) {
      test('$name: text on the page and on the cards', () {
        for (final Color background in [palette.background, palette.card]) {
          expect(contrastRatio(palette.headingText, background),
              greaterThanOrEqualTo(7.0));
          expect(contrastRatio(palette.bodyText, background),
              greaterThanOrEqualTo(4.5));
          expect(contrastRatio(palette.mutedText, background),
              greaterThanOrEqualTo(4.5));
          expect(contrastRatio(palette.primaryDark, background),
              greaterThanOrEqualTo(4.5));
        }
      });

      test('$name: gates, wires and pin names are visible on the cards', () {
        expect(contrastRatio(palette.diagramLine, palette.card),
            greaterThanOrEqualTo(7.0));
        expect(contrastRatio(palette.pinVcc, palette.card),
            greaterThanOrEqualTo(4.5));
        expect(contrastRatio(palette.pinGnd, palette.card),
            greaterThanOrEqualTo(7.0));
        expect(contrastRatio(palette.tableBorder, palette.card),
            greaterThanOrEqualTo(3.0));
      });

      test('$name: a green wire (1) is visible on the cards', () {
        expect(contrastRatio(AppColors.ledOn, palette.card),
            greaterThanOrEqualTo(2.0));
      });
    });
  });

  test('the dark version is really dark and the light version is light', () {
    expect(AppPalette.dark.background.computeLuminance(), lessThan(0.05));
    expect(AppPalette.light.background.computeLuminance(), greaterThan(0.8));
  });

  test('the LED colors are red and green and do not depend on the theme', () {
    expect(AppColors.ledOn.g, greaterThan(AppColors.ledOn.r));
    expect(AppColors.ledOn.g, greaterThan(AppColors.ledOn.b));
    expect(AppColors.ledOff.r, greaterThan(AppColors.ledOff.g));
    expect(AppColors.ledOff.r, greaterThan(AppColors.ledOff.b));
  });
}
