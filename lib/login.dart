import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'manage/static_method.dart';
import 'otp.dart';
import 'sign_up.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late BuildContext ctx;

  TextEditingController mobileCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Clr().white,
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
                  text: "Sign ",
                  style: Sty().smallText.copyWith(
                      fontSize: 24,
                      fontFamily: "MulshiBold",
                      fontWeight: FontWeight.w600,
                      color: Clr().textcolor),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'In',
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
              Text(
                'Sign in to access your account',
                style: Sty().smallText.copyWith(color: Clr().textcolor),
              ),
              SizedBox(
                height: Dim().d32,
              ),
              TextFormField(
                controller: mobileCtrl,
                cursorColor: Clr().textcolor,
                style: Sty().mediumText,
                maxLength: 10,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: Sty().textFieldOutlineStyle.copyWith(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7)),
                    hintStyle: Sty().smallText.copyWith(
                          color: Clr().textcolor,
                        ),
                    filled: true,
                    fillColor: Clr().grey,
                    hintText: "Enter Mobile Number",
                    counterText: "",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(Dim().d16),
                      child: SvgPicture.asset("assets/call.svg"),
                    )),
                validator: (value) {
                  if (value!.isEmpty ||
                      !RegExp(r'([5-9]{1}[0-9]{9})').hasMatch(value)) {
                    return Str().invalidMobile;
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: Dim().d32,
              ),
              Center(
                child: SizedBox(
                  height: 50,
                  width: 285,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          sendOtp();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Clr().primaryColor,
                          elevation: 0.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          )),
                      child: Text(
                        'Send OTP',
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
              Center(
                child: InkWell(
                  onTap: () {
                    STM().redirect2page(ctx, SignUp());
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "New Member? ",
                      style: Sty().smallText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Clr().textcolor),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Register now',
                          style: Sty().smallText.copyWith(
                              color: Clr().secondary,
                              fontWeight: FontWeight.w600,
                              fontFamily: "MulshiSemi",
                              fontSize: 14),
                        ),
                      ],
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

  ///Login API
  void sendOtp() async {
    FormData body = FormData.fromMap({
      'mobile': mobileCtrl.text,
    });
    var result = await STM().post(ctx, Str().sendingOtp, 'sent_login_otp', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().displayToast(message);
      STM().redirect2page(
          ctx,
          OTP(
            sMobile: mobileCtrl.text,
            sType: 'login',
          ));
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
