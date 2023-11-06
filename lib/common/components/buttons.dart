// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vetpro/common/constants/colors.dart';

import '../constants/theme.dart';

class CustomFilledButton extends StatelessWidget {
  //make parameter widget for implement to ui
  final String title;
  final double width;
  final double height;
  final double fontSize;
  final double borderRadius;
  final Color buttonColor;
  final Color fontColor;
  final VoidCallback? onPressed;

  const CustomFilledButton({
    Key? key,
    required this.title,
    this.width = double.infinity,
    this.height = 55,
    this.borderRadius = 10,
    this.fontSize = 20,
    this.buttonColor = secondaryColor,
    this.onPressed,
    this.fontColor = whiteColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, height),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 4,
      ),
      child: Text(
        title,
        style: whiteTextStyle.copyWith(
          color: fontColor,
          fontSize: fontSize,
          fontWeight: bold,
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String title;
  final String? subTitle;
  final double width;
  final double height;
  final double textSize;
  final FontWeight textWeight;
  final Color colorText;
  final Color colorIcon;
  final bool isShowIcon;
  final bool isShowSubTitle;
  final double borderRadius;
  final VoidCallback? onPressed;
  final Color buttonColor;
  final IconData icon;
  const CustomTextButton({
    Key? key,
    required this.title,
    this.subTitle,
    this.width = double.infinity,
    this.height = 24,
    this.textSize = 14,
    this.textWeight = FontWeight.w500,
    this.colorText = Colors.blue,
    this.colorIcon = Colors.blue,
    this.isShowIcon = true,
    this.isShowSubTitle = true,
    this.borderRadius = 10,
    this.onPressed,
    this.buttonColor = Colors.transparent,
    this.icon = Icons.arrow_back_rounded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: buttonColor,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isShowIcon)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  icon,
                  color: colorIcon,
                  size: 18,
                ),
              ),
            if (isShowIcon)
              const SizedBox(
                width: 5,
              ),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: textSize,
                  fontWeight: textWeight,
                  color: colorText,
                ),
              ),
            ),
            if (isShowSubTitle)
              const SizedBox(
                width: 5,
              ),
            if (isShowSubTitle)
              Text(
                subTitle!,
                style: GoogleFonts.poppins(
                  fontSize: textSize,
                  fontWeight: bold,
                  color: colorText,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
