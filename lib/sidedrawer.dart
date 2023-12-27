import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_click/manage/static_method.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'login.dart';
import 'my_profile.dart';
import 'my_request.dart';
import 'notification.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

Widget navBar(context, scaffoldState, name) {
  return SafeArea(
    child: WillPopScope(
      onWillPop: () async {
        if (scaffoldState.currentState.isDrawerOpen) {
          scaffoldState.currentState.openEndDrawer();
        }
        return true;
      },
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.75,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(color: Clr().white),
          child: WillPopScope(
            onWillPop: () async {
              if (scaffoldState.currentState!.isDrawerOpen) {
                scaffoldState.currentState!.openEndDrawer();
              }
              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    color: Clr().primaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/profile.svg",
                          width: 70,
                        ),
                        SizedBox(height: Dim().d12),
                        Text(
                          "${name}",
                          style: Sty().smallText.copyWith(color: Clr().white),
                        ),
                        // SizedBox(height: Dim().d12),
                        // Text(
                        //   "Mobile Number : 2589745123",
                        //   style: Sty().microText.copyWith(color: Clr().white),
                        // ),
                      ],
                    ),
                    // Image.asset('assets/sidedrawer.png', fit: BoxFit.fill),
                    // width: 150,
                    height: 200,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8, left: 8),
                    // decoration: BoxDecoration(color: Color(0xffABE68C)),
                    child: ListTile(
                      // minLeadingWidth : 4,
                      leading: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          'assets/home.svg',
                          color: Clr().primaryColor,
                        ),
                      ),
                      title: Transform.translate(
                        offset: Offset(-10, 0),
                        child: Text(
                          'Home',
                          style: Sty().mediumText.copyWith(
                              fontSize: 14,
                              color: Clr().textcolor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),

                      onTap: () {
                        STM().finishAffinity(context, Home());
                        scaffoldState.currentState?.closeEndDrawer();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8, left: 8),
                    // decoration: BoxDecoration(color: Color(0xffABE68C)),
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          'assets/my_request.svg',
                          color: Clr().primaryColor,
                        ),
                      ),
                      title: Transform.translate(
                        offset: Offset(-10, 0),
                        child: Text(
                          'My Requests',
                          style: Sty().mediumText.copyWith(
                              fontSize: 14,
                              color: Clr().textcolor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      onTap: () {
                        STM().redirect2page(context, MyRequest());
                        scaffoldState.currentState?.closeEndDrawer();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8, left: 8),
                    // decoration: BoxDecoration(color: Color(0xffABE68C)),
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          'assets/my_profile.svg',
                          color: Clr().primaryColor,
                        ),
                      ),
                      title: Transform.translate(
                        offset: Offset(-10, 0),
                        child: Text(
                          'My Profile',
                          style: Sty().mediumText.copyWith(
                              fontSize: 14,
                              color: Clr().textcolor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      onTap: () {
                        STM().redirect2page(
                            context,
                            MyProfile(
                              index: 3,
                            ));
                        scaffoldState.currentState?.closeEndDrawer();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8, left: 8),
                    // decoration: BoxDecoration(color: Color(0xffABE68C)),
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          'assets/notification.svg',
                          color: Clr().primaryColor,
                        ),
                      ),
                      title: Transform.translate(
                        offset: Offset(-10, 0),
                        child: Text(
                          'Notification',
                          style: Sty().mediumText.copyWith(
                              fontSize: 14,
                              color: Clr().textcolor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      onTap: () {
                        STM().redirect2page(context, NotificationPage());
                        scaffoldState.currentState?.closeEndDrawer();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8, left: 8),
                    // decoration: BoxDecoration(color: Color(0xffABE68C)),
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          'assets/privacy_policy.svg',
                          color: Clr().primaryColor,
                        ),
                      ),
                      title: Transform.translate(
                        offset: Offset(-10, 0),
                        child: Text(
                          'Privacy Policy',
                          style: Sty().mediumText.copyWith(
                              fontSize: 14,
                              color: Clr().textcolor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      onTap: () {
                        scaffoldState.currentState?.closeEndDrawer();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8, left: 8),
                    // decoration: BoxDecoration(color: Color(0xffABE68C)),
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          'assets/t&c.svg',
                          color: Clr().primaryColor,
                        ),
                      ),
                      title: Transform.translate(
                        offset: Offset(-10, 0),
                        child: Text(
                          'Terms & Conditions',
                          style: Sty().mediumText.copyWith(
                              fontSize: 14,
                              color: Clr().textcolor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      onTap: () {
                        scaffoldState.currentState?.closeEndDrawer();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8, left: 8),
                    // decoration: BoxDecoration(color: Color(0xffABE68C)),
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          'assets/share.svg',
                          color: Clr().primaryColor,
                        ),
                      ),
                      title: Transform.translate(
                        offset: Offset(-10, 0),
                        child: Text(
                          'Share App',
                          style: Sty().mediumText.copyWith(
                              fontSize: 14,
                              color: Clr().textcolor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),

                      // onTap: () {
                      //   Navigator.of(context).pop();
                      //   showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return AlertDialog(
                      //           title: Text('Log Out',
                      //               style: Sty().mediumBoldText),
                      //           content: Text('Are you sure want to Log Out?',
                      //               style: Sty().mediumText),
                      //           actions: [
                      //             TextButton(
                      //                 onPressed: () {
                      //                   setState(() async {
                      //                     SharedPreferences sp =
                      //                         await SharedPreferences
                      //                             .getInstance();
                      //                     sp.setBool('login', false);
                      //                     sp.clear();
                      //                     STM().finishAffinity(ctx, Login());
                      //                   });
                      //                   // deleteProfile();
                      //                 },
                      //                 child: Text('Yes',
                      //                     style: Sty().smallText.copyWith(
                      //                         color: Colors.red,
                      //                         fontWeight: FontWeight.w600))),
                      //             TextButton(
                      //                 onPressed: () {
                      //                   STM().back2Previous(ctx);
                      //                 },
                      //                 child: Text('No',
                      //                     style: Sty().smallText.copyWith(
                      //                         fontWeight: FontWeight.w600))),
                      //           ],
                      //         );
                      //       });
                      //   // deleteData();
                      // },

                      // onTap: () {
                      //   setState(() async {
                      //     SharedPreferences sp =
                      //     await SharedPreferences.getInstance();
                      //     sp.setBool('login', false);
                      //     sp.clear();
                      //     STM().finishAffinity(ctx, SignIn());
                      //   });
                      // },
                    ),
                  ),
                  SizedBox(
                    height: Dim().d4,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8, left: 8),
                    // decoration: BoxDecoration(color: Color(0xffABE68C)),
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          'assets/about.svg',
                          color: Clr().primaryColor,
                        ),
                      ),
                      title: Transform.translate(
                        offset: Offset(-10, 0),
                        child: Text(
                          'About Us',
                          style: Sty().mediumText.copyWith(
                              fontSize: 14,
                              color: Clr().textcolor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      onTap: () {
                        scaffoldState.currentState?.closeEndDrawer();
                      },
                    ),
                  ),
                  SizedBox(
                    height: Dim().d4,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 8, left: 8),
                    // decoration: BoxDecoration(color: Color(0xffABE68C)),
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset(
                          'assets/contact.svg',
                          color: Clr().primaryColor,
                        ),
                      ),
                      title: Transform.translate(
                        offset: Offset(-10, 0),
                        child: Text(
                          'Contact Us',
                          style: Sty().mediumText.copyWith(
                              fontSize: 14,
                              color: Clr().textcolor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      onTap: () {
                        scaffoldState.currentState?.closeEndDrawer();
                      },
                    ),
                  ),
                  SizedBox(
                    height: Dim().d20,
                  ),
                  InkWell(
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  Image.asset('assets/exit.png'),
                                  SizedBox(
                                    height: Dim().d12,
                                  ),
                                  Text('Logout?',
                                      style: Sty().mediumBoldText),
                                  SizedBox(
                                    height: Dim().d12,
                                  ),
                                  Text('Are you sure want to Log Out?',
                                      style: Sty().mediumText),
                                  SizedBox(
                                    height: Dim().d28,
                                  ),
                                  ElevatedButton(
                                      onPressed: ()async {
                                        SharedPreferences sp = await SharedPreferences.getInstance();
                                        sp.setBool('login', false);
                                        sp.clear();
                                        STM().finishAffinity(context, Login());
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Clr().clr29,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(
                                                      Dim().d12)))),
                                      child: Center(
                                        child: Text('Log Out',
                                            style: Sty()
                                                .mediumText
                                                .copyWith(
                                                color: Clr().white)),
                                      )),
                                ],
                              ),
                            );
                          });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8, left: 8),
                      // decoration: BoxDecoration(color: Color(0xffABE68C)),
                      child: ListTile(
                        title: Transform.translate(
                            offset: Offset(-10, 0),
                            child: Column(
                              children: [
                                Text(
                                  "Logout",
                                  style: Sty().mediumText.copyWith(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w600,
                                      color: Clr().red),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void close(key) {
  key.currentState.openEndDrawer();
}
