import 'package:flutter/material.dart';
import 'package:socialcarpooling/util/color.dart';
import 'package:socialcarpooling/view/history/history_page.dart';

import '../../../buttons/elevated_button_view.dart';
import '../../../util/constant.dart';
import '../../../util/Localization.dart';
import '../../../util/get_formatted_date_time.dart';
import '../../../util/ride_status_text_function.dart';
import '../../../widgets/card_date_time_view.dart';
import '../../../widgets/ride_amount_view.dart';
import '../../../widgets/ride_type_view.dart';
import '../../../widgets/text_widgets.dart';

class RecentRidesWidget extends StatelessWidget {
  final String carIcon;
  final String startAddress;
  final String endAddress;
  final String rideType;
  final int amount;
  final DateTime dateTime;
  final int seatsOffered;
  final String carType;
  final int coRidersCount;
  final String leftButtonText;
  final String rideStatus;
  bool isDisplayTitle;

  RecentRidesWidget(
      {Key? key,
      required this.carIcon,
      required this.startAddress,
      required this.endAddress,
      required this.rideType,
      required this.amount,
      required this.dateTime,
      required this.seatsOffered,
      required this.carType,
      required this.coRidersCount,
      required this.leftButtonText,
      required this.rideStatus,
      this.isDisplayTitle = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                if (isDisplayTitle) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, bottom: 5.0),
                    child: primaryTextWidgetLeft(context,
                        DemoLocalizations.of(context)?.getText("recent_rides")),
                  )
                ],
                Card(
                    child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(5.0),
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 5, top: 5, bottom: 5),
                              child: Image.asset(carIcon,
                                  width: 60, height: 60, fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 10, top: 5, bottom: 5),
                              child: Row(
                                children: [
                                  const Icon(Icons.route_rounded),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        primaryThemeTextNormal(
                                            context,
                                            DemoLocalizations.of(context)
                                                ?.getText("from")),
                                        primaryTextNormalTwoLine(
                                            context, startAddress),
                                        primaryThemeTextNormal(
                                            context,
                                            DemoLocalizations.of(context)
                                                ?.getText("to")),
                                        primaryTextNormalTwoLine(
                                            context, endAddress),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              child: Column(
                                children: [
                                  if (rideType == Constant.AS_HOST) ...[
                                    rideTypeView(DemoLocalizations.of(context)
                                        ?.getText("as_host")),
                                  ] else ...[
                                    rideTypeView(DemoLocalizations.of(context)
                                        ?.getText("as_rider")),
                                  ],
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  if (rideType == Constant.AS_HOST) ...[
                                    rideAmountView(amount)
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        color: greyColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: timeView(Icons.calendar_today_sharp,
                                getFormattedDate(dateTime)),
                          ),
                          Expanded(
                            child: timeView(
                                Icons.schedule, getFormattedTime(dateTime)),
                          ),
                          if (rideType == Constant.AS_HOST) ...[
                            Expanded(
                              child: timeView(
                                  Icons.airline_seat_recline_normal,
                                  seatsOffered.toString()),
                            )
                          ] else ...[
                            Expanded(
                              child: timeView(Icons.directions_car, carType),
                            )
                          ]
                        ],
                      ),
                      const Divider(
                        color: greyColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Row(
                          children: [
                            if (coRidersCount != 0) ...[
                              const Icon(
                                Icons.add_circle_outline,
                                color: primaryColor,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              primaryTextNormalTwoLine(context, coRidersCount.toString())
                            ],
                            const Spacer(),
                            elevatedButtonView(
                                getRightButtonText(rideType, rideStatus),
                                () => viewHistory(context),
                                getRightButtonBgColor(rideType, rideStatus))
                          ],
                        ),
                      )
                    ],
                  ),
                )),
              ],
            )));
  }

  viewHistory(BuildContext context) {
    //Navigate to history screen
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HistoryPage()));
  }
}
