import 'dart:async';
import 'dart:developer';

import 'package:common/network/model/error_response.dart';
import 'package:common/network/repository/SigninRepository.dart';
import 'package:common/network/request/SendOtpApi.dart';
import 'package:common/network/request/ValidOtpApi.dart';
import 'package:common/network/response/AuthResponse.dart';
import 'package:common/network/response/SuccessResponse.dart';
import 'package:common/utils/CPSessionManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:socialcarpooling/font&margin/font_size.dart';
import 'package:socialcarpooling/util/CPString.dart';
import 'package:socialcarpooling/util/InternetChecks.dart';
import 'package:socialcarpooling/util/TextStylesUtil.dart';
import 'package:socialcarpooling/util/configuration.dart';
import 'package:socialcarpooling/util/string_url.dart';
import 'package:socialcarpooling/view/forgetpassword/ForgetPasswordConfirmScreen.dart';
import 'package:socialcarpooling/widgets/aleart_widgets.dart';
import 'package:socialcarpooling/widgets/alert_dialog_with_ok_button.dart';
import 'package:socialcarpooling/widgets/header_widgets.dart';
import 'package:socialcarpooling/widgets/otp_edittext_view.dart';

import '../../util/Validation.dart';
import '../../util/color.dart';
import '../../font&margin/margin_confiq.dart';
import '../../util/Localization.dart';
import '../../widgets/edit_text_widgets.dart';
import '../../widgets/image_widgets.dart';

class ForgetPasswordScreen extends StatefulWidget {
  String mobileNo = "";

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with InputValidationMixin {

  int secondsRemaining = 30;
  bool enableResend = false;
  bool enableSendOtpButton = false;
  Timer? timer;

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpString1Controller = TextEditingController();
  TextEditingController otpString2Controller = TextEditingController();
  TextEditingController otpString3Controller = TextEditingController();
  TextEditingController otpString4Controller = TextEditingController();
  TextEditingController otpString5Controller = TextEditingController();
  TextEditingController otpString6Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  void sendOtp(SendOtpApi sendOtpApi) {
    Future<dynamic> future = SigninRepository().sendOtp(api: sendOtpApi);
    future.then((value) => {handleResponseData(value, sendOtpApi.phoneNumber)});
  }

  void validOtp(ValidOtpApi validOtpApi) {
    Future<dynamic> future = SigninRepository().validOtp(api: validOtpApi);
    future.then((value) =>
        {handleValidOtpResponseData(value, validOtpApi.phoneNumber)});
  }

  handleResponseData(value, String phoneNumber) {
    InternetChecks.closeLoadingProgress(context);
    if (value is SuccessResponse) {
      setState(() {
        widget.mobileNo = phoneNumber;
      });
    }  else if (value is ErrorResponse) {
      showSnackbar(context, value.error?[0].message ?? value.message ?? "");
    }
  }

  handleValidOtpResponseData(value, String phoneNumber) {
    InternetChecks.closeLoadingProgress(context);
    if (value is AuthResponse) {
      log("Storing access token and refresh token in sign up flow");
      CPSessionManager().setAuthToken(value.accessToken ?? "");
      CPSessionManager().setAuthRefreshToken(value.refreshToken ?? "");

      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.bottomToTop,
              child: ForgetPasswordConfirmScreen(
                mobileNumber: phoneNumber,
              )));
    } else if (value is ErrorResponse) {
      showSnackbar(context, value.error?[0].message ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Positioned(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  headerLayout(
                      context,
                      DemoLocalizations.of(context)!
                          .getText("forgot_password"), true),
                  Text(
                    CPString.verifyOTPTitle,
                    style:
                        TextStyleUtils.primaryTextMedium.copyWith(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  imageAssets(StringUrl.verifyPinImage, 200, 200),
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: phoneNumberController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [LengthLimitingTextInputFormatter(10)],
                          textAlign: TextAlign.start,
                          validator: (value) =>
                          value!.isEmpty ? 'Mobile Number Cannot be Empty' : null,
                          // onSaved: (value) => _email = value,
                          decoration: InputDecoration(
                              fillColor: greyColor,
                              counterText: "",
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(width: 1, color: primaryColor),
                              ),
                              hintText: DemoLocalizations.of(context)
                                  ?.getText("mobile_number") ??
                                  "",
                              hintStyle: const TextStyle(color: greyColor),
                              labelText: DemoLocalizations.of(context)
                                  ?.getText("mobile_number") ??
                                  "",
                              labelStyle: TextStyleUtils.hintTextStyle,
                              suffixIcon: IconButton(
                                iconSize: 30,
                                icon: const Icon(Icons.check_circle),
                                color: Colors.green,
                                onPressed: () {
                                  // Do Nothing
                                },
                              ),
                              prefixIcon: const Icon(
                                Icons.mobile_friendly,
                                color: greyColor,
                              )),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (widget.mobileNo.isNotEmpty) ...[
                          otpCard(otpString1Controller, borderColor, context),
                          otpCard(otpString2Controller, borderColor, context),
                          otpCard(otpString3Controller, borderColor, context),
                          otpCard(otpString4Controller, borderColor, context),
                          otpCard(otpString5Controller, borderColor, context),
                          otpCard(otpString6Controller, borderColor, context),
                        ],
                      ],
                    ),
                  ),
                  if (widget.mobileNo.isNotEmpty) ...[
                    const SizedBox(
                      height: 20,
                    ),
                    secondsRemaining != 0
                        ? RichText(
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.end,
                            textDirection: TextDirection.rtl,
                            softWrap: true,
                            maxLines: 1,
                            textScaleFactor: 1,
                            text: TextSpan(
                              text: CPString.resendOtpIn,
                              style: TextStyleUtils.primaryTextRegular.copyWith(
                                color: borderColor,
                                fontSize: fontSize14,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text:
                                      '00:${secondsRemaining.toString().padLeft(2, '0')} Sec',
                                  style: TextStyleUtils.primaryTextSemiBold
                                      .copyWith(
                                    color: primaryColor,
                                    fontSize: fontSize16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : InkWell(
                            onTap: enableResend ? _resendCode : null,
                            child: RichText(
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.end,
                              textDirection: TextDirection.rtl,
                              softWrap: true,
                              maxLines: 1,
                              textScaleFactor: 1,
                              text: TextSpan(
                                text: CPString.dontreciveOtp,
                                style:
                                    TextStyleUtils.primaryTextRegular.copyWith(
                                  color: borderColor,
                                  fontSize: fontSize14,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: CPString.resendOTP,
                                    style: TextStyleUtils.primaryTextSemiBold
                                        .copyWith(
                                      color: primaryColor,
                                      fontSize: fontSize16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                  Container(
                    width: deviceWidth(context),
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: margin20),
                    margin: EdgeInsets.only(top: margin20),
                    child: ElevatedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();

                        var otpText = otpString1Controller.text.toString() +
                            otpString2Controller.text.toString() +
                            otpString3Controller.text.toString() +
                            otpString4Controller.text.toString() +
                            otpString5Controller.text.toString() +
                            otpString6Controller.text.toString();
                        log("OTP Text: $otpText");
                        if(otpText.isNotEmpty) {
                          callValidateOtpApi(
                              phoneNumberController.text.toString(), otpText);
                        } else {
                          getOtpApi(phoneNumberController.text.toString());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(margin10),
                        ),
                        elevation: margin2,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(margin10),
                        child: Text(
                          getButtonLabel(widget.mobileNo),
                          style: TextStyle(fontSize: fontSize18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  void _resendCode() {
    //other code here
    InternetChecks.isConnected()
        .then((isAvailable) => {callSendOtpApi(isAvailable, phoneNumberController.text)});
    setState(() {
      secondsRemaining = 10;
      enableResend = false;
    });
  }

  @override
  dispose() {
    timer?.cancel();
    super.dispose();
  }

  void callSendOtpApi(bool isInternetAvailable, String mobileNo) {
    if (isInternetAvailable) {
      if (mobileNo.isNotEmpty) {
        InternetChecks.showLoadingCircle(context);
        SendOtpApi sendOtpApi = SendOtpApi(phoneNumber: mobileNo);
        sendOtp(sendOtpApi);
      } else {
        showSnackbar(context, "No Internet");
      }
    }
  }

  void callValidateOtpApi(String mobileNumber, String otpText) {
    log("Mobile Number $mobileNumber");
    log("Otp $otpText");
    if (mobileNumber.isEmpty) {
      alertDialogView(context, "change_password_mobile_no_error");
    } else if (otpText.isEmpty) {
      alertDialogView(context, "change_password_otp_error");
    } else {
      if (mobileNumber.isNotEmpty && otpText.isNotEmpty) {
        InternetChecks.showLoadingCircle(context);
        ValidOtpApi validOtpApi = ValidOtpApi(
            phoneNumber: phoneNumberController.text.toString(), otp: otpText);
        validOtp(validOtpApi);
      }
    }
  }

  String getButtonLabel(String mobileNo) {
    if (mobileNo.isNotEmpty) {
      return DemoLocalizations.of(context)!.getText("verify");
    } else {
      return DemoLocalizations.of(context)!.getText("send_otp");
    }
  }

  void getOtpApi(String mobileNumber) {
    if (mobileNumber.isEmpty) {
      showSnackbar(context, "Please enter valid mobile number");
    } else {
      InternetChecks.isConnected()
          .then((isAvailable) => {
        callSendOtpApi(isAvailable, mobileNumber)
      });
    }
  }

}
