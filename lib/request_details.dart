import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:one_click/home.dart';
import 'package:one_click/my_request.dart';
import 'package:one_click/values/colors.dart';
import 'package:one_click/values/dimens.dart';
import 'package:one_click/viewdocument.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines/timelines.dart';

import 'add_address.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class RequestDetails extends StatefulWidget {
  final data;

  const RequestDetails({super.key, this.data});

  @override
  State<RequestDetails> createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  late BuildContext ctx;

  int selectedIndex = -1;

  List cancelList = [];

  List addressList = [];
  List reciverAddressList = [];

  var data, sToken;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sToken = sp.getString('token');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        apiIntegrate(type: 'get', value: '', apiname: 'cancel_reasons');
      }
    });
    var reciveraddress = await getAddress(widget.data['latitude'].toString(),
        widget.data['longitude'].toString());
    setState(() {
      data = widget.data;
      addressList.add({
        'type': 'From',
        'address': reciveraddress,
        'pincode': widget.data['pincode'],
      });
    });
    for (int a = 0; a < widget.data['receiver_address'].length; a++) {
      reciverAddressList.add({
        'type': 'To',
        'address': widget.data['receiver_address'][a]['city'],
        'pincode': widget.data['receiver_address'][a]['pincode']
      });
    }
    for (int a = 0; a < reciverAddressList.length; a++) {
      setState(() {
        addressList.add({
          'type': reciverAddressList[a]['type'],
          'address': reciverAddressList[a]['address'],
          'pincode': reciverAddressList[a]['pincode'],
        });
      });
    }
    print(addressList);
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
    return Scaffold(
      backgroundColor: Clr().white,
      bottomNavigationBar: bottomBarLayout(ctx, 2),
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
        title: Text(
          "Request Details",
          style: Sty().largeText.copyWith(fontSize: 20, color: Clr().textcolor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: data == null
            ? Center(
                child: CircularProgressIndicator(color: Clr().primaryColor),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Dim().d8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              SvgPicture.asset("assets/map_pin.svg"),
                              SizedBox(
                                width: Dim().d8,
                              ),
                              Text(
                                "Address",
                                style: Sty().mediumText.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Clr().primaryColor,
                                      fontSize: Dim().d16,
                                    ),
                              )
                            ],
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                "Trip ID ",
                                style: Sty().mediumText.copyWith(
                                      color: Clr().secondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              Text(
                                ": #${data['trip_id']}",
                                style: Sty().mediumText.copyWith(
                                      color: Clr().primaryColor,
                                      fontSize: Dim().d14,
                                      fontWeight: FontWeight.w500,
                                    ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Dim().d20,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Clr().white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Clr().black.withOpacity(0.100),
                              spreadRadius: 3,
                              blurRadius: 5, // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: FixedTimeline.tileBuilder(
                            theme: TimelineThemeData(
                              indicatorTheme: IndicatorThemeData(
                                size: Dim().d12,
                                position: 0,
                              ),
                              color: Clr().primaryColor,
                              connectorTheme: ConnectorThemeData(
                                color: Clr().primaryColor.withOpacity(0.4),
                                thickness: 2.0,
                                indent: 1.0,
                              ),
                            ),
                            mainAxisSize: MainAxisSize.min,
                            verticalDirection: VerticalDirection.down,
                            builder: TimelineTileBuilder.connectedFromStyle(
                                itemCount: addressList.length,
                                connectionDirection: ConnectionDirection.before,
                                contentsAlign: ContentsAlign.reverse,
                                connectorStyleBuilder: (context, index) =>
                                    ConnectorStyle.dashedLine,
                                indicatorStyleBuilder: (context, index) {
                                  return index == 0
                                      ? IndicatorStyle.outlined
                                      : IndicatorStyle.dot;
                                },
                                indicatorPositionBuilder: (context, index) =>
                                    0.0,
                                nodePositionBuilder: (context, index) => 0.0,
                                lastConnectorStyle: ConnectorStyle.transparent,
                                firstConnectorStyle: ConnectorStyle.transparent,
                                oppositeContentsBuilder: (context, index) =>
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Dim().d12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('${addressList[index]['type']}',
                                              style: Sty().mediumText.copyWith(
                                                  color: Clr().textcolor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: Dim().d16)),
                                          SizedBox(
                                            height: Dim().d4,
                                          ),
                                          Text(
                                              '${addressList[index]['address']} ${addressList[index]['pincode']}',
                                              style: Sty().mediumText.copyWith(
                                                  color: Clr()
                                                      .textcolor
                                                      .withOpacity(0.80),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: Dim().d16)),
                                          index == addressList.length - 1
                                              ? Container()
                                              : SizedBox(
                                                  height: Dim().d12,
                                                ),
                                        ],
                                      ),
                                    )),
                          ),
                        )),
                    SizedBox(
                      height: Dim().d20,
                    ),
                    if (data['driver_id'] != null &&
                        data['status_text'] != "Completed")
                      Text(
                        "Driver Details",
                        style: Sty().mediumText.copyWith(
                              color: Clr().primaryColor,
                              fontSize: 18,
                            ),
                      ),
                    if (data['driver_id'] != null &&
                        data['status_text'] != "Completed")
                      SizedBox(
                        height: Dim().d16,
                      ),
                    if (data['driver_id'] != null &&
                        data['status_text'] != "Completed")
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Clr().borderColor.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 2,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                  color: Clr().shimmerColor, width: 0.2)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Image.asset("assets/driver_details.png"),
                                      SizedBox(
                                        width: Dim().d8,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('${data['driver']['name']}',
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
                                              'Vehicle No : ${data['driver']['vehicle_detail']['vehicle_number']}',
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
                                SizedBox(
                                  height: 35,
                                  width: 90,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        // if (formKey.currentState!.validate()) {
                                        //   STM().checkInternet(context, widget).then((value) {
                                        //     if (value) {
                                        //       // sendOtp();
                                        // STM().redirect2page(ctx, RequestDetails());
                                        //     }
                                        //   });
                                        // };
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
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (data['driver_id'] != null &&
                        data['status_text'] != "Completed")
                      SizedBox(
                        height: Dim().d16,
                      ),
                    if (data['driver_id'] != null &&
                        data['status_text'] != "Completed")
                      Text(
                        "OTP",
                        style: Sty().mediumText.copyWith(
                              color: Clr().primaryColor,
                              fontSize: 18,
                            ),
                      ),
                    if (data['driver_id'] != null &&
                        data['status_text'] != "Completed")
                      SizedBox(
                        height: Dim().d16,
                      ),
                    if (data['driver_id'] != null &&
                        data['status_text'] != "Completed")
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Clr().borderColor.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 2,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                  color: Clr().shimmerColor, width: 0.2)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28.0,
                              vertical: 20.0,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  'OTP',
                                  style: Sty().mediumText.copyWith(
                                      fontFamily: "MulshiSemi",
                                      color: Clr().textcolor,
                                      fontWeight: FontWeight.w400),
                                )),
                                Text(':'),
                                Expanded(
                                    child: Wrap(
                                  children: [
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${data['otp'].toString()}',
                                          style: Sty().mediumText.copyWith(
                                              fontFamily: "MulshiSemi",
                                              color: Clr().textcolor,
                                              fontWeight: FontWeight.w400),
                                        )),
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: Dim().d16,
                    ),
                    Text(
                      "Order Details",
                      style: Sty().mediumText.copyWith(
                            color: Clr().textcolor,
                            fontSize: 18,
                          ),
                    ),
                    SizedBox(
                      height: Dim().d16,
                    ),
                    Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: Clr().shimmerColor, width: 0.2)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  'Date',
                                  style: Sty().smallText.copyWith(
                                      // fontFamily: "MulshiSemi",
                                      color: Clr().textcolor,
                                      fontWeight: FontWeight.w400),
                                )),
                                Text(':'),
                                Expanded(
                                    child: Wrap(
                                  children: [
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${DateFormat('dd/MM/yyyy').format(DateTime.parse(data['created_at'].toString()))}',
                                          style: Sty().smallText.copyWith(
                                              // fontFamily: "MulshiSemi",
                                              color: Clr().textcolor,
                                              fontWeight: FontWeight.w400),
                                        )),
                                  ],
                                )),
                              ],
                            ),
                            SizedBox(
                              height: Dim().d12,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  'Time',
                                  style: Sty().smallText.copyWith(
                                      // fontFamily: "MulshiSemi",
                                      color: Clr().textcolor,
                                      fontWeight: FontWeight.w400),
                                )),
                                Text(':'),
                                Expanded(
                                    child: Wrap(
                                  children: [
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${DateFormat('h:mm a').format(DateTime.parse(data['created_at'].toString()))}',
                                          style: Sty().smallText.copyWith(
                                              // fontFamily: "MulshiSemi",
                                              color: Clr().textcolor,
                                              fontWeight: FontWeight.w400),
                                        )),
                                  ],
                                )),
                              ],
                            ),
                            SizedBox(
                              height: Dim().d12,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  'Status',
                                  style: Sty().mediumText.copyWith(
                                      // fontFamily: "MulshiSemi",
                                      color: Clr().primaryColor,
                                      fontWeight: FontWeight.w500),
                                )),
                                Text(':'),
                                Expanded(
                                    child: Wrap(
                                  children: [
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${data['status_text']}',
                                          style: Sty().mediumText.copyWith(
                                              color: data['status'] == "5"
                                                  ? Clr().red
                                                  : data['status'] == "4"
                                                      ? Clr().green
                                                      : Clr().ea,
                                              fontWeight: FontWeight.w500),
                                        )),
                                  ],
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dim().d16,
                    ),
                    if (data['status_text'] != "Cancelled" &&
                        data['status_text'] != 'Completed')
                      Text(
                        "Pickup Details",
                        style: Sty().mediumText.copyWith(
                              color: Clr().textcolor,
                              fontSize: 18,
                            ),
                      ),
                    if (data['status_text'] != "Cancelled" &&
                        data['status_text'] != 'Completed')
                      SizedBox(
                        height: Dim().d16,
                      ),
                    if (data['status_text'] != "Cancelled" &&
                        data['status_text'] != 'Completed')
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                                color: Clr().shimmerColor, width: 0.2)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    'Date',
                                    style: Sty().smallText.copyWith(
                                        // fontFamily: "MulshiSemi",
                                        color: Clr().textcolor,
                                        fontWeight: FontWeight.w400),
                                  )),
                                  Text(':'),
                                  Expanded(
                                      child: Wrap(
                                    children: [
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '${data['date']}',
                                            style: Sty().smallText.copyWith(
                                                // fontFamily: "MulshiSemi",
                                                color: Clr().textcolor,
                                                fontWeight: FontWeight.w400),
                                          )),
                                    ],
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: Dim().d12,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    'Time',
                                    style: Sty().smallText.copyWith(
                                        // fontFamily: "MulshiSemi",
                                        color: Clr().textcolor,
                                        fontWeight: FontWeight.w400),
                                  )),
                                  Text(':'),
                                  Expanded(
                                      child: Wrap(
                                    children: [
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '${data['time']}',
                                            style: Sty().smallText.copyWith(
                                                // fontFamily: "MulshiSemi",
                                                color: Clr().textcolor,
                                                fontWeight: FontWeight.w400),
                                          )),
                                    ],
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: Dim().d16,
                    ),
                    if (data['status_text'] != "Cancelled" &&
                        data['status_text'] != 'Completed')
                      Text(
                        "Pickup Contact Details",
                        style: Sty().mediumText.copyWith(
                              color: Clr().textcolor,
                              fontSize: 18,
                            ),
                      ),
                    if (data['status_text'] != "Cancelled" &&
                        data['status_text'] != 'Completed')
                      SizedBox(
                        height: Dim().d16,
                      ),
                    if (data['status_text'] != "Cancelled" &&
                        data['status_text'] != 'Completed')
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                                color: Clr().shimmerColor, width: 0.2)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    'Name',
                                    style: Sty().smallText.copyWith(
                                        // fontFamily: "MulshiSemi",
                                        color: Clr().textcolor,
                                        fontWeight: FontWeight.w400),
                                  )),
                                  Text(':'),
                                  Expanded(
                                      child: Wrap(
                                    children: [
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '${data['pickup_name']}',
                                            style: Sty().smallText.copyWith(
                                                // fontFamily: "MulshiSemi",
                                                color: Clr().textcolor,
                                                fontWeight: FontWeight.w400),
                                          )),
                                    ],
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: Dim().d12,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    'Mobile No',
                                    style: Sty().smallText.copyWith(
                                        // fontFamily: "MulshiSemi",
                                        color: Clr().textcolor,
                                        fontWeight: FontWeight.w400),
                                  )),
                                  Text(':'),
                                  Expanded(
                                      child: Wrap(
                                    children: [
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '+91 ${data['pickup_mobile']}',
                                            style: Sty().smallText.copyWith(
                                                // fontFamily: "MulshiSemi",
                                                color: Clr().textcolor,
                                                fontWeight: FontWeight.w400),
                                          )),
                                    ],
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (data['status_text'] != "Cancelled" &&
                        data['status_text'] != 'Completed')
                      SizedBox(
                        height: Dim().d16,
                      ),
                    if (data['status_text'] != "Cancelled" &&
                        data['status_text'] != 'Completed')
                      Text(
                        "Receiver Contact Details",
                        style: Sty().mediumText.copyWith(
                              color: Clr().textcolor,
                              fontSize: 18,
                            ),
                      ),
                    if (data['status_text'] != "Cancelled" &&
                        data['status_text'] != 'Completed')
                      SizedBox(
                        height: Dim().d16,
                      ),
                    if (data['status_text'] != "Cancelled" &&
                        data['status_text'] != 'Completed')
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                                color: Clr().shimmerColor, width: 0.2)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    'Name',
                                    style: Sty().smallText.copyWith(
                                        // fontFamily: "MulshiSemi",
                                        color: Clr().textcolor,
                                        fontWeight: FontWeight.w400),
                                  )),
                                  Text(':'),
                                  Expanded(
                                      child: Wrap(
                                    children: [
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '${data['receiver_name']}',
                                            style: Sty().smallText.copyWith(
                                                // fontFamily: "MulshiSemi",
                                                color: Clr().textcolor,
                                                fontWeight: FontWeight.w400),
                                          )),
                                    ],
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: Dim().d12,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    'Mobile No',
                                    style: Sty().smallText.copyWith(
                                        // fontFamily: "MulshiSemi",
                                        color: Clr().textcolor,
                                        fontWeight: FontWeight.w400),
                                  )),
                                  Text(':'),
                                  Expanded(
                                      child: Wrap(
                                    children: [
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            '+91 ${data['receiver_mobile']}',
                                            style: Sty().smallText.copyWith(
                                                // fontFamily: "MulshiSemi",
                                                color: Clr().textcolor,
                                                fontWeight: FontWeight.w400),
                                          )),
                                    ],
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: Dim().d16,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/vehicle_det.svg"),
                        SizedBox(
                          width: Dim().d8,
                        ),
                        Text(
                          "Vehicle Details",
                          style: Sty().mediumText.copyWith(
                                color: Clr().primaryColor,
                                fontSize: 18,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dim().d16,
                    ),
                    Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: Clr().shimmerColor, width: 0.2)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  'Name',
                                  style: Sty().smallText.copyWith(
                                      // fontFamily: "MulshiSemi",
                                      color: Clr().textcolor,
                                      fontWeight: FontWeight.w400),
                                )),
                                Text(':'),
                                Expanded(
                                    child: Wrap(
                                  children: [
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${data['vehicle']['name']}',
                                          style: Sty().smallText.copyWith(
                                              // fontFamily: "MulshiSemi",
                                              color: Clr().textcolor,
                                              fontWeight: FontWeight.w400),
                                        )),
                                  ],
                                )),
                              ],
                            ),
                            SizedBox(
                              height: Dim().d12,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  'Capacity',
                                  style: Sty().smallText.copyWith(
                                      // fontFamily: "MulshiSemi",
                                      color: Clr().textcolor,
                                      fontWeight: FontWeight.w400),
                                )),
                                Text(':'),
                                Expanded(
                                    child: Wrap(
                                  children: [
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${data['vehicle']['capacity']}',
                                          style: Sty().smallText.copyWith(
                                              // fontFamily: "MulshiSemi",
                                              color: Clr().textcolor,
                                              fontWeight: FontWeight.w400),
                                        )),
                                  ],
                                )),
                              ],
                            ),
                            SizedBox(
                              height: Dim().d12,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  'Size',
                                  style: Sty().smallText.copyWith(
                                      // fontFamily: "MulshiSemi",
                                      color: Clr().textcolor,
                                      fontWeight: FontWeight.w400),
                                )),
                                Text(':'),
                                Expanded(
                                    child: Wrap(
                                  children: [
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${data['vehicle']['size']}',
                                          style: Sty().smallText.copyWith(
                                              // fontFamily: "MulshiSemi",
                                              color: Clr().textcolor,
                                              fontWeight: FontWeight.w400),
                                        )),
                                  ],
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dim().d16,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/delete.svg"),
                        SizedBox(
                          width: Dim().d8,
                        ),
                        Text(
                          "Goods type",
                          style: Sty().mediumText.copyWith(
                                color: Clr().primaryColor,
                                fontSize: 18,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dim().d16,
                    ),
                    Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(
                              color: Clr().primaryColor, width: 0.2)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 20.0,
                        ),
                        child: Text(
                            '${data['goods_type'].toString().replaceAll('[', '').replaceAll(']', '').replaceAll('"', '').replaceAll('"', '')}',
                            maxLines: null,
                            style: Sty().smallText.copyWith(
                                color: Clr().primaryColor,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                    SizedBox(
                      height: Dim().d16,
                    ),
                    if (data['status_text'] == "Cancelled")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cancellation By :',
                              style: Sty().mediumText.copyWith(
                                  color: Clr().clr29,
                                  fontSize: Dim().d16,
                                  fontWeight: FontWeight.w500)),
                          Text('${data['cancelled_by']}',
                              style: Sty().mediumText.copyWith(
                                  color: Clr().textcolor,
                                  fontSize: Dim().d16,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(
                            height: Dim().d12,
                          ),
                          Text('Cancellation Reason :',
                              style: Sty().mediumText.copyWith(
                                  color: Clr().clr29,
                                  fontSize: Dim().d16,
                                  fontWeight: FontWeight.w500)),
                          Text('${data['canellation_reason']}',
                              style: Sty().mediumText.copyWith(
                                  color: Clr().textcolor,
                                  fontSize: Dim().d16,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    SizedBox(
                      height: Dim().d16,
                    ),
                    if (data['status_text'] != "Cancelled")
                      Text(
                        "Bill Details",
                        style: Sty().mediumText.copyWith(
                              color: Clr().primaryColor,
                              fontSize: 18,
                            ),
                      ),
                    if (data['status_text'] != "Cancelled")
                      SizedBox(
                        height: Dim().d16,
                      ),
                    if (data['status_text'] != "Cancelled")
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                                color: Clr().shimmerColor, width: 0.2)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          child: Column(
                            children: [
                              if (data['status_text'] == "Completed" && data['type'] == 'Cash')
                                Padding(
                                  padding: EdgeInsets.only(bottom: Dim().d12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        'Ride Charge (${data['total_distance']}Km)',
                                        style: Sty().smallText.copyWith(
                                            // fontFamily: "MulshiSemi",
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w400),
                                      )),
                                      Text(':'),
                                      Expanded(
                                          child: Wrap(
                                        children: [
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                '₹${data['ride_charge']}',
                                                style: Sty().smallText.copyWith(
                                                    // fontFamily: "MulshiSemi",
                                                    color: Clr().textcolor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              if (data['status_text'] == "Completed"&& data['type'] == 'Cash')
                                Padding(
                                  padding: EdgeInsets.only(bottom: Dim().d12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        'Loading Charge',
                                        style: Sty().smallText.copyWith(
                                            // fontFamily: "MulshiSemi",
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w400),
                                      )),
                                      Text(':'),
                                      Expanded(
                                          child: Wrap(
                                        children: [
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                '₹${data['loading_charge']}',
                                                style: Sty().smallText.copyWith(
                                                    // fontFamily: "MulshiSemi",
                                                    color: Clr().textcolor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              if (data['status_text'] == "Completed"&& data['type'] == 'Cash')
                                Padding(
                                  padding: EdgeInsets.only(bottom: Dim().d12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        'Unloading Charge',
                                        style: Sty().smallText.copyWith(
                                            // fontFamily: "MulshiSemi",
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w400),
                                      )),
                                      Text(':'),
                                      Expanded(
                                          child: Wrap(
                                        children: [
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                '₹${data['unloading_charge']}',
                                                style: Sty().smallText.copyWith(
                                                    // fontFamily: "MulshiSemi",
                                                    color: Clr().textcolor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              if (data['status_text'] == "Completed"&& data['type'] == 'Cash')
                                Padding(
                                  padding: EdgeInsets.only(bottom: Dim().d12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        'Your Km',
                                        style: Sty().smallText.copyWith(
                                            // fontFamily: "MulshiSemi",
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w400),
                                      )),
                                      Text(':'),
                                      Expanded(
                                          child: Wrap(
                                        children: [
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                '${data['total_distance']}km',
                                                style: Sty().smallText.copyWith(
                                                    // fontFamily: "MulshiSemi",
                                                    color: Clr().textcolor,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    'Total Amount',
                                    style: Sty().smallText.copyWith(
                                        // fontFamily: "MulshiSemi",
                                        color: Clr().textcolor,
                                        fontWeight: FontWeight.w400),
                                  )),
                                  Text(':'),
                                  Expanded(
                                      child: Wrap(
                                    children: [
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            data['type'] == 'Cash' ? '₹${data['total_charge']}(Est.)' : 'Fixed',
                                            style: Sty().smallText.copyWith(
                                                // fontFamily: "MulshiSemi",
                                                color: Clr().textcolor,
                                                fontWeight: FontWeight.w400),
                                          )),
                                    ],
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (data['status_text'] != "Cancelled")
                      SizedBox(
                        height: Dim().d20,
                      ),
                    if (data['status_text'] != "Cancelled")
                      Align(
                        alignment: Alignment.center,
                        child: Card(
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          color: Color(0xfff6e6e5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(
                                  color: Clr().primaryColor, width: 0.2)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 4.0,
                            ),
                            child: Text('Kindly pay in cash to the driver',
                                style: Sty().smallText.copyWith(
                                    color: Clr().secondary,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: Dim().d32,
                    ),
                    if (data['status_text'] != "Cancelled" &&
                        data['status_text'] != 'Completed')
                      Center(
                        child: SizedBox(
                          height: 50,
                          width: 285,
                          child: ElevatedButton(
                              onPressed: () {
                                _cancelDialog(ctx);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Clr().primaryColor,
                                  elevation: 0.5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  )),
                              child: Text(
                                'Cancel',
                                style: Sty().mediumText.copyWith(
                                      fontSize: 16,
                                      color: Clr().white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              )),
                        ),
                      ),
                    if (data['status_text'] == 'Completed')
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dim().d40, vertical: Dim().d12),
                        child: ElevatedButton(
                            onPressed: () {
                              STM().redirect2page(
                                  ctx,
                                  viewdocument(
                                    img: data['document'],
                                  ));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Clr().primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dim().d20)))),
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: Dim().d12),
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
                  ],
                ),
              ),
      ),
    );
  }

  _cancelDialog(ctx) {
    AwesomeDialog(
      isDense: true,
      context: ctx,
      dialogType: DialogType.NO_HEADER,
      animType: AnimType.BOTTOMSLIDE,
      alignment: Alignment.centerLeft,
      body: StatefulBuilder(builder: (context, setState) {
        return Container(
          padding: EdgeInsets.all(Dim().d12),
          child: Column(
            children: [
              Text(
                'Cancel Ride',
                style: Sty().mediumText.copyWith(
                      color: Clr().textcolor,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
              ),
              SizedBox(
                height: Dim().d12,
              ),
              Divider(),
              ListView.separated(
                shrinkWrap: true,
                itemCount: cancelList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndex == index;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          isSelected
                              // work.contains(workTypeList[index]) || (selectAll && index > 0)
                              // ?Icon(Icons.circle):Icon(Icons.circle_outlined),
                              ? SvgPicture.asset(
                                  'assets/tick.svg',
                                  width: 23,
                                  color: Clr().secondary,
                                )
                              : Icon(Icons.circle_outlined,
                                  size: 24,
                                  color: Clr().shimmerColor,
                                  weight: 0.5),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            cancelList[index]['reason'].toString(),
                            style: TextStyle(
                              color: isSelected
                                  ? Clr().secondary
                                  : Clr().textcolor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: Dim().d12,
                  );
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
                        apiIntegrate(
                            apiname: 'cancel_request',
                            type: 'post',
                            value: [
                              data['id'],
                              cancelList[selectedIndex]['reason']
                            ]);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Clr().primaryColor,
                          elevation: 0.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          )),
                      child: Text(
                        'Submit',
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
            ],
          ),
        );
      }),
    ).show();
  }

  getAddress(lat, lng) async {
    List<Placemark> list =
        await placemarkFromCoordinates(double.parse(lat), double.parse(lng));
    var address =
        '${list[1].thoroughfare} ${list[1].subLocality} ${list[1].locality} ${list[1].street} ${list[1].postalCode} ${list[1].country}';
    return address;
  }

  /// api intgertaion
  apiIntegrate({apiname, type, value}) async {
    var data = FormData.fromMap({});
    switch (apiname) {
      case 'cancel_request':
        data = FormData.fromMap({
          'request_id': value[0],
          'reason': value[1],
        });
        break;
    }
    FormData body = data;
    var result = type == 'post'
        ? await STM().postWithToken(ctx, Str().loading, apiname, body, sToken)
        : await STM().getcat(ctx, Str().loading, apiname, sToken);
    switch (apiname) {
      case 'cancel_reasons':
        if (result['success']) {
          setState(() {
            cancelList = result['data'];
          });
        } else {
          setState(() {
            STM().errorDialog(ctx, result['message']);
          });
        }
        break;
      case 'cancel_request':
        if (result['success']) {
          STM().successDialogWithReplace(
              ctx, result['message'], MyRequest(point: 3));
        } else {
          setState(() {
            STM().errorDialog(ctx, result['message']);
          });
        }
        break;
    }
  }
}
