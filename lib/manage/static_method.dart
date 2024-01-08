import 'dart:convert';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../login.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'app_url.dart';

class STM {
  void redirect2page(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  void replacePage(BuildContext context, Widget widget) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => widget,
      ),
    );
  }

  getAddressFromLatLng(double lat, double lng) async {
    List<Placemark> list = await placemarkFromCoordinates(lat, lng);
    var address =
        "${list[0].thoroughfare!}, ${list[0].subLocality!}, ${list[0].locality!}, ${list[0].postalCode!}, ${list[0].administrativeArea!}";
    return address;
  }

  void back2Previous(BuildContext context) {
    Navigator.pop(context);
  }

  void displayToast(String string) {
    Fluttertoast.showToast(msg: string, toastLength: Toast.LENGTH_SHORT);
  }

  openWeb(String url) async {
    await launchUrl(Uri.parse(url.toString()));
  }

  void finishAffinity(final BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => widget,
      ),
      (Route<dynamic> route) => false,
    );
  }

  void successDialog(context, message, widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.SCALE,
            headerAnimationLoop: true,
            title: 'Success',
            desc: message,
            btnOkText: "OK",
            btnOkOnPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => widget),
              );
            },
            btnOkColor: Clr().primaryColor)
        .show();
  }

  AwesomeDialog successWithButton(context, message, function) {
    return AwesomeDialog(
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.SCALE,
        headerAnimationLoop: true,
        title: 'Success',
        desc: message,
        btnOkText: "OK",
        btnOkOnPress: function,
        btnOkColor: Clr().successGreen);
  }

  void successDialogWithAffinity(
      BuildContext context, String message, Widget widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.SCALE,
            headerAnimationLoop: true,
            title: 'Success',
            desc: message,
            btnOkText: "OK",
            btnOkOnPress: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => widget,
                ),
                (Route<dynamic> route) => false,
              );
            },
            btnOkColor: Clr().primaryColor)
        .show();
  }

  void successDialogWithReplace(
      BuildContext context, String message, Widget widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.SUCCES,
            animType: AnimType.SCALE,
            headerAnimationLoop: true,
            title: 'Success',
            desc: message,
            btnOkText: "OK",
            btnOkOnPress: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => widget,
                ),
              );
            },
            btnOkColor: Clr().successGreen)
        .show();
  }

  void errorDialog(BuildContext context, String message) {
    if (message.contains('Inactive')) {
      errorDialogWithAffinity(context, message, Login());
    } else {
      AwesomeDialog(
              context: context,
              dismissOnBackKeyPress: false,
              dismissOnTouchOutside: false,
              dialogType: DialogType.ERROR,
              animType: AnimType.SCALE,
              headerAnimationLoop: true,
              title: 'Note',
              desc: message,
              btnOkText: "OK",
              btnOkOnPress: () {},
              btnOkColor: Clr().errorRed)
          .show();
    }
  }

  void deleteCartDialog(BuildContext context, String message) {
    if (message.contains('Inactive')) {
      errorDialogWithAffinity(context, message, Login());
    } else {
      AwesomeDialog(
              context: context,
              dismissOnBackKeyPress: false,
              dismissOnTouchOutside: false,
              dialogType: DialogType.ERROR,
              animType: AnimType.SCALE,
              headerAnimationLoop: true,
              title: 'Are You Sure ?',
              desc: message,
              btnOkText: "OK",
              btnOkOnPress: () {},
              btnOkColor: Clr().errorRed)
          .show();
    }
  }

  void errorDialogWithAffinity(
      BuildContext context, String message, Widget widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.SCALE,
            headerAnimationLoop: true,
            title: 'Error',
            desc: message,
            btnOkText: "OK",
            btnOkOnPress: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => widget,
                ),
                (Route<dynamic> route) => false,
              );
              SharedPreferences sp = await SharedPreferences.getInstance();
              sp.clear();
            },
            btnOkColor: Clr().errorRed)
        .show();
  }

  void errorDialogWithReplace(
      BuildContext context, String message, Widget widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.SCALE,
            headerAnimationLoop: true,
            title: 'Note',
            desc: message,
            btnOkText: "OK",
            btnOkOnPress: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => widget,
                ),
              );
            },
            btnOkColor: Clr().errorRed)
        .show();
  }

  AwesomeDialog loadingDialog(BuildContext context, String title) {
    AwesomeDialog dialog = AwesomeDialog(
      barrierColor: Clr().black.withOpacity(0.5),
      width: MediaQuery.of(context).size.width / 1.3,
      context: context,
      dismissOnBackKeyPress: true,
      dismissOnTouchOutside: false,
      dialogType: DialogType.NO_HEADER,
      animType: AnimType.SCALE,
      body: WillPopScope(
        onWillPop: () async {
          displayToast('Something went wrong try again.');
          return true;
        },
        child: Container(
          padding: EdgeInsets.all(Dim().d16),
          decoration: BoxDecoration(
            color: Clr().white,
            borderRadius: BorderRadius.circular(Dim().d32),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: Dim().d56),
                child: Lottie.asset('animations/one_click_loader.json',
                    height: 150,
                    width: 250,
                    repeat: true,
                    fit: BoxFit.fitWidth),
              ),
              Text(
                title,
                style: Sty().mediumText.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
    return dialog;
  }

  Widget sb({
    double? h,
    double? w,
  }) {
    return SizedBox(
      height: h,
      width: w,
    );
  }

  void alertDialog(context, message, widget) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        AlertDialog dialog = AlertDialog(
          title: Text(
            "Confirmation",
            style: Sty().largeText,
          ),
          content: Text(
            message,
            style: Sty().smallText,
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {},
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
        return dialog;
      },
    );
  }

  AwesomeDialog modalDialog(context, widget, color) {
    AwesomeDialog dialog = AwesomeDialog(
      dialogBackgroundColor: color,
      context: context,
      dialogType: DialogType.NO_HEADER,
      animType: AnimType.SCALE,
      body: widget,
    );
    return dialog;
  }

  void mapDialog(BuildContext context, Widget widget) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER,
      padding: EdgeInsets.zero,
      animType: AnimType.SCALE,
      body: widget,
      btnOkText: 'Done',
      btnOkColor: Clr().successGreen,
      btnOkOnPress: () {},
    ).show();
  }

  Widget setSVG(name, size, color) {
    return SvgPicture.asset(
      'assets/$name.svg',
      height: size,
      width: size,
      color: color,
    );
  }

  Widget emptyData(message) {
    return Center(
      child: Text(
        message,
        style: Sty().smallText.copyWith(
              color: Clr().primaryColor,
              fontSize: 18.0,
            ),
      ),
    );
  }

  List<BottomNavigationBarItem> getBottomList(index) {
    return [
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top: Dim().d12),
          child: SvgPicture.asset(
              index == 0 ? "assets/unfilledhome.svg" : "assets/filledhome.svg"),
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top: Dim().d12),
          child: SvgPicture.asset(index == 1
              ? "assets/fillednotification.svg"
              : "assets/unfillednotification.svg"),
        ),
        label: 'Notification',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top: Dim().d12),
          child: SvgPicture.asset(index == 2
              ? "assets/filledrequest.svg"
              : "assets/unfilledrequest.svg"),
        ),
        label: 'Request',
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top: Dim().d12),
          child: SvgPicture.asset(index == 3
              ? "assets/filledprofile.svg"
              : "assets/unfilledprofile.svg"),
        ),
        label: 'Profile',
      ),
    ];
  }

  //Dialer
  Future<void> openDialer(String phoneNumber) async {
    Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(Uri.parse(launchUri.toString()));
  }

  //WhatsApp
  Future<void> openWhatsApp(String phoneNumber) async {
    if (Platform.isIOS) {
      await launchUrl(Uri.parse("whatsapp:wa.me/$phoneNumber"));
    } else {
      await launchUrl(Uri.parse("whatsapp:send?phone=$phoneNumber"));
    }
  }

  Future<bool> checkInternet(context, widget) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      internetAlert(context, widget);
      return false;
    }
  }

  internetAlert(context, widget) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.NO_HEADER,
      animType: AnimType.SCALE,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      body: Padding(
        padding: EdgeInsets.all(Dim().d20),
        child: Column(
          children: [
            // SizedBox(child: Lottie.asset('assets/No_Internet.json')),
            Text(
              'Connection Error',
              style: Sty().largeText.copyWith(
                    color: Clr().primaryColor,
                    fontSize: 18.0,
                  ),
            ),
            SizedBox(
              height: Dim().d8,
            ),
            Text(
              'No Internet connection found.',
              style: Sty().smallText,
            ),
            SizedBox(
              height: Dim().d32,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: Sty().primaryButton,
                onPressed: () async {
                  var connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    Navigator.pop(context);
                    STM().replacePage(context, widget);
                  }
                },
                child: Text(
                  "Try Again",
                  style: Sty().largeText.copyWith(
                        color: Clr().white,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    ).show();
  }

  // Future<bool> checkInternet(context, widget) async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     return true;
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     return true;
  //   } else {
  //     internetAlert(context, widget);
  //     return false;
  //   }
  // }

  // internetAlert(context, widget) {
  //   AwesomeDialog(
  //     context: context,
  //     dialogType: DialogType.NO_HEADER,
  //     animType: AnimType.SCALE,
  //     dismissOnTouchOutside: false,
  //     dismissOnBackKeyPress: false,
  //     body: Padding(
  //       padding: EdgeInsets.all(Dim().d20),
  //       child: Column(
  //         children: [
  //           // SizedBox(child: Lottie.asset('assets/no_internet_alert.json')),
  //           Text(
  //             'Connection Error',
  //             style: Sty().largeText.copyWith(
  //                   color: Clr().primaryColor,
  //                   fontSize: 18.0,
  //                 ),
  //           ),
  //           SizedBox(
  //             height: Dim().d8,
  //           ),
  //           Text(
  //             'No Internet connection found.',
  //             style: Sty().smallText,
  //           ),
  //           SizedBox(
  //             height: Dim().d32,
  //           ),
  //           SizedBox(
  //             width: double.infinity,
  //             child: ElevatedButton(
  //               style: Sty().primaryButton,
  //               onPressed: () {
  //                 STM().checkInternet(context, widget).then((value) {
  //                   if (value) {
  //                     Navigator.pop(context);
  //                     STM().replacePage(context, widget);
  //                   }
  //                 });
  //               },
  //               child: Text(
  //                 "Try Again",
  //                 style: Sty().largeText.copyWith(
  //                       color: Clr().white,
  //                     ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ).show();
  // }

  String dateFormat(format, date) {
    return DateFormat(format).format(date).toString();
  }

  Future<dynamic> get(ctx, title, name) async {
    //Dialog
    AwesomeDialog dialog = STM().loadingDialog(ctx, title);
    dialog.show();
    Dio dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ),
    );
    String url = AppUrl.mainUrl + name;
    dynamic result;
    try {
      Response response = await dio.get(url);
      if (kDebugMode) {
        print("Url = $url\nResponse = $response");
      }
      if (response.statusCode == 200) {
        dialog.dismiss();
        result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      debugPrint(e.message);
      e.message.toString().contains('405') ? STM().finishAffinity(ctx, Login()) : STM().errorDialog(ctx, e.message);
    }
    return result;
  }

  Future<dynamic> getWithoutDialog(ctx, name) async {
    Dio dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ),
    );
    String url = AppUrl.mainUrl + name;
    dynamic result;
    try {
      Response response = await dio.get(url);
      if (kDebugMode) {
        print("Url = $url\nResponse = $response");
      }
      if (response.statusCode == 200) {
        result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      debugPrint(e.message);
      e.message.toString().contains('405') ? STM().finishAffinity(ctx, Login()) : STM().errorDialog(ctx, e.message);
    }
    return result;
  }

  Future<dynamic> postWithToken(ctx, title, name, body, token) async {
    //Dialog
    AwesomeDialog dialog = STM().loadingDialog(ctx, title);
    dialog.show();
    Dio dio = Dio(
      BaseOptions(
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          "responseType": "ResponseType.plain",
          "Authorization": "Bearer $token",
        },
      ),
    );
    String url = AppUrl.mainUrl + name;
    if (kDebugMode) {
      print("Url = $url\nBody = ${body.fields}");
    }
    dynamic result;
    try {
      Response response = await dio.post(url, data: body);
      if (kDebugMode) {
        print("Response = $response");
      }
      if (response.statusCode == 200) {
        dialog.dismiss();
        result = response.data;
        // result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      dialog.dismiss();
      e.message.toString().contains('405') ? STM().finishAffinity(ctx, Login()) : STM().errorDialog(ctx, e.message);
    }
    return result;
  }

  Future<dynamic> getcat(ctx, title, name, token) async {
    Dio dio = Dio(
      BaseOptions(
        headers: {
          "Content-Type": "application/json",
          "responseType": "ResponseType.plain",
          "Authorization": "Bearer $token",
        },
      ),
    );
    String url = AppUrl.mainUrl + name;
    if (kDebugMode) {
      // print("Url = $url\nBody = ${body.fields}");
    }
    dynamic result;
    try {
      Response response = await dio.get(url);
      if (kDebugMode) {
        print("Response = $response");
      }
      if (response.statusCode == 200) {
        result = response.data;
      }
    } on DioError catch (e) {
      e.message.toString().contains('405') ? STM().finishAffinity(ctx, Login()) :
      STM().errorDialog(ctx, e.message);
    }
    return result;
  }

  Future<dynamic> postget(ctx, title, name, body, token) async {
    //Dialog
    AwesomeDialog dialog = STM().loadingDialog(ctx, title);
    dialog.show();
    Dio dio = Dio(
      BaseOptions(
        headers: {
          "Content-Type": "application/json",
          "responseType": "ResponseType.plain",
          "Authorization": "Bearer $token",
        },
      ),
    );
    String url = AppUrl.mainUrl + name;
    if (kDebugMode) {
      print("Url = $url\nBody = ${body.fields}");
    }
    dynamic result;
    try {
      Response response = await dio.post(url, data: body);
      if (kDebugMode) {
        print("Response = $response");
      }
      if (response.statusCode == 200) {
        dialog.dismiss();
        result = response.data;
        // result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      debugPrint(e.message);
      dialog.dismiss();
      e.message.toString().contains('405') ? STM().finishAffinity(ctx, Login()) : STM().errorDialog(ctx, e.message);
    }
    return result;
  }

  Future<dynamic> post(ctx, title, name, body) async {
    //Dialog
    AwesomeDialog dialog = STM().loadingDialog(ctx, title);
    dialog.show();
    Dio dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ),
    );
    String url = AppUrl.mainUrl + name;
    if (kDebugMode) {
      print("Url = $url\nBody = ${body.fields}");
    }
    dynamic result;
    try {
      Response response = await dio.post(url, data: body);
      if (kDebugMode) {
        print("Response = $response");
      }
      if (response.statusCode == 200) {
        dialog.dismiss();
        result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      debugPrint(e.message);
      dialog.dismiss();
      e.message.toString().contains('405') ? STM().finishAffinity(ctx, Login()) : STM().errorDialog(ctx, e.message);
    }
    return result;
  }

  Future<dynamic> postWithoutDialog(ctx, name, body) async {
    //Dialog
    Dio dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ),
    );
    String url = AppUrl.mainUrl + name;
    dynamic result;
    try {
      Response response = await dio.post(url, data: body);
      if (kDebugMode) {
        print("Url = $url\nBody = ${body.fields}\nResponse = $response");
      }
      if (response.statusCode == 200) {
        result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      debugPrint(e.message);
      e.message.toString().contains('405')  ? STM().finishAffinity(ctx, Login()) : STM().errorDialog(ctx, e.message);
    }
    return result;
  }

  Widget loadingPlaceHolder() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 0.6,
        color: Clr().primaryColor,
      ),
    );
  }

  Widget imageView(Map<String, dynamic> v) {
    return v['url'].toString().contains('assets')
        ? Image.asset(
            '${v['url']}',
            width: v['width'],
            height: v['height'],
            fit: v['fit'] ?? BoxFit.fill,
          )
        : CachedNetworkImage(
            width: v['width'],
            height: v['height'],
            fit: v['fit'] ?? BoxFit.fill,
            imageUrl: v['url'] ??
                'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
            placeholder: (context, url) => STM().loadingPlaceHolder(),
          );
  }

  CachedNetworkImage networkimg(url) {
    return url == null
        ? CachedNetworkImage(
            imageUrl:
                'https://liftlearning.com/wp-content/uploads/2020/09/default-image.png',
            fit: BoxFit.cover,
            imageBuilder: (context, imageProvider) => Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Clr().lightGrey),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          )
        : CachedNetworkImage(
            imageUrl: '$url',
            fit: BoxFit.cover,
            imageBuilder: (context, imageProvider) => Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                // borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          );
  }

  hexStringToColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  Future<dynamic> getPincode({lat,lng})async{
    List<Placemark> placemarks = await placemarkFromCoordinates(double.parse(lat.toString()), double.parse(lng.toString()));
    return placemarks[0].postalCode ?? placemarks[1].postalCode;
  }


}
