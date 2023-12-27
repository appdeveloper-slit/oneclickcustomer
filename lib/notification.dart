import 'package:flutter/material.dart';
import 'package:one_click/home.dart';
import 'package:one_click/values/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'toolbar/toolbar.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late BuildContext ctx;

  List<dynamic> notificationList = [];

  String? sToken;

  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sToken = sp.getString('token') ?? '';
    debugPrint(sToken);
    STM().checkInternet(ctx, widget).then((value) {
      if (value) {
        // getNotificatins();
      }
    });
  }

  @override
  void initState() {
    getSessionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return WillPopScope(onWillPop: ()async{
      STM().finishAffinity(ctx, Home());
      return false;
    },
      child: Scaffold(
        backgroundColor: Clr().white,
        bottomNavigationBar: bottomBarLayout(ctx, 1),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Clr().white,
          leadingWidth: 52,
          leading: InkWell(
              onTap: () {
                STM().finishAffinity(ctx, Home());
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
          title: Text(
            "Notifications",
            style: Sty().largeText.copyWith(fontSize: 20, color: Clr().textcolor),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 0,
                itemBuilder: (context, index) {
                  // var v = notificationList[index];
                  return Card(
                    elevation: 0.0,
                    margin: EdgeInsets.symmetric(
                        horizontal: Dim().d0, vertical: Dim().d8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dim().d12),
                        side: BorderSide(color: Color(0xffECECEC))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 12,
                        left: 20,
                        right: 20,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // notificationList.isEmpty
                            //     ? Container()
                            //     :
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                          // v['title'].toString(),
                                          'Lorem Ipsum is simply dummy te ',
                                          style: Sty()
                                              .mediumText
                                              .copyWith(fontWeight: FontWeight.w500, color: Clr().primaryColor),
                                        ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                            // v['title'].toString(),
                                            '05/10/2023',
                                            style: Sty()
                                                .microText
                                                .copyWith(fontWeight: FontWeight.w500),
                                          ),
                                    Text(
                                            // v['title'].toString(),
                                            '03:30pm',
                                            style: Sty()
                                                .microText
                                                .copyWith(fontWeight: FontWeight.w500),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Dim().d12,
                            ),
                            Divider(),
                            SizedBox(
                              height: Dim().d12,
                            ),
                            // notificationList.isEmpty
                            //     ? Container()
                            //     :
                            Text(
                                    // v['description'].toString(),
                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. At amet, id lorem placerat neque morbi. Gravida integer lectus tristique ',
                                    style:Sty().smallText.copyWith(
                                      color: Clr().textcolor,
                                    )
                                  ),
                            SizedBox(
                              height: 16,
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: notificationList.isEmpty
                                    ? Container()
                                    : Text(
                                    // v['notify_at'].toString(),
                                        'Today, 11:44 am',
                                        style: Sty().smallText.copyWith(
                                            color: Color(0xff979797),
                                            fontSize: 12)))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  ///Get Profile API
// void getNotificatins() async {
//   var result =
//   await STM().getcat(ctx, Str().loading, 'get_notifications', sToken);
//   var success = result['success'];
//   var message = result['message'];
//   if (success) {
//     setState(() {
//       notificationList = result['data']['notifications'];
//       print('updateprofile ${notificationList}');
//     });
//   } else {
//     STM().errorDialog(ctx, message);
//   }
// }
}
