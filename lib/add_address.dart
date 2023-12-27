import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/home.dart';
import 'package:one_click/values/colors.dart';
import 'package:one_click/values/dimens.dart';
import 'package:one_click/values/styles.dart';

import 'manage/static_method.dart';
import 'map.dart';
import 'values/strings.dart';

class AddAddress extends StatefulWidget {
  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  late BuildContext ctx;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      backgroundColor: Clr().white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Clr().white,
        leadingWidth: 52,
        centerTitle: true,
        title: Text(
          'Add Address',
          style: Sty().largeText.copyWith(fontSize: 20, color: Clr().textcolor),
        ),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  STM().redirect2page(ctx, MapLocation());
                },
                child: Row(
                  children: [
                    SvgPicture.asset('assets/cr_loaction.svg'),
                    SizedBox(
                      width: Dim().d12,
                    ),
                    Text(
                      'Use map location*',
                      style: Sty().smallText.copyWith(color: Clr().secondary),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: Dim().d32,
              ),
              TextFormField(
                // controller: nameCtrl,
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
                      hintText: "House No., Building Name*",
                      counterText: "",
                    ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return Str().invalidEmpty;
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: Dim().d20,
              ),
              TextFormField(
                // controller: nameCtrl,
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
                  hintText: "Add Nearby Famouse Shop/Mall/Landmark*",
                  counterText: "",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return Str().invalidEmpty;
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: Dim().d20,
              ),
              TextFormField(
                // controller: nameCtrl,
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
                  hintText: "State*",
                  counterText: "",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return Str().invalidEmpty;
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: Dim().d20,
              ),
              TextFormField(
                // controller: nameCtrl,
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
                  hintText: "City*",
                  counterText: "",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return Str().invalidEmpty;
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: Dim().d20,
              ),
              TextFormField(
                // controller: nameCtrl,
                cursorColor: Clr().textcolor,
                style: Sty().mediumText,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                maxLength: 6,
                decoration: Sty().textFieldOutlineStyle.copyWith(
                  hintStyle: Sty().smallText.copyWith(
                    color: Clr().textGrey,
                  ),
                  filled: true,
                  fillColor: Clr().grey,
                  hintText: "Pincode*",
                  counterText: "",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return Str().invalidEmpty;
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
                        if (formKey.currentState!.validate()) {
                          STM().checkInternet(context, widget).then((value) {
                            if (value) {
                              // sendOtp();
                              STM().redirect2page(ctx, Home());
                            }
                          });
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
                        'Save Address',
                        style: Sty().mediumText.copyWith(
                          fontSize: 16,
                          color: Clr().white,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
