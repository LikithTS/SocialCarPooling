import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialcarpooling/util/TextStylesUtil.dart';
import 'package:socialcarpooling/util/CPString.dart';
import 'package:socialcarpooling/util/font_size.dart';

import '../util/color.dart';
import '../utils/Localization.dart';

Widget primaryTextWidget(BuildContext context, String? text) => Container(
    child: Align(
      alignment: Alignment.center,
      child: Text(text!,
          style: TextStyle(
            fontSize: fontSize17,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            decoration: TextDecoration.none,
            fontFamily: CPString.fontFamilyPoppins,
            overflow: TextOverflow.ellipsis,
          )),
    ));

Widget secondaryTextWidget(BuildContext context, String? text) => Container(
    child: Align(
      alignment: Alignment.center,
      child: Text(text!,
          style: TextStyle(
              fontSize: fontSize20,
              fontWeight: FontWeight.w800,
              color: primaryColor,
              decoration: TextDecoration.none,
              fontFamily: CPString.fontFamilyPoppins)),
    ));

Widget primaryThemeTextWidget(BuildContext context, String? text) => Container(
  child: Text(text! ,
      style: TextStyle(
          fontSize: fontSize17,
          fontWeight: FontWeight.bold,
          color: textThemeColor,
          decoration: TextDecoration.none,
          fontFamily: CPString.fontFamilyPoppins)),
);

Widget primaryThemeTextNormal(BuildContext context, String? text) => Container(
  child: Text(text!,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
        color: textThemeColor,
        decoration: TextDecoration.none,
        fontFamily: CPString.fontFamilyPoppins,
      )),
);

Widget primaryTextNormalTwoLine(BuildContext context, String? text) => Container(
  child: Text(text!,
    style: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      color: textGreyColor,
      decoration: TextDecoration.none,
      fontFamily: CPString.fontFamilyPoppins,
      overflow: TextOverflow.ellipsis,
    ),
    maxLines: 2,
  ),
);

Widget primaryTextNormal(BuildContext context, String? text) => Center(
  child: Align(
    alignment: Alignment.topLeft,
    child: Expanded(
      child: Text(
        text!,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: textGreyColor,
            decoration: TextDecoration.none,
            fontFamily: CPString.fontFamilyPoppins),
        maxLines: 3,
      ),
    ),
  ),
);

