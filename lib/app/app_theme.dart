import 'package:flutter/material.dart';

// The colors that are the same in the light and the dark version.
// The LEDs are always red (0) and green (1), so they never change.
class AppColors {
  // LED colors: red means 0 and green means 1.
  static const Color ledOn = Color(0xFF00C853);
  static const Color ledOnBorder = Color(0xFF007E33);
  static const Color ledOff = Color(0xFFFF2A35);
  static const Color ledOffBorder = Color(0xFFB80010);
}

// The colors that change between the light and the dark version.
// Widgets read them with context.palette, so they update when the
// user switches the theme.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  final Color primary; // blue of the logo and the table highlight
  final Color primaryDark; // blue used for text and the selected tab
  final Color background;
  final Color appBar;
  final Color card;
  final Color cardBorder;
  final Color cardShadow;
  final Color headingText;
  final Color bodyText;
  final Color mutedText;
  final Color tableBorder;
  final Color diagramLine; // gates and wires that carry 0

  // Colors of the IC pin diagram.
  final Color pinVcc;
  final Color pinGnd;
  final Color chipBody;
  final Color chipOutline;
  final Color chipLeg;

  const AppPalette({
    required this.primary,
    required this.primaryDark,
    required this.background,
    required this.appBar,
    required this.card,
    required this.cardBorder,
    required this.cardShadow,
    required this.headingText,
    required this.bodyText,
    required this.mutedText,
    required this.tableBorder,
    required this.diagramLine,
    required this.pinVcc,
    required this.pinGnd,
    required this.chipBody,
    required this.chipOutline,
    required this.chipLeg,
  });

  // Blue accent, cool off-white page, white cards, navy text.
  static const AppPalette light = AppPalette(
    primary: Color(0xFF1F5FBF),
    primaryDark: Color(0xFF174A96),
    background: Color(0xFFF5F8FC),
    appBar: Color(0xFFFFFFFF),
    card: Color(0xFFFFFFFF),
    cardBorder: Color(0xFFD5E0EF),
    cardShadow: Color(0x141F5FBF),
    headingText: Color(0xFF10294A),
    bodyText: Color(0xFF3B4A5E),
    mutedText: Color(0xFF5C6B80),
    tableBorder: Color(0xFF5B7194),
    diagramLine: Color(0xFF10294A),
    pinVcc: Color(0xFFD62828),
    pinGnd: Color(0xFF10294A),
    chipBody: Color(0xFF22324D),
    chipOutline: Color(0xFF22324D),
    chipLeg: Color(0xFFB8C0CC),
  );

  // Deep navy page, slightly lighter cards, soft white text.
  static const AppPalette dark = AppPalette(
    primary: Color(0xFF3B7DE8),
    primaryDark: Color(0xFF7FB0FF),
    background: Color(0xFF0C1423),
    appBar: Color(0xFF121C2F),
    card: Color(0xFF172236),
    cardBorder: Color(0xFF2A3B5C),
    cardShadow: Color(0x66000000),
    headingText: Color(0xFFEAF1FB),
    bodyText: Color(0xFFC3CFE0),
    mutedText: Color(0xFF8D9BB3),
    tableBorder: Color(0xFF6A80AD),
    diagramLine: Color(0xFFE3ECF8),
    pinVcc: Color(0xFFFF7A7A),
    pinGnd: Color(0xFFE3ECF8),
    chipBody: Color(0xFF0A101C),
    chipOutline: Color(0xFF4A5F85),
    chipLeg: Color(0xFFB8C0CC),
  );

  @override
  AppPalette copyWith({
    Color? primary,
    Color? primaryDark,
    Color? background,
    Color? appBar,
    Color? card,
    Color? cardBorder,
    Color? cardShadow,
    Color? headingText,
    Color? bodyText,
    Color? mutedText,
    Color? tableBorder,
    Color? diagramLine,
    Color? pinVcc,
    Color? pinGnd,
    Color? chipBody,
    Color? chipOutline,
    Color? chipLeg,
  }) {
    return AppPalette(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      background: background ?? this.background,
      appBar: appBar ?? this.appBar,
      card: card ?? this.card,
      cardBorder: cardBorder ?? this.cardBorder,
      cardShadow: cardShadow ?? this.cardShadow,
      headingText: headingText ?? this.headingText,
      bodyText: bodyText ?? this.bodyText,
      mutedText: mutedText ?? this.mutedText,
      tableBorder: tableBorder ?? this.tableBorder,
      diagramLine: diagramLine ?? this.diagramLine,
      pinVcc: pinVcc ?? this.pinVcc,
      pinGnd: pinGnd ?? this.pinGnd,
      chipBody: chipBody ?? this.chipBody,
      chipOutline: chipOutline ?? this.chipOutline,
      chipLeg: chipLeg ?? this.chipLeg,
    );
  }

  // Flutter calls this while it fades from one theme to the other.
  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) {
      return this;
    }
    return AppPalette(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      background: Color.lerp(background, other.background, t)!,
      appBar: Color.lerp(appBar, other.appBar, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      cardShadow: Color.lerp(cardShadow, other.cardShadow, t)!,
      headingText: Color.lerp(headingText, other.headingText, t)!,
      bodyText: Color.lerp(bodyText, other.bodyText, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      tableBorder: Color.lerp(tableBorder, other.tableBorder, t)!,
      diagramLine: Color.lerp(diagramLine, other.diagramLine, t)!,
      pinVcc: Color.lerp(pinVcc, other.pinVcc, t)!,
      pinGnd: Color.lerp(pinGnd, other.pinGnd, t)!,
      chipBody: Color.lerp(chipBody, other.chipBody, t)!,
      chipOutline: Color.lerp(chipOutline, other.chipOutline, t)!,
      chipLeg: Color.lerp(chipLeg, other.chipLeg, t)!,
    );
  }
}

// Lets any widget write context.palette to get the colors of the
// current theme.
extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}

// Builds the theme of the app. [isDark] chooses the dark version.
ThemeData buildAppTheme({required bool isDark}) {
  final AppPalette palette = isDark ? AppPalette.dark : AppPalette.light;
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: palette.primary,
      brightness: isDark ? Brightness.dark : Brightness.light,
    ),
    scaffoldBackgroundColor: palette.background,
    // No colour tint on the app bar when the page scrolls.
    appBarTheme: AppBarTheme(
      backgroundColor: palette.appBar,
      surfaceTintColor: Colors.transparent,
    ),
    extensions: [palette],
  );
}
