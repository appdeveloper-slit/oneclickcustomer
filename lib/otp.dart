import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class OTP extends StatefulWidget {
  final sMobile, sName, sEmail, sType;

  const OTP({
    Key? key,
    this.sMobile,
    this.sName,
    this.sEmail,
    this.sType,
  }) : super(key: key);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  late BuildContext ctx;

  dynamic dataList;
  StreamController<ErrorAnimationType> errorController =
  StreamController<ErrorAnimationType>();
  String? _pinCode;
  bool again = false;
  TextEditingController otpCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      backgroundColor: Clr().white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Clr().white,
        leadingWidth: 52,
        leading: InkWell(
            onTap: () {
              STM().back2Previous(ctx);
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                  padding: EdgeInsets.all(10),
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      color: Clr().primaryColor, shape: BoxShape.circle),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Clr().white,
                    size: 18,
                  )),
            )),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Dim().d12,
              ),
              RichText(
                text: TextSpan(
                  text: "OTP ",
                  style: Sty().smallText.copyWith(
                      fontSize: 24,
                      fontFamily: "MulshiBold",
                      fontWeight: FontWeight.w600,
                      color: Clr().textcolor),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Verification',
                      style: Sty().smallText.copyWith(
                            color: Clr().secondary,
                            fontSize: 24,
                            fontFamily: "MulshiBold",
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Dim().d12,
              ),
              SizedBox(
                height: Dim().d6,
              ),
              RichText(
                text: TextSpan(
                  text:
                      "Please enter the 4-digit code sent to your Mobile Number ",
                  style: Sty().smallText.copyWith(
                      height: 1.5,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Clr().textcolor),
                  children: <TextSpan>[
                    TextSpan(
                      text: '+91 ${widget.sMobile}',
                      style: Sty().smallText.copyWith(
                          color: Clr().secondary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Dim().d32,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                child: PinCodeTextField(
                  controller: otpCtrl,
                  errorAnimationController: errorController,
                  appContext: context,
                  enableActiveFill: true,
                  textStyle: Sty().largeText,
                  length: 4,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  animationType: AnimationType.scale,
                  cursorColor: Clr().primaryColor,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.circle,
                    // borderRadius: BorderRadius.circular(50),
                    fieldWidth: Dim().d56,
                    fieldHeight: Dim().d56,
                    selectedFillColor: Clr().white,
                    activeFillColor: Clr().white,
                    inactiveFillColor: Clr().grey,
                    borderWidth: 0.2,
                    inactiveColor: Clr().grey,
                    activeColor: Clr().textcolor,
                    selectedColor: Clr().textcolor,
                  ),
                  animationDuration: const Duration(milliseconds: 200),
                  onChanged: (value) {
                    _pinCode = value;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty || !RegExp(r'(.{4,})').hasMatch(value)) {
                      return "";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(
                height: Dim().d24,
              ),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 285,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.sType == 'register'
                              ? registerOtp()
                              : loginOtp();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Clr().primaryColor,
                          elevation: 0.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          )),
                      child: Text(
                        'Verify',
                        style: Sty().mediumText.copyWith(
                              fontSize: 16,
                              color: Clr().white,
                              fontWeight: FontWeight.w600,
                            ),
                      )),
                ),
              ),
              SizedBox(
                height: Dim().d24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Request new code in ",
                    style: Sty().smallText.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Clr().textcolor),
                  ),
                  Visibility(
                    visible: !again,
                    child: TweenAnimationBuilder<Duration>(
                        duration: const Duration(seconds: 60),
                        tween: Tween(
                            begin: const Duration(seconds: 60),
                            end: Duration.zero),
                        onEnd: () {
                          // ignore: avoid_print
                          // print('Timer ended');
                          setState(() {
                            again = true;
                          });
                        },
                        builder: (BuildContext context, Duration value,
                            Widget? child) {
                          final minutes = value.inMinutes;
                          final seconds = value.inSeconds % 60;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "0$minutes:$seconds",
                              textAlign: TextAlign.center,
                              style: Sty().smallText.copyWith(
                                  color: Clr().secondary,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "MulshiSemi",
                                  fontSize: 14),
                            ),
                          );
                        }),
                  ),
                  // Visibility(
                  //   visible: !isResend,
                  //   child: Text("I didn't receive a code! ${(  sTime  )}",
                  //       style: Sty().mediumText),
                  // ),
                  Visibility(
                    visible: again,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          again = false;
                        });
                        resendOTP();
                      },
                      child: Text(
                        'Resend',
                        style: Sty().smallText.copyWith(
                            color: Clr().secondary,
                            fontWeight: FontWeight.w600,
                            fontFamily: "MulshiSemi",
                            fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///Register API
  void registerOtp() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'email': widget.sEmail,
      'name': widget.sName,
      'mobile': widget.sMobile,
      'otp': otpCtrl.text,
    });
    var result = await STM().post(ctx, Str().verifying, 'verify_otp', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        STM().displayToast(message);
        sp.setString('token', result['data']['token'].toString());
        sp.setBool('is_login', true);
        STM().successDialogWithAffinity(ctx, message, Home());
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  ///Login API
  void loginOtp() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'otp': otpCtrl.text,
      'mobile': widget.sMobile,
    });
    var result =
        await STM().post(ctx, Str().verifying, 'verify_login_otp', body);
    dataList = result;
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        STM().displayToast(message);
        sp.setString('token', result['data']['token'].toString());
        sp.setBool('is_login', true);
        STM().successDialogWithAffinity(ctx, message, Home());
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  /// resend otp
  void resendOTP() async {
    //Input
    FormData body = FormData.fromMap({
      'mobile': widget.sMobile,
    });
    //Output
    var result = await STM().post(ctx, Str().sendingOtp, "resent_otp", body);
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (!mounted) return;
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().displayToast(message);
    } else {
      STM().errorDialog(ctx, message);
      // _showSuccessDialog(ctx,message);
    }
  }
}
