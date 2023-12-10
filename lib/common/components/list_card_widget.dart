import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vetpro/common/constants/theme.dart';

import '../constants/colors.dart';

class ListCardWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget widget;
  final String text1;
  final String text2;
  final String text3;
  final String? text4;
  final String flag;
  final Color color;
  final String? image;
  const ListCardWidget(
      {required this.color,
      required this.flag,
      required this.text1,
      required this.text2,
      required this.text3,
      this.text4,
      required this.widget,
      this.image,
      this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 130,
        minHeight: 100,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            margin: const EdgeInsets.only(
              top: 15,
            ),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                image == null
                    ? const SizedBox()
                    : Expanded(
                        flex: 2,
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Image.asset(
                            (flag == '3') ? 'assets/invoice.png' : image ?? '',
                            scale: 1.3,
                          ),
                        ),
                      ),
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 15,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text1,
                          maxLines: 2,
                          //overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                              fontSize: (flag == '3') ? 16 : 14,
                              color: (flag == '1' || flag == '3')
                                  ? (flag == '3')
                                      ? blueColor
                                      : blackColor
                                  : whiteColor,
                              fontWeight: bold),
                        ),
                        Text(
                          text2,
                          style: GoogleFonts.montserrat(
                            color: (flag == '1') || flag == '3'
                                ? blackColor
                                : whiteColor,
                          ),
                        ),
                        Text(
                          text3,
                          style: GoogleFonts.montserrat(
                            color: (flag == '1' || flag == '3')
                                ? blackColor
                                : whiteColor,
                          ),
                        ),
                        SizedBox(
                          height: text4 == null ? 0 : 5,
                        ),
                        text4 == null
                            ? const SizedBox()
                            : Text(
                                text4!,
                                style: GoogleFonts.montserrat(
                                  color: (flag == '1' || flag == '3')
                                      ? blackColor
                                      : whiteColor,
                                  fontWeight: medium,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: widget,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
