import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vetpro/common/constants/colors.dart';

// Two families: Bricolage Grotesque for screen titles and big numbers only,
// Plus Jakarta Sans (designed for Jakarta) for every label, field and body.
TextStyle displayStyle(double size, {Color color = inkColor}) =>
    GoogleFonts.bricolageGrotesque(
      fontSize: size,
      fontWeight: FontWeight.w800,
      color: color,
      height: 1.05,
      letterSpacing: -0.02 * size,
    );

final TextStyle bodyStyle = GoogleFonts.plusJakartaSans(
  color: inkColor,
  fontSize: 15,
  height: 1.45,
);

final TextStyle labelStyle = GoogleFonts.plusJakartaSans(
  color: inkColor,
  fontSize: 14,
  fontWeight: FontWeight.w700,
);

final TextStyle mutedStyle = GoogleFonts.plusJakartaSans(
  color: mutedColor,
  fontSize: 13,
  fontWeight: FontWeight.w500,
  height: 1.4,
);

const BorderSide inkBorder = BorderSide(color: inkColor, width: 2);

OutlineInputBorder _field(Color color, [double width = 2]) =>
    OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: width),
    );

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      onPrimary: whiteColor,
      secondary: tealColor,
      onSecondary: whiteColor,
      surface: whiteColor,
      onSurface: inkColor,
      error: primaryColor,
    ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: backgroundColor,
    textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme)
        .apply(bodyColor: inkColor, displayColor: inkColor),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: inkColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: displayStyle(22),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      // Highlighter fill on the focused field: visible even in sunlight.
      fillColor: WidgetStateColor.resolveWith((states) =>
          states.contains(WidgetState.focused) ? focusFillColor : whiteColor),
      hoverColor: const Color(0x0F1F5566),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      hintStyle: bodyStyle.copyWith(color: hintColor),
      prefixIconColor: mutedColor,
      suffixIconColor: mutedColor,
      border: _field(inkColor),
      enabledBorder: _field(inkColor),
      focusedBorder: _field(tealColor, 3),
      errorBorder: _field(primaryColor),
      focusedErrorBorder: _field(primaryColor, 3),
      disabledBorder: _field(disabledColor),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: inkColor,
      contentTextStyle:
          bodyStyle.copyWith(color: whiteColor, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: whiteColor,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: displayStyle(22),
      contentTextStyle: bodyStyle,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: inkBorder,
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: whiteColor,
      surfaceTintColor: Colors.transparent,
      headerBackgroundColor: tealColor,
      headerForegroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: inkBorder,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: tealColor,
        textStyle: labelStyle,
        minimumSize: const Size(48, 48),
      ),
    ),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: primaryColor),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: inkColor,
      selectionColor: yellowColor,
      selectionHandleColor: tealColor,
    ),
    dividerTheme: const DividerThemeData(color: dividerColor, thickness: 1.5),
  );
}
