import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../util/color.dart';

Widget addVerticalSpace(double height) {
  return SizedBox(height: height);
}

Widget addHorizontalSpace(double width) {
  return SizedBox(width: width);
}

Widget smallText(String text, Alignment alignement, [TextAlign? textAlign]) =>
    Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Align(
          alignment: alignement,
          child: Text(
            text,
            textAlign: textAlign ?? TextAlign.start,
            style: TextStyle(
                fontSize: 14.sp,
                height: 1.3,
                color: greyColor,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
                fontFamily: 'Poppins'),
            maxLines: 3,
          ),
        ));

Widget smallSpanText(String text, Alignment alignement,
        [TextAlign? textAlign]) =>
    Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Align(
          alignment: alignement,
          child: Text(
            text,
            textAlign: textAlign ?? TextAlign.start,
            style: TextStyle(
                fontSize: 14.sp,
                height: 1.3,
                color: primaryColor,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.underline,
                fontFamily: 'Poppins'),
            maxLines: 3,
          ),
        ));

Widget smallLightText(String text, Alignment alignement,
        [TextAlign? textAlign]) =>
    Container(
        child: Align(
      alignment: alignement,
          child: Text(
            text,
            textAlign: textAlign ?? TextAlign.start,
            style: TextStyle(
                fontSize: 7.sp,
                height: 1.3,
                color: greyColor,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
                fontFamily: 'Poppins'),
            maxLines: 3,
          ),
    ));
Widget headerText(String title) => Container(
    margin: EdgeInsets.symmetric(horizontal: 20.w),
    child: Align(
      child: Text(title,
          style: TextStyle(
              fontSize: 22.sp,
              decoration: TextDecoration.none,
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins')),
    ));

Widget mycarTextWidget(String? title, Color color, double size) => Container(
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(title!,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: size,
                decoration: TextDecoration.none,
                color: color,

                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins')),
      ),
    );

Widget smallTextWithNoMargin(String text, Alignment alignement,
        [TextAlign? textAlign]) =>
    Container(
        child: Align(
      alignment: alignement,
      child: Text(
        text,
        textAlign: textAlign ?? TextAlign.start,
        style: TextStyle(
            fontSize: 14.sp,
            height: 1.3,
            color: greyColor,
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.none,
            fontFamily: 'Poppins'),
        maxLines: 3,
      ),
    ));
