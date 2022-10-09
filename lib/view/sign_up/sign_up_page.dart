import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:socialcarpooling/util/TextStylesUtil.dart';
import 'package:socialcarpooling/util/configuration.dart';
import 'package:socialcarpooling/util/constant.dart';
import 'package:socialcarpooling/util/margin_confiq.dart';
import 'package:socialcarpooling/util/string_url.dart';
import 'package:socialcarpooling/view/sign_up/verify_otp_page.dart';
import 'package:socialcarpooling/widgets/header_widgets.dart';
import 'package:socialcarpooling/widgets/text_widgets.dart';

import '../../util/Validation.dart';
import '../../util/color.dart';
import '../../util/font_size.dart';
import '../../widgets/edit_text_widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with InputValidationMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController emailNoController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  late bool _passwordVisible;
  late bool _cpasswordVisible;

  int genderId = 0;
  String selectedValue = "Gender";
  String selectedValueEducation = "Education";
  String selectedValueWork = "Work";

  Future _registration(name,mobile) async {
    /*baseResponse = await DioClient().registrationRequest(
        name: name,
        mobile_no: mobile_no,
        email: email,
        dob: dob,
        village_id: village_id);
    print('Base Response : ${baseResponse}');

    if (baseResponse!.code == 1) {
      _showToast('Registration Successfully');
      Navigator.pop(context);
    } else {
      _showSnackbar(baseResponse!.message);
    }*/
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.leftToRight,
            child:VerifyOtpPage(mobileNo: mobile,)));

  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _cpasswordVisible = false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
            /*  Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: getBackButton(),
                  ),
                  Text('Sign Up', style: TextStyleUtils.primaryTextBold)
                ],
              ),*/
              headerLayout(context, Constant.signUp),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: inputEditTextWithPrefixWidget(context, Constant.fullName,
                    fullNameController, Constant.fullNameError, Icons.person,1,this,''),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: inputEditTextWithPrefixWidget(
                    context,
                    Constant.mobileNo,
                    mobileNoController,
                    Constant.mobileError,
                    Icons.mobile_screen_share_outlined,2,this,''),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: inputEditTextWithPrefixWidget(context, Constant.email,
                    emailNoController, Constant.emailError, Icons.email,3,this,''),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 2,
                      shadowColor: borderColor,
                      child: Container(
                          width: deviceWidth(context) * .3,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Center(
                              child: DropdownButtonHideUnderline(
                                child: Container(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: selectedValue,
                                    hint: const Text(
                                      Constant.gender,
                                      style: TextStyleUtils.primaryTextMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    items: dataGenderList.map((list) {
                                      return DropdownMenuItem(
                                        value: list.toString(),
                                        child: Text(list),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValue = value.toString();
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
                          )),
                    ),
                  ),
                  Container(
                    width: deviceWidth(context) * .6,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 2,
                      shadowColor: borderColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: TextFormField(
                          controller: dateController,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.edit,
                              color: primaryColor,
                            ),
                            border: InputBorder.none,
                            labelText: Constant.selectDate,
                            labelStyle: TextStyleUtils.hintTextStyle,
                            hintText: Constant.selectDate,
                            hintStyle: TextStyleUtils.hintTextStyle,
                          ),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            await _selectDate();
                          },
                          validator: (value) {
                            if (value!.isEmpty || value.isEmpty) {
                              return Constant.selectDate;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,),
                    SizedBox(width: 5,),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                        child: Text(Constant.passwordInfo,style: TextStyleUtils.primaryTextRegular.copyWith(fontSize: 14),))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding:  EdgeInsets.symmetric(horizontal: 30),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 2,
                  shadowColor: borderColor,
                  child: Container(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        labelText: Constant.password,
                        hintText: Constant.password,
                        labelStyle: TextStyleUtils.hintTextStyle,
                        hintStyle: TextStyleUtils.hintTextStyle,
                        // Here is key idea
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock,color: primaryColor,),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            Icons.visibility,
                            color:_passwordVisible? Colors.black:primaryColor,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return Constant.passwordError;
                        }
                        else if(isPasswordValid(value))
                        {
                          return Constant.passwordValidError;

                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding:  EdgeInsets.symmetric(horizontal: 30),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 2,
                  shadowColor: borderColor,
                  child: Container(
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: cpasswordController,
                      obscureText: !_cpasswordVisible,
                      decoration: InputDecoration(
                        labelText: Constant.confirmPassword,
                        hintText: Constant.confirmPassword,
                        labelStyle: TextStyleUtils.hintTextStyle,
                        hintStyle: TextStyleUtils.hintTextStyle,
                        // Here is key idea
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock,color: primaryColor,),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            Icons.visibility,
                            color:_cpasswordVisible? Colors.black:primaryColor,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _cpasswordVisible = !_cpasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return Constant.cPasswordError;
                        }
                        else if(isPasswordValid(value))
                        {
                          return Constant.passwordValidError;
                        }
                        else if(passwordController.text.toString()!=value)
                        {
                          return Constant.cPasswordValidError;
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 2,
                  shadowColor: borderColor,
                  child: Container(
                      width: deviceWidth(context) * .3,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Center(
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              child: DropdownButton(
                                isExpanded: true,
                                value: selectedValueWork,

                                hint:  Text(
                                  'Work',
                                  style: TextStyleUtils.primaryTextMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                items: dataWorkList.map((list) {
                                  return DropdownMenuItem(
                                    value: list.toString(),
                                    child: Text(list),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedValueWork = value.toString();
                                  });
                                },
                                icon: SvgPicture.asset(
                                  'assets/svgimages/down_arrow.svg',
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 2,
                  shadowColor: borderColor,
                  child: Container(
                      width: deviceWidth(context) * .3,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Center(
                          child: DropdownButtonHideUnderline(
                            child: Container(
                              child: DropdownButton(
                                isExpanded: true,
                                value: selectedValueEducation,
                                hint: const Text(
                                  'Education',
                                  style: TextStyleUtils.primaryTextMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                items: dataEducationList.map((list) {
                                  return DropdownMenuItem(
                                    value: list.toString(),
                                    child: Text(list),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedValueEducation = value.toString();
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
                      )),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30,right: 30,top: 10,bottom: 10),
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _registration(fullNameController.text,mobileNoController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(margin20),
                    ),
                    elevation: margin2,
                  ),
                  child: Padding(
                   padding: EdgeInsets.all(20),
                    child: Text(
                      Constant.continueString,
                      style: TextStyle(fontSize: fontSize18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _selectDate() async {
    DateTime? picker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime.now());

    if (picker != null) {
      setState(() {
        String formattedDate = DateFormat('dd,MMM,yyyy').format(picker);
        dateController.text = formattedDate;
      });
    }
  }

}
