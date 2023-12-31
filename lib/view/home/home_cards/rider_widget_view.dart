import 'dart:developer';

import 'package:common/model/direction.dart';
import 'package:common/model/legSteps.dart';
import 'package:common/network/model/error_response.dart';
import 'package:common/network/repository/RideRespository.dart';
import 'package:common/network/request/StartDestination.dart';
import 'package:common/network/request/Steps.dart';
import 'package:common/network/request/newRideApi.dart';
import 'package:common/network/response/SuccessResponse.dart';
import 'package:common/utils/CPSessionManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socialcarpooling/buttons/elevated_button_view.dart';
import 'package:socialcarpooling/util/InternetChecks.dart';
import 'package:socialcarpooling/util/TextStylesUtil.dart';
import 'package:socialcarpooling/util/color.dart';
import 'package:socialcarpooling/util/configuration.dart';
import 'package:socialcarpooling/util/constant.dart';
import 'package:socialcarpooling/util/string_url.dart';
import 'package:socialcarpooling/view/home/home_cards/date_selection_with_hint.dart';
import 'package:socialcarpooling/view/home/home_cards/time_selection_with_hint.dart';
import 'package:socialcarpooling/view/home/tab_utils/home_icon_text_form_click.dart';
import 'package:socialcarpooling/widgets/aleart_widgets.dart';
import 'package:socialcarpooling/widgets/alert_dialog_with_ok_button.dart';

import '../../../provider/driver_provider.dart';
import '../../../provider/provider_preference.dart';
import '../../../util/Localization.dart';
import '../../../widgets/widget_text.dart';

class RiderWidgetView extends StatefulWidget {

  final VoidCallback refreshHomePage;

  const RiderWidgetView({Key? key, required this.refreshHomePage}) : super(key: key);

  @override
  State<RiderWidgetView> createState() => HomeRiderState();
}

class HomeRiderState extends State<RiderWidgetView> {
  var selectedCarType = "Car Type";
  var timeValue = TextEditingController();
  var dateValue = TextEditingController();
  var originValue = TextEditingController();
  var destinationValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DriverProvider>(context, listen: false).changeDriver(false);
    });
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          HomeTextIconFormClick(
            hint: DemoLocalizations.of(context)!.getText("start_address"),
            prefixIcon: Icons.my_location,
            userType: 'rider',
            flagAddress: true,
            addressValue: originValue,
          ),
          addVerticalSpace(12),
          HomeTextIconFormClick(
            hint: DemoLocalizations.of(context)!.getText("destination_address"),
            prefixIcon: Icons.location_on,
            userType: 'rider',
            flagAddress: false,
            addressValue: destinationValue,
          ),
          addVerticalSpace(12),
          // HomeTextIconForm(
          //     hint: DemoLocalizations.of(context)!.getText("car_type"),
          //     prefixIcon: Icons.drive_eta),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: const [
                  BoxShadow(
                      color: greyColor, blurRadius: 2.0, spreadRadius: 0.4)
                ]),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  isExpanded: true,
                  value: selectedCarType,
                  decoration: const InputDecoration(
                    fillColor: greyColor,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(width: 0, color: Colors.transparent),
                    ),
                  ),
                  hint: Text(
                    DemoLocalizations.of(context)?.getText("car_type") ?? "",
                    style: TextStyleUtils.primaryTextMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  items: carTypeList.map((list) {
                    return DropdownMenuItem(
                      value: list.toString(),
                      child: Text(list),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCarType = value.toString();
                    });
                  },
                  icon: SvgPicture.asset(
                    StringUrl.downArrowImage,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ),
          addVerticalSpace(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TimeSelectionWithHintSupport(
                  text: DemoLocalizations.of(context)!.getText("time"),
                  iconData: Icons.schedule,
                  timerValue: timeValue,
                ),
              ),
              addHorizontalSpace(12),
              Expanded(
                child: DateSelectionWithHintSupport(
                  text: DemoLocalizations.of(context)!.getText("date"),
                  iconData: Icons.calendar_today,
                  reqDateValue: dateValue,
                ),
              ),
            ],
          ),
          addVerticalSpace(10),
          elevatedDynamicWidthButtonView(
              DemoLocalizations.of(context)?.getText("find_ride"),
              width,
              onFindRideButtonClicked)
        ],
      ),
    );
  }

  void onFindRideButtonClicked() {
    InternetChecks.isConnected()
        .then((isAvailable) => {callRideApi(isAvailable)});
  }

  callRideApi(bool isAvailable) {
    if (isAvailable) {
      log("Button clicked find ride");
      log("Start Address ${originValue.text.isEmpty}");
      log("End Address ${destinationValue.text.isEmpty}");
      log("Drive start time ${timeValue.text.isEmpty}");
      log("Drive start date ${dateValue.text.isEmpty}");
      log("Seats offered ${selectedCarType.isEmpty}");

      // log("Direction data lat ${CPSessionManager().getDirectionObject().routes![0].legs![0].startLocation!.lat}");
      // log("Direction data long ${CPSessionManager().getDirectionObject().routes![0].legs![0].startLocation!.lng}");

      if (originValue.text.isEmpty ||
          destinationValue.text.isEmpty ||
          timeValue.text.isEmpty ||
          dateValue.text.isEmpty ||
          selectedCarType.isEmpty) {
        alertDialogView(context, "post_ride_error");
      } else {
        InternetChecks.showLoadingCircle(context);
        final DateTime utcRideStartTime = DateFormat("yyyy-MM-dd hh:mm aaa")
            .parse('${dateValue.text} ${timeValue.text}', true);
        log("UTC date ${utcRideStartTime.toIso8601String()}");
        final Direction directionObject =
            CPSessionManager().getDirectionObject();
        StartDestination origin = StartDestination(
            formattedAddress: directionObject.routes![0].legs![0].startAddress,
            placeId: directionObject.geocodedWaypoints![1].placeId,
            lat: directionObject.routes![0].legs![0].startLocation!.lat
                .toString(),
            long: directionObject.routes![0].legs![0].startLocation!.lng
                .toString());
        StartDestination destination = StartDestination(
            formattedAddress: directionObject.routes![0].legs![0].endAddress,
            placeId: directionObject.geocodedWaypoints![0].placeId,
            lat:
                directionObject.routes![0].legs![0].endLocation!.lat.toString(),
            long: directionObject.routes![0].legs![0].endLocation!.lng
                .toString());
        final String? distance =
            directionObject.routes![0].legs![0].distance?.text;
        final String? duration =
            directionObject.routes![0].legs![0].duration?.text;
        final List<LegSteps>? steps = directionObject.routes![0].legs![0].steps;
        List<RequestSteps>? reqSteps = [];
        if (steps != null) {
          for (var step in steps) {
            reqSteps.add(RequestSteps(
                distanceInMeters: step.distance?.value,
                lat: step.endLocation?.lat.toString(),
                long: step.endLocation?.lng.toString()));
          }
        }
        NewRideApi api = NewRideApi(
            startDestination: origin,
            endDestination: destination,
            rideType: Constant.AS_RIDER,
            startTime: utcRideStartTime.toIso8601String(),
            carTypeInterested: selectedCarType,
            distance: distance,
            duration: duration,
            steps: reqSteps);
        log("New Ride API $api");
        RideRepository rideRepository = RideRepository();
        Future<dynamic> future = rideRepository.postNewRide(api: api);
        future.then((value) => {handleResponseData(value)});
      }
    } else {
      showSnackbar(context, "No Internet");
    }
  }

  handleResponseData(value) {
    InternetChecks.closeLoadingProgress(context);
    if (value is SuccessResponse) {
      log("Post new ride successful");
      alertDialogView(context, "ride_created_successful");
      setState(() {
        originValue.text = "";
        destinationValue.text = "";
        ProviderPreference().putStartRiderAddress(context, "");
        ProviderPreference().putEndRiderAddress(context, "");
        timeValue.text = "";
        dateValue.text = "";
        selectedCarType = "Car Type";
      });
      widget.refreshHomePage();
    } else if (value is ErrorResponse) {
      showSnackbar(context, value.error?[0].message ?? value.message ?? "");
    }
  }
}
