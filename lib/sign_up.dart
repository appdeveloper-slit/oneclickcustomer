import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'login.dart';
import 'manage/static_method.dart';
import 'otp.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late BuildContext ctx;

  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                  text: "Sign ",
                  style: Sty().smallText.copyWith(
                      fontSize: 24,
                      fontFamily: "MulshiBold",
                      fontWeight: FontWeight.w600,
                      color: Clr().textcolor),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Up',
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
                'Sign up to experience a whole new level of service.',
                style: Sty().smallText.copyWith(color: Clr().textcolor),
              ),
              SizedBox(
                height: Dim().d32,
              ),
              TextFormField(
                controller: nameCtrl,
                cursorColor: Clr().textcolor,
                style: Sty().mediumText,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                decoration: Sty().textFieldOutlineStyle.copyWith(
                    hintStyle: Sty().smallText.copyWith(
                          color: Clr().textGrey,
                        ),
                    filled: true,
                    fillColor: Clr().grey,
                    hintText: "Full name",
                    counterText: "",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(Dim().d16),
                      child: SvgPicture.asset("assets/name.svg"),
                    )),
                validator: (value) {
                  if (value!.isEmpty) {
                    return Str().invalidName;
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: Dim().d20,
              ),
              TextFormField(
                controller: emailCtrl,
                cursorColor: Clr().textcolor,
                style: Sty().mediumText,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration: Sty().textFieldOutlineStyle.copyWith(
                    hintStyle: Sty().smallText.copyWith(
                          color: Clr().textGrey,
                        ),
                    filled: true,
                    fillColor: Clr().grey,
                    hintText: "Email-ID",
                    counterText: "",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(Dim().d16),
                      child: SvgPicture.asset("assets/mail.svg"),
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email id is required';
                  }
                  if (!RegExp(
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                      .hasMatch(value)) {
                    return "Please enter a valid email address";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: Dim().d20,
              ),
              TextFormField(
                controller: mobileCtrl,
                cursorColor: Clr().textcolor,
                style: Sty().mediumText,
                maxLength: 10,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: Sty().textFieldOutlineStyle.copyWith(
                    hintStyle: Sty().smallText.copyWith(
                          color: Clr().textGrey,
                        ),
                    filled: true,
                    fillColor: Clr().grey,
                    hintText: "Phone number",
                    counterText: "",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(Dim().d16),
                      child: SvgPicture.asset("assets/call.svg"),
                    )),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Mobile number is required';
                  }
                  if (value.length != 10) {
                    return 'Mobile number must be 10 digits long';
                  }
                },
              ),
              SizedBox(
                height: Dim().d12,
              ),
              Padding(
                padding: EdgeInsets.only(left: Dim().d12),
                child: RichText(
                  text: TextSpan(
                    text: "By continuing I agree to the ",
                    style: Sty().smallText.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Clr().textcolor),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Terms & Conditions.',
                        style: Sty().smallText.copyWith(
                            color: Clr().secondary,
                            fontWeight: FontWeight.w400,
                            fontFamily: "MulshiSemi",
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
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
                        ;
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
                    STM().redirect2page(ctx, Login());
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already a member? ",
                      style: Sty().smallText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Clr().textcolor),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Log In',
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

  ///Register API
  void sendOtp() async {
    FormData body = FormData.fromMap({
      'mobile': mobileCtrl.text,
      "name": nameCtrl.text,
      "email": emailCtrl.text,
    });
    var result = await STM().post(ctx, Str().sendingOtp, 'sent_otp', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().displayToast(message);
      STM().redirect2page(
          ctx,
          OTP(
            sMobile: mobileCtrl.text,
            sName: nameCtrl.text,
            sEmail: emailCtrl.text,
            sType: 'register',
          ));
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
