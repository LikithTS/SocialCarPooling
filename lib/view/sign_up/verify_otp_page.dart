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
import 'package:socialcarpooling/util/TextStylesUtil.dart';
import 'package:socialcarpooling/util/configuration.dart';
import 'package:socialcarpooling/util/string_url.dart';
import 'package:socialcarpooling/view/profile/util/GetProfileDetails.dart';
import 'package:socialcarpooling/view/sign_up/verifyed_page.dart';
import 'package:socialcarpooling/widgets/header_widgets.dart';
import 'package:socialcarpooling/widgets/otp_edittext_view.dart';

import '../../util/Validation.dart';
import '../../util/color.dart';
import '../../font&margin/margin_confiq.dart';
import '../../widgets/edit_text_widgets.dart';
import '../../widgets/image_widgets.dart';

class VerifyOtpPage extends StatefulWidget {
  final String userName;
  final String mobileNo;

  const VerifyOtpPage(
      {Key? key, required this.mobileNo, required this.userName})
      : super(key: key);

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage>
    with InputValidationMixin {
  TextEditingController mobileNoController = TextEditingController();
  int secondsRemaining = 30;
  bool enableResend = false;
  bool enableSendOtpButton = false;
  Timer? timer;
  SigninRepository signInRepository = SigninRepository();

  TextEditingController otpString1Controller = TextEditingController();
  TextEditingController otpString2Controller = TextEditingController();
  TextEditingController otpString3Controller = TextEditingController();
  TextEditingController otpString4Controller = TextEditingController();
  TextEditingController otpString5Controller = TextEditingController();
  TextEditingController otpString6Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    mobileNoController.text = widget.mobileNo;
    callSendOtpApi(widget.mobileNo);
    timer = Timer.periodic(Duration(seconds: 1), (_) {
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
    Future<dynamic> future = signInRepository.sendOtp(api: sendOtpApi);
    future.then((value) => {handleResponseData(value)});
    //     .catchError((onError) {
    //   handleErrorResponse(onError);
    // });
  }

  void validOtp(ValidOtpApi validOtpApi) {
    Future<dynamic> future = signInRepository.validOtp(api: validOtpApi);
    future.then((value) => {handleValidOtpResponseData(value)});
    //     .catchError((onError) {
    //   handleErrorResponse(onError);
    // });
  }

  handleResponseData(value) {
    if (value is SuccessResponse) {
      // print("Success ${value.statusCode}");
    } else {
      ErrorResponse errorResponse = value;
      print('Error ${errorResponse.errorMessage}');
    }
  }

  handleValidOtpResponseData(value) {
    if (value is AuthResponse) {
      log("Storing access token and refresh token in sign up flow");
      CPSessionManager().setAuthToken(value.accessToken ?? "");
      CPSessionManager().setAuthRefreshToken(value.refreshToken ?? "");
      GetProfileDetails(context);
      Timer(
          const Duration(seconds: 2),
              () => Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.bottomToTop,
                  child: const VerifiedPage())));
    } else {
      ErrorResponse errorResponse = value;
      log('Error ${errorResponse.errorMessage}');
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
                  headerLayout(context, CPString.verifyOTP),
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
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: inputEditTextWithPrefixWidget(
                            context,
                            CPString.mobileNo,
                            mobileNoController,
                            CPString.mobileError,
                            Icons.mobile_screen_share_outlined,
                            4,
                            10,
                            this,
                            widget.mobileNo),
                      ),
                      InkWell(
                          onTap: () {
                            setState(() {
                              enableSendOtpButton = true;
                            });
                          },
                          child: Positioned(
                              right: 40,
                              bottom: 15,
                              child: Text(
                                'Edit',
                                style: TextStyleUtils.primaryTextMedium
                                    .copyWith(
                                        color: primaryColor,
                                        fontSize: fontSize16),
                              )
                          )
                      ),
                      if (enableSendOtpButton) ...[
                        InkWell(
                            onTap: () {
                              setState(() {
                                enableSendOtpButton = false;
                                callSendOtpApi(widget.mobileNo);
                              });
                            },
                            child: Positioned(
                                right: 40,
                                bottom: 15,
                                child: Text(
                                  'Send OTP',
                                  style: TextStyleUtils.primaryTextMedium
                                      .copyWith(
                                      color: primaryColor,
                                      fontSize: fontSize16),
                                )
                            )
                        ),
                      ],
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        otpCard(otpString1Controller, borderColor, context),
                        otpCard(otpString2Controller, borderColor, context),
                        otpCard(otpString3Controller, borderColor, context),
                        otpCard(otpString4Controller, borderColor, context),
                        otpCard(otpString5Controller, borderColor, context),
                        otpCard(otpString6Controller, borderColor, context),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  /* ElevatedButton(
                    child: Text('Resend Code'),
                    onPressed: enableResend ? _resendCode : null,
                  ),*/
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
                                style:
                                    TextStyleUtils.primaryTextSemiBold.copyWith(
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
                              style: TextStyleUtils.primaryTextRegular.copyWith(
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
                  Container(
                    width: deviceWidth(context),
                    padding: EdgeInsets.symmetric(horizontal: margin20),
                    margin: EdgeInsets.only(top: margin20),
                    child: ElevatedButton(
                      onPressed: () {
                        CPSessionManager().setUserName(widget.userName);

                        /*  Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: VerifiedPage()));*/
                        var otpText = otpString1Controller.text.toString() +
                            otpString2Controller.text.toString() +
                            otpString3Controller.text.toString() +
                            otpString4Controller.text.toString() +
                            otpString5Controller.text.toString() +
                            otpString6Controller.text.toString();
                        log("OTP Text: $otpText");
                        ValidOtpApi validOtpApi = ValidOtpApi(
                            phoneNumber: mobileNoController.text.toString(),
                            otp: otpText);
                        validOtp(validOtpApi);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(margin20),
                        ),
                        elevation: margin2,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(margin20),
                        child: Text(
                          CPString.verify,
                          style: TextStyle(fontSize: fontSize18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: Container(
              margin: EdgeInsets.only(bottom: margin10),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RichText(
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.end,
                  textDirection: TextDirection.rtl,
                  softWrap: true,
                  maxLines: 1,
                  textScaleFactor: 1,
                  text: TextSpan(
                    text: CPString.signupAgree,
                    style: TextStyleUtils.primaryTextRegular.copyWith(
                      color: borderColor,
                      fontSize: fontSize14,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: CPString.termsConditions,
                        style: TextStyleUtils.primaryTextSemiBold.copyWith(
                            color: primaryColor,
                            fontSize: fontSize16,
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }

  void _resendCode() {
    //other code here
    callSendOtpApi(widget.mobileNo);
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

  void callSendOtpApi(String mobileNo) {
    if (mobileNo.isNotEmpty) {
      SendOtpApi sendOtpApi = SendOtpApi(phoneNumber: mobileNo);
      sendOtp(sendOtpApi);
    }
  }
}
