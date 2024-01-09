import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:one_click/home.dart';
import 'package:one_click/viewdocument.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'request_details.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class MyRequest extends StatefulWidget {
  final point;
  const MyRequest({super.key,  this.point});

  @override
  State<MyRequest> createState() => _MyRequestState();
}

class _MyRequestState extends State<MyRequest> {
  late BuildContext ctx;

  bool isHasTrailing = false;
  var sToken;
  List<dynamic> upcomingList = [];
  List<dynamic> ongoingList = [];
  List<dynamic> completeList = [];
  List<dynamic> cancelledList = [];
  List addIndexList = [];
  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sToken = sp.getString('token');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        apiCalls(apiname: 'get_request', value: '', type: 'post');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().finishAffinity(ctx, Home());
        return false;
      },
      child: DefaultTabController(
        length: 4,
        initialIndex: widget.point ?? 0,
        child: Scaffold(
            bottomNavigationBar: bottomBarLayout(ctx, 2),
            backgroundColor: Clr().white,
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
                        padding: EdgeInsets.only(left: 6),
                        height: 60,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Clr().primaryColor, shape: BoxShape.circle),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Clr().white,
                            size: 18,
                          ),
                        )),
                  )),
              toolbarHeight: 60,
              title: Text(
                "My Request",
                style: Sty()
                    .largeText
                    .copyWith(fontSize: 20, color: Clr().textcolor),
              ),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(40.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Clr().lightGrey),
                    ),
                  ),
                  child: TabBar(
                    indicatorColor: Clr().secondary,
                    labelColor: Clr().secondary,
                    labelStyle: Sty().smallText,
                    isScrollable: true,
                    unselectedLabelColor: Clr().textGrey,
                    tabs: const [
                      Tab(text: 'Upcoming'),
                      Tab(text: 'Ongoing'),
                      Tab(text: 'Completed'),
                      Tab(text: 'Cancelled'),
                    ],
                  ),
                ),
              ),
            ),
            body: TabBarView(
              children: [
                listLayout(upcomingList),
                listLayout(ongoingList),
                listLayout(completeList),
                listLayout(cancelledList),
              ],
            )),
      ),
    );
  }

  Widget listLayout(list) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return Padding(
              padding: EdgeInsets.only(top: Dim().d12),
              child: cardLayout(
                context,
                index,
                list,
              ));
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: Dim().d12);
        },
        itemCount: list.length,
        padding: EdgeInsets.symmetric(horizontal: Dim().d12));
  }

  /// Upcoming request Layout
  Widget cardLayout(ctx, index, list) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Clr().borderColor.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 2,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Card(
        elevation: 0.6,
        shape: RoundedRectangleBorder(
          // side: BorderSide(
          //   color: Colors.grey,
          //   width: 0.5,
          // ),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Dim().d12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Clr().textcolor.withOpacity(0.200),
                            shape: BoxShape.circle),
                        child: Padding(
                          padding: EdgeInsets.all(Dim().d8),
                          child: Center(
                            child: SvgPicture.asset('assets/truck.svg'),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: Dim().d100,
                            child: Text('${list[index]['vehicle']['name']}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Sty().mediumText.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Clr().primaryColor)),
                          ),
                          SizedBox(
                            height: Dim().d4,
                          ),
                          Text(
                              '${DateFormat('dd/MM/yyyy | h:mm a').format(DateTime.parse(list[index]['created_at'].toString()))}',
                              // v['month'].toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Sty().mediumText.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  color: Clr().textGrey)),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      if (list[index]['status_text'] != 'Pending' &&
                          list[index]['status_text'] != 'Upcoming')
                        Text('ID: #${list[index]['trip_id']}',
                            style: Sty().mediumText.copyWith(
                                color: Clr().textcolor,
                                fontSize: Dim().d14,
                                fontWeight: FontWeight.w400)),
                      SizedBox(
                        height: Dim().d12,
                      ),
                      SizedBox(
                        height: 40,
                        width: 100,
                        child: ElevatedButton(
                            onPressed: () {
                              STM().redirect2page(
                                  ctx, RequestDetails(data: list[index]));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Clr().primaryColor,
                                elevation: 0.5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                )),
                            child: Text(
                              'Details',
                              style: Sty().mediumText.copyWith(
                                    fontSize: 14,
                                    color: Clr().white,
                                    fontWeight: FontWeight.w400,
                                  ),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),

            /// cancel Widgets
            cancelLayout(list, index),
            if (list[index]['status_text'] == 'Upcoming' ||
                list[index]['status_text'] == 'Ongoing' ||
                list[index]['status_text'] == 'Completed')
              addIndexList.contains(index)
                  ? Column(
                      children: [
                        Divider(),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/map_pin.svg'),
                                  SizedBox(
                                    width: Dim().d12,
                                  ),
                                  Text(
                                    '${list[index]['total_distance']}km',
                                    // p['date'],
                                    style: Sty()
                                        .smallText
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: Dim().d40,
                              ),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/wallet.svg'),
                                  SizedBox(
                                    width: Dim().d12,
                                  ),
                                  Text(
                                    list[index]['type'] == 'Cash' ? '₹${list[index]['total_charge']}(Est.)' : 'Fixed',
                                    // p['date'],
                                    style: Sty()
                                        .smallText
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Date & Time',
                                  // p['date'],
                                  style: Sty().smallText.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Clr().textGrey),
                                ),
                                Text(
                                  '${list[index]['date']} | ${list[index]['time']}',
                                  // p['date'],
                                  style: Sty().smallText.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Clr().primaryColor),
                                ),
                              ],
                            )),
                        if (list[index]['status_text'] == 'Completed')
                          SizedBox(
                            height: Dim().d12,
                          ),
                        if (list[index]['status_text'] == 'Completed')
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Status',
                                    // p['date'],
                                    style: Sty().smallText.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Clr().textGrey),
                                  ),
                                  Text(
                                    'Paid',
                                    // p['date'],
                                    style: Sty().smallText.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Clr().primaryColor),
                                  ),
                                ],
                              )),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        Divider(),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Driver Details :',
                              // p['date'],
                              style: Sty().mediumText.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Clr().textGrey),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Image.asset("assets/driver_details.png"),
                                    SizedBox(
                                      width: Dim().d12,
                                    ),
                                    if (list[index]['status_text'] ==
                                        'Completed')
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Driver Name: ${list[index]['driver']['name']}',
                                              // v['month'].toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: Sty().mediumText.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: Clr().primaryColor)),
                                          SizedBox(
                                            height: Dim().d4,
                                          ),
                                          Text(
                                              'Vehicle Number: ${list[index]['driver']['vehicle_detail']['vehicle_number']}',
                                              // v['month'].toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: Sty().mediumText.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: Clr().textGrey)),
                                        ],
                                      ),
                                    if (list[index]['status_text'] !=
                                        'Completed')
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${list[index]['driver']['name']}',
                                              // v['month'].toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: Sty().mediumText.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: Clr().primaryColor)),
                                          SizedBox(
                                            height: Dim().d4,
                                          ),
                                          Text(
                                              '+91 ${list[index]['driver']['mobile']}',
                                              // v['month'].toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: Sty().mediumText.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: Clr().textGrey)),
                                        ],
                                      ),
                                  ]),
                              if (list[index]['status_text'] != 'Completed')
                                SizedBox(
                                  height: 35,
                                  width: 90,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        STM().openDialer(
                                            list[index]['driver']['mobile']);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Clr().green,
                                          elevation: 0.5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          )),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.call,
                                            color: Clr().white,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: Dim().d8,
                                          ),
                                          Text(
                                            'Call',
                                            style: Sty().mediumText.copyWith(
                                                  fontSize: 14,
                                                  color: Clr().white,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                        ],
                                      )),
                                ),
                            ],
                          ),
                        ),
                        if (list[index]['status_text'] == 'Completed')
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: Dim().d40,vertical: Dim().d12),
                            child: ElevatedButton(
                                onPressed: () {
                                  STM().redirect2page(ctx, viewdocument(img: list[index]['document']));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Clr().primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(Dim().d20)))),
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(vertical: Dim().d12),
                                  child: Center(
                                    child: Text("View Document",
                                        style: Sty()
                                            .smallText
                                            .copyWith(color: Clr().white)),
                                  ),
                                )),
                          ),
                        SizedBox(
                          height: Dim().d20,
                        ),
                        InkWell(
                            onTap: () {
                              setState(() {
                                addIndexList.remove(index);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset("assets/up_arrow.svg"),
                            )),
                      ],
                    )
                  : InkWell(
                      onTap: () {
                        setState(() {
                          addIndexList.add(index);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset("assets/down_arrow.svg"),
                      )),
            SizedBox(
              height: Dim().d12,
            ),
          ],
        ),
      ),
    );
  }

  cancelLayout(list, index) {
    return list[index]['status_text'] == 'Cancelled'
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: Dim().d12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Dim().d8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Date & Time',
                          style: Sty().mediumText.copyWith(
                              color: Clr().textcolor.withOpacity(0.500),
                              fontWeight: FontWeight.w400,
                              fontSize: Dim().d14)),
                      Text('${list[index]['date']} | ${list[index]['time']}',
                          style: Sty().mediumText.copyWith(
                              color: Clr().textcolor,
                              fontWeight: FontWeight.w400,
                              fontSize: Dim().d14)),
                    ],
                  ),
                ),
                Divider(
                  color: Clr().e2,
                  thickness: 1.0,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Cancellation Reason:',
                        style: Sty().mediumText.copyWith(
                            color: Clr().clr29,
                            fontSize: Dim().d16,
                            fontWeight: FontWeight.w500)),
                    Text(' ${list[index]['canellation_reason']}',
                        style: Sty().mediumText.copyWith(
                            color: Clr().textcolor,
                            fontSize: Dim().d14,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
                SizedBox(
                  height: Dim().d12,
                ),
              ],
            ),
          )
        : Container();
  }

  /// my requestId
  apiCalls({apiname, type, value}) async {
    var data = FormData.fromMap({});
    switch (apiname) {
      case 'get_request':
        data = FormData.fromMap({
          'uuid': OneSignal.User.pushSubscription.id,
        });
        break;
    }
    FormData body = data;
    var result = type == 'post'
        ? await STM().postWithToken(ctx, Str().loading, apiname, body, sToken)
        : await STM().getcat(ctx, Str().loading, apiname, sToken);
    switch (apiname) {
      case 'get_request':
        if (result['success']) {
          setState(() {
            upcomingList = result['data']['upcoming'];
            ongoingList = result['data']['ongoing'];
            completeList = result['data']['completed'];
            cancelledList = result['data']['cancelled'];
          });
        } else {
          setState(() {
            STM().errorDialog(ctx, result['message']);
          });
        }
        break;
    }
  }
}
