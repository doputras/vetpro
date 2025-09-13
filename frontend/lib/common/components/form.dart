// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/theme.dart';

class CustomFormField extends StatelessWidget {
  final String title;
  final bool obscureText;
  final TextEditingController? controller;
  final bool isShowTitle;
  final TextInputType? keyboardType;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? sufixIcon;
  final String? hintText;
  final double borderRadius;
  final Color fillColor;
  final int maxLine;
  final bool isShadow;
  final bool isBorder;
  final String? initialValue;
  final VoidCallback? onTap;
  final bool? readOnly;

  const CustomFormField({
    super.key,
    required this.title,
    this.obscureText = false,
    this.controller,
    this.isShowTitle = true,
    this.keyboardType,
    this.onFieldSubmitted,
    this.onChanged,
    this.prefixIcon,
    this.sufixIcon,
    this.hintText,
    this.borderRadius = 30,
    required this.fillColor,
    this.maxLine = 1,
    this.isShadow = true,
    this.isBorder = false,
    this.initialValue,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isShowTitle)
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        if (isShowTitle)
          const SizedBox(
            height: 8,
          ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(boxShadow: [
            if (isShadow)
              BoxShadow(
                color: greyColor.withOpacity(0.8), // shadow color
                spreadRadius: -1, // shadow width
                blurRadius: 4, // level shadow
                offset: const Offset(0, 6), // Offset shadow (x, y)
              ),
          ], borderRadius: BorderRadius.circular(30)),
          child: TextFormField(
            onTap: onTap,
            readOnly: readOnly!,
            initialValue: initialValue,
            onChanged: onChanged,
            maxLines: maxLine,
            obscureText: obscureText,
            controller: controller,
            keyboardType: keyboardType,
            onFieldSubmitted: onFieldSubmitted,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: greyTextStyle,
              filled: true,
              isDense: true,
              fillColor: fillColor,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 2,
                  color: primaryColor,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: isBorder ? greyColor : Colors.white,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              contentPadding: const EdgeInsets.all(15),
              prefixIcon: prefixIcon,
              suffixIcon: sufixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
