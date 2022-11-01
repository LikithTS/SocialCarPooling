
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socialcarpooling/util/color.dart';

class TimeSelectionWithHintSupport extends StatelessWidget {
  final String text;
  final IconData iconData;

  TimeSelectionWithHintSupport({
    Key? key,
    required this.text,
    required this.iconData,
  }) : super(key: key);

  var timeValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 0.4)
          ]),
      child: TextField(
        textAlign: TextAlign.start,
        controller: timeValue,
        readOnly: true,
        onTap: () {
          showClock(context);
        },
        decoration: InputDecoration(
            fillColor: Colors.grey,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.transparent),
            ),
            hintText: text,
            prefixIcon: Icon(
              iconData,
              color: primaryLightColor,
            )),
      ),
    );
  }

  Future<void> showClock(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay.now();
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
            data: ThemeData.light().copyWith(
                primaryColor: Color(primaryLightColor.value),
                colorScheme: ColorScheme.light(primary: Color(primaryLightColor.value)),
                buttonTheme: const ButtonThemeData(
                    textTheme: ButtonTextTheme.primary
                ),
              ),
            child: child!,
        );
      },
    );
    var timeSelected = pickedTime?.format(context);
    log("Picked Time $timeSelected");
    timeValue.text = timeSelected ?? "";
  }
}