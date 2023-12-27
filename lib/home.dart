import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:one_click/login.dart';
import 'package:one_click/values/colors.dart';
import 'package:one_click/values/dimens.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines/timelines.dart';
import 'package:upgrader/upgrader.dart';
import 'add_address.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'map.dart';
import 'my_profile.dart';
import 'my_request.dart';
import 'notification.dart';
import 'select_vehicle.dart';
import 'sidedrawer.dart';
import 'values/strings.dart';
import 'values/styles.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  late BuildContext ctx;
  List addressList = [];
  List<String> timeList = [];
  static StreamController<dynamic> addresscontroller =
      StreamController<dynamic>.broadcast();
  static StreamController<dynamic> pickAddCtrl =
      StreamController<dynamic>.broadcast();
  static StreamController<dynamic> pickContrl =
      StreamController<dynamic>.broadcast();
  static StreamController<dynamic> recContrl =
      StreamController<dynamic>.broadcast();
  String? sValue;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  var goodsValue;

  List<dynamic> goodsList = [];
  TimeOfDay selectedTimes = TimeOfDay.now();
  var selectedTime;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> pickformKey = GlobalKey<FormState>();
  GlobalKey<FormState> recformKey = GlobalKey<FormState>();
  TextEditingController dobCtrl = TextEditingController();
  TextEditingController timeCtrl = TextEditingController();
  TextEditingController pickPinCtrl = TextEditingController();
  List<TextEditingController> pinCtrol = [];
  List address = [];
  List<Placemark> list = [];
  double? curtLng, curtLat;
  var addressVal,
      sToken,
      name,
      goodsTypVal,
      PicConVal,
      RecConVal,
      picDetName,
      picDetMob,
      recDetName,
      recDetMob;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sToken = sp.getString('token');
      print(sToken);
    });
    if (sToken == null) {
      setState(() {
        sp.clear();
        STM().finishAffinity(ctx, Login());
      });
    }
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        apiIntegrate(type: 'get', value: '', apiname: 'goods_type');
        apiIntegrate(type: 'get', value: '', apiname: 'profile_details');
      }
    });
    bool check = await Permission.location.isGranted;
    if (check) {
      Position? position = await Geolocator.getCurrentPosition();
      setState(() {
        curtLat = position.latitude;
        curtLng = position.longitude;
      });
    } else {
      locationDialog();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getSession();
    pickAddCtrl.stream.listen((event) async {
      SharedPreferences sp = await SharedPreferences.getInstance();
      setState(() {
        addressVal = event['address'].toString();
        address.clear();
        address.add({
          'pincode': event['pincode'],
          'state': event['state'].toString(),
          'city': event['city'].toString(),
          'lat': event['latitude'].toString(),
          'lng': event['longitude'].toString(),
        });
      });
      print(event);
    });
    recContrl.stream.listen((event) {
      setState(() {
        recDetName = event['name'];
        recDetMob = event['mobile'];
      });
    });
    addresscontroller.stream.listen(
      (dynamic event) {
        setState(() {
          addressList.add({
            "latitude": event['latitude'],
            "longitude": event['longitude'],
            "state": event['state'],
            "city": event['city'],
            "pincode": event['pincode'],
          });
        });
        print(addressList);
      },
    );
    pickContrl.stream.listen((event) {
      setState(() {
        picDetName = event['name'];
        picDetMob = event['mobile'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return UpgradeAlert(
      upgrader: Upgrader(
        showLater: false,
        showIgnore: false,
        showReleaseNotes: true,
        canDismissDialog: false,
        onUpdate: () {
          Future.delayed(Duration(seconds: 1), () {
            SystemNavigator.pop();
          });
          return true;
        },
        durationUntilAlertAgain: const Duration(minutes: 5),
      ),
      child: DoubleBack(
        message: 'Please press back once again!!!',
        child: Scaffold(
          key: scaffoldState,
          bottomNavigationBar: bottomBarLayout(ctx, 0),
          backgroundColor: Clr().white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Clr().white,
            leading: InkWell(
                onTap: () {
                  // STM().back2Previous(ctx);
                  scaffoldState.currentState!.openDrawer();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset('assets/menu.svg'),
                )),
            title: Image.asset('assets/home_logo.png'),
            centerTitle: true,
            actions: [
              SvgPicture.asset("assets/wallet.svg"),
              SizedBox(width: Dim().d12),
            ],
          ),
          drawer: navBar(ctx, scaffoldState, name),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(Dim().d16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Dim().d12,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Create ",
                      style: Sty().smallText.copyWith(
                          fontSize: 20,
                          fontFamily: "MulshiSemi",
                          fontWeight: FontWeight.w400,
                          color: Clr().textcolor),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Request',
                          style: Sty().smallText.copyWith(
                                color: Clr().secondary,
                                fontSize: 20,
                                fontFamily: "MulshiSemi",
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dim().d20,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/location.svg'),
                      SizedBox(
                        width: Dim().d16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'From',
                              style: Sty().mediumText.copyWith(
                                  color: Clr().textcolor,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: Dim().d4,
                            ),
                            if (addressVal != null)
                              Text(
                                '$addressVal ${address[0]['pincode']}',
                                style: Sty().smallText.copyWith(
                                    color: addressVal != null
                                        ? Clr().textcolor.withOpacity(0.70)
                                        : Clr().primaryColor),
                              ),
                            if (addressVal != null &&
                                address[0]['pincode'].toString().isEmpty)
                              SizedBox(height: Dim().d12),
                            if (addressVal != null &&
                                address[0]['pincode'].toString().isEmpty)
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Pincode is required';
                                        }
                                        if (value.length != 6) {
                                          return 'Pincode must be 6 digits';
                                        }
                                        return null;
                                      },
                                      maxLength: 6,
                                      controller: pickPinCtrl,
                                      keyboardType: TextInputType.number,
                                      decoration: Sty()
                                          .TextFormFieldOutlineDarkStyle
                                          .copyWith(
                                            counterText: '',
                                            hintText:
                                                "Pincode not found.Put Pincode",
                                            hintStyle: Sty().microText.copyWith(
                                                color: Clr().hintColor,
                                                fontWeight: FontWeight.w400),
                                          ),
                                      onFieldSubmitted: (value) {
                                        setState(() {
                                          address[0]['pincode'] =
                                              value.toString();
                                        });
                                        print(address);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: Dim().d4),
                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            address[0]['pincode'] =
                                                pickPinCtrl.text.toString();
                                          });
                                          print(address);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Clr().primaryColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        Dim().d12)))),
                                        child: Center(
                                          child: Text('Done',
                                              style: Sty().microText.copyWith(
                                                  color: Clr().white)),
                                        )),
                                  )
                                ],
                              ),
                            SizedBox(
                              height: Dim().d2,
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: ctx,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(Dim().d12),
                                    topRight: Radius.circular(Dim().d12),
                                  )),
                                  builder: (context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dim().d20,
                                              vertical: Dim().d20),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () async {
                                                    STM().back2Previous(ctx);
                                                    bool check =
                                                        await Permission
                                                            .location.isGranted;
                                                    if (check) {
                                                      getCurrentLct();
                                                    } else {
                                                      locationDialog();
                                                    }
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.location_on_sharp,
                                                        color:
                                                            Clr().primaryColor,
                                                      ),
                                                      SizedBox(
                                                          height: Dim().d12),
                                                      Text(
                                                          'Current Location Address',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              Sty().mediumText)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: Dim().d20,
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    STM().back2Previous(ctx);
                                                    STM().redirect2page(
                                                        ctx,
                                                        MapLocation(
                                                          lat: curtLat,
                                                          lng: curtLng,
                                                          type: 'pick',
                                                        ));
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.map_rounded,
                                                        color:
                                                            Clr().primaryColor,
                                                      ),
                                                      SizedBox(
                                                          height: Dim().d12),
                                                      Text('Pick From Map',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              Sty().mediumText)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'Add pickup address',
                                style: Sty()
                                    .smallText
                                    .copyWith(color: Clr().primaryColor),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                  const Divider(),
                  SizedBox(
                    height: Dim().d12,
                  ),
                  if (addressList.isEmpty)
                    Row(
                      children: [
                        SvgPicture.asset('assets/location.svg'),
                        SizedBox(
                          width: Dim().d16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'To',
                              style: Sty().mediumText.copyWith(
                                  color: Clr().textcolor,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: Dim().d4,
                            ),
                            InkWell(
                              onTap: () {
                                STM().redirect2page(
                                    ctx,
                                    MapLocation(
                                      lat: curtLat,
                                      lng: curtLng,
                                    ));
                              },
                              child: Text(
                                'Add Receiver address',
                                style: Sty()
                                    .smallText
                                    .copyWith(color: Clr().primaryColor),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  if (addressList.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                            itemCount: addressList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              pinCtrol.add(TextEditingController());
                              return Padding(
                                padding: EdgeInsets.only(bottom: Dim().d20),
                                child: Row(
                                  children: [
                                    Container(
                                      height: Dim().d32,
                                      width: Dim().d32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Clr().clr29,
                                      ),
                                      child: Center(
                                        child: Text('${index + 1}',
                                            style: Sty()
                                                .smallText
                                                .copyWith(color: Clr().white)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Dim().d16,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'To',
                                                  style: Sty()
                                                      .mediumText
                                                      .copyWith(
                                                          color:
                                                              Clr().textcolor),
                                                ),
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      addressList
                                                          .removeAt(index);
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Clr().clr29,
                                                    size: Dim().d16,
                                                  )),
                                              SizedBox(
                                                width: Dim().d12,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: Dim().d4,
                                          ),
                                          Text(
                                            '${addressList[index]['city']} ${addressList[index]['state']} ${addressList[index]['pincode']}',
                                            style: Sty().smallText.copyWith(
                                                color: Clr()
                                                    .textcolor
                                                    .withOpacity(0.70),
                                                fontWeight: FontWeight.w100),
                                          ),
                                          if (addressList[index]['pincode']
                                              .toString()
                                              .isEmpty)
                                            SizedBox(height: Dim().d12),
                                          if (addressList[index]['pincode']
                                              .toString()
                                              .isEmpty)
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Pincode is required';
                                                      }
                                                      if (value.length != 6) {
                                                        return 'Pincode must be 6 digits';
                                                      }
                                                      return null;
                                                    },
                                                    maxLength: 6,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller: pinCtrol[index],
                                                    decoration: Sty()
                                                        .TextFormFieldOutlineDarkStyle
                                                        .copyWith(
                                                            hintText:
                                                                "Pincode not found.Please write pincode",
                                                            counterText: '',
                                                            hintStyle: Sty()
                                                                .microText
                                                                .copyWith(
                                                                    color: Clr()
                                                                        .hintColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                  ),
                                                ),
                                                SizedBox(width: Dim().d4),
                                                Expanded(
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            addressList[index][
                                                                    'pincode'] =
                                                                pinCtrol[index]
                                                                    .text
                                                                    .toString();
                                                          });
                                                          print(address);
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor: Clr()
                                                                .primaryColor,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            Dim().d12)))),
                                                        child: Center(
                                                          child: Text('Done',
                                                              style: Sty()
                                                                  .microText
                                                                  .copyWith(
                                                                      color: Clr()
                                                                          .white)),
                                                        )))
                                              ],
                                            ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(Icons.add_circle,
                                color: Clr().clr29, size: Dim().d32),
                            SizedBox(
                              width: Dim().d16,
                            ),
                            InkWell(
                              onTap: () {
                                STM().redirect2page(
                                    ctx,
                                    MapLocation(
                                      lat: curtLat,
                                      lng: curtLng,
                                    ));
                              },
                              child: Text(
                                'Add New Stop',
                                style: Sty()
                                    .smallText
                                    .copyWith(color: Clr().primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  SizedBox(
                    height: Dim().d32,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: dobCtrl,
                          readOnly: true,
                          onTap: () {
                            datePicker();
                          },
                          cursorColor: Clr().textcolor,
                          style: Sty().smallText,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          decoration: Sty().textFieldOutlineStyle.copyWith(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: Dim().d12, vertical: Dim().d12),
                              hintStyle: Sty().smallText.copyWith(
                                    color: Clr().textGrey,
                                  ),
                              filled: true,
                              fillColor: Clr().grey,
                              hintText: "Select Date",
                              counterText: "",
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(Dim().d16),
                                child: SvgPicture.asset("assets/calender.svg"),
                              )),
                          validator: (value) {
                            if (dobCtrl.text.isEmpty) {
                              return 'Date Of Birth is required';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: Dim().d8,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: timeCtrl,
                          readOnly: true,
                          onTap: () {
                            _selectTime(ctx);
                          },
                          cursorColor: Clr().textcolor,
                          style: Sty().smallText,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          decoration: Sty().textFieldOutlineStyle.copyWith(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: Dim().d12, vertical: Dim().d12),
                              hintStyle: Sty().smallText.copyWith(
                                    color: Clr().textGrey,
                                  ),
                              filled: true,
                              fillColor: Clr().grey,
                              hintText: "Select Time",
                              counterText: "",
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(Dim().d16),
                                child: SvgPicture.asset("assets/clock.svg"),
                              )),
                          validator: (value) {
                            if (timeCtrl.text.isEmpty) {
                              return 'Time is required';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dim().d24,
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.only(
                      left: Dim().d20,
                      right: Dim().d12,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border:
                            Border.all(color: Clr().primaryColor, width: 0.5)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<dynamic>(
                        value: goodsValue,
                        hint: Text(
                          'Select your goods type',
                          style: Sty().mediumText.copyWith(
                                color: Clr().primaryColor,
                              ),
                        ),
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: Clr().primaryColor),
                        style: TextStyle(
                          color: Clr().textcolor,
                          fontSize: 16,
                        ),
                        onChanged: (value) {
                          setState(() {
                            goodsValue = value.toString();
                            goodsTypVal != null;
                            print('Selected Goods = ${goodsValue}');
                            // position = v['variant'].indexWhere((e) =>
                            // e['weight'].toString() == value.toString());
                            // varientprice = v['variant'][position]
                            // ['final_price']
                            //     .toString();
                          });
                        },
                        items: goodsList.map((v) {
                          return DropdownMenuItem<dynamic>(
                            value: v['name'].toString(),
                            child: Text(
                              v['name'].toString(),
                              style: TextStyle(
                                  color: Clr().textcolor, fontSize: 14),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  goodsTypVal == null
                      ? Container()
                      : SizedBox(height: Dim().d8),
                  goodsTypVal == null
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d14),
                          child: Text('${goodsTypVal}',
                              style: Sty()
                                  .mediumText
                                  .copyWith(color: Clr().errorRed)),
                        ),
                  SizedBox(
                    height: Dim().d20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pickup Contact Details',
                        style: Sty().mediumText,
                      ),
                      if (picDetName != null)
                        InkWell(
                            onTap: () {
                              _pickupSheet(name: picDetName, mobile: picDetMob);
                            },
                            child: Icon(
                              Icons.edit,
                              color: Clr().clr29,
                              size: Dim().d20,
                            ))
                    ],
                  ),
                  SizedBox(
                    height: Dim().d20,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(ctx).size.width * 100,
                      child: picDetName != null
                          ? Container(
                              decoration: BoxDecoration(
                                  color: Clr().clrc4.withOpacity(0.24),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dim().d20))),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dim().d20, vertical: Dim().d14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${picDetName}',
                                        style: Sty().mediumText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: Dim().d12)),
                                    SizedBox(
                                      height: Dim().d6,
                                    ),
                                    Text('+91 ${picDetMob}',
                                        style: Sty().mediumText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: Dim().d12)),
                                  ],
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                _pickupSheet();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffe7eaef),
                                  elevation: 0.5,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Clr().primaryColor, width: 0.5),
                                    borderRadius: BorderRadius.circular(50),
                                  )),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: Dim().d14),
                                  child: Text(
                                    'Add Contact Details',
                                    textAlign: TextAlign.left,
                                    style: Sty().smallText.copyWith(
                                          color: Clr().primaryColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ),
                              )),
                    ),
                  ),
                  PicConVal == null ? Container() : SizedBox(height: Dim().d8),
                  PicConVal == null
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d14),
                          child: Text('${PicConVal}',
                              style: Sty()
                                  .mediumText
                                  .copyWith(color: Clr().errorRed)),
                        ),
                  SizedBox(
                    height: Dim().d20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Receiver Contact Details',
                        style: Sty().mediumText,
                      ),
                      if (recDetName != null)
                        InkWell(
                            onTap: () {
                              _recieverSheet(
                                  mobile: recDetMob, name: recDetName);
                            },
                            child: Icon(
                              Icons.edit,
                              color: Clr().clr29,
                              size: Dim().d20,
                            ))
                    ],
                  ),
                  SizedBox(
                    height: Dim().d20,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(ctx).size.width * 100,
                      child: recDetName != null
                          ? Container(
                              decoration: BoxDecoration(
                                  color: Clr().clrc4.withOpacity(0.24),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dim().d20))),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dim().d20, vertical: Dim().d14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${recDetName}',
                                        style: Sty().mediumText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: Dim().d12)),
                                    SizedBox(
                                      height: Dim().d6,
                                    ),
                                    Text('+91 ${recDetMob}',
                                        style: Sty().mediumText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: Dim().d12)),
                                  ],
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                // if (formKey.currentState!.validate()) {
                                //   STM().checkInternet(context, widget).then((value) {
                                //     if (value) {
                                //       // sendOtp();
                                //       // STM().redirect2page(ctx, OTP());
                                //     }
                                //   });
                                // };
                                _recieverSheet();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffe7eaef),
                                  elevation: 0.5,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Clr().primaryColor, width: 0.5),
                                    borderRadius: BorderRadius.circular(50),
                                  )),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: Dim().d14),
                                  child: Text(
                                    'Add Contact Details',
                                    textAlign: TextAlign.left,
                                    style: Sty().smallText.copyWith(
                                          color: Clr().primaryColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ),
                              )),
                    ),
                  ),
                  RecConVal == null ? Container() : SizedBox(height: Dim().d8),
                  RecConVal == null
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dim().d14),
                          child: Text('${RecConVal}',
                              style: Sty()
                                  .mediumText
                                  .copyWith(color: Clr().errorRed)),
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
                              validateLayout();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Clr().primaryColor,
                              elevation: 0.5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              )),
                          child: Text(
                            'Find Vehicle',
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
        ),
      ),
    );
  }

  /// validation
  validateLayout() async {
    if (goodsValue == null) {
      setState(() {
        goodsTypVal = 'goods type is required';
      });
    } else if (picDetName == null) {
      setState(() {
        PicConVal = 'Pickup details is required';
      });
    } else if (recDetName == null) {
      setState(() {
        RecConVal = 'Receiver details is required';
      });
    } else if (address[0]['pincode'].toString().isEmpty) {
      setState(() {
        Fluttertoast.showToast(
            msg: 'Pincode not found in Pickup Address.Please put pincode',
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
      });
    } else if (addressList.map((e) => e['pincode'].toString()).contains('')) {
      setState(() {
        Fluttertoast.showToast(
            msg: 'Pincode not found in Receiver Address.Please put pincode',
            gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
      });
    } else {
      setState(() {
        print(addressList);
        print(address);
        STM().redirect2page(
          ctx,
          SelectVehicle(
            requestList: {
              "date": dobCtrl.text,
              "time": timeCtrl.text,
              "pickup_name": picDetName,
              "pincode": address[0]['pincode'],
              "goods_type": goodsValue,
              "pickup_mobile": picDetMob,
              "latitude": address[0]['lat'],
              "longitude": address[0]['lng'],
              "state": address[0]['state'],
              "city": address[0]['city'],
              "receiver_name": recDetName,
              "receiver_mobile": recDetMob,
              "receiver_addresses": addressList,
            },
          ),
        );
      });
    }
  }

  /// Date Picker
  Future datePicker() async {
    DateTime? picked = await showDatePicker(
      context: ctx,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(primary: Clr().primaryColor),
          ),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      //Disabled past date
      // firstDate: DateTime.now().subtract(Duration(days: 1)),
      // Disabled future date
      // lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        String s = STM().dateFormat('yyyy-MM-dd', picked);
        dobCtrl = TextEditingController(text: s);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked_s = await showTimePicker(
      context: context,
      initialTime: selectedTimes,
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: false,
            ),
            child: child!);
      },
    );
    if (picked_s != null && picked_s != selectedTimes) {
      setState(() {
        timeCtrl = TextEditingController(
            text: picked_s.minute.toString().length == 1
                ? picked_s.hour.toString().length == 1
                    ? '0${picked_s.hour}:0${picked_s.minute}:00'
                    : '${picked_s.hour}:0${picked_s.minute}:00'
                : picked_s.hour.toString().length == 1
                    ? '0${picked_s.hour}:${picked_s.minute}:00'
                    : '${picked_s.hour}:${picked_s.minute}:00');
        print(timeCtrl.text);
      });
    }
  }

  /// Pickup Contact Details
  Future _pickupSheet({name, mobile}) {
    // _selectedIndex = listname.indexWhere((element) => element['name'] == name);
    TextEditingController nameCtrl = TextEditingController(text: name);
    TextEditingController mobileCtrl = TextEditingController(text: mobile);
    return showModalBottomSheet<dynamic>(
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: const BoxConstraints(maxHeight: 600.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dim().d20),
          topRight: Radius.circular(Dim().d20),
        ),
      ),
      context: ctx,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: Dim().d20),
            child: Form(
              key: pickformKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Dim().d20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pickup Contact Details',
                        style: Sty().mediumText.copyWith(
                            fontFamily: 'MulishSemi',
                            fontWeight: FontWeight.w500,
                            fontSize: Dim().d20,
                            color: Clr().textcolor),
                      ),
                      picDetName == null
                          ? Container()
                          : InkWell(
                              onTap: () {
                                STM().back2Previous(ctx);
                              },
                              child: Icon(
                                Icons.close,
                                color: Clr().primaryColor,
                              ))
                    ],
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
                            if (pickformKey.currentState!.validate()) {
                              setState(() {
                                PicConVal != null;
                                HomeState.pickContrl.sink.add({
                                  'name': nameCtrl.text,
                                  'mobile': mobileCtrl.text,
                                });
                              });
                              STM().back2Previous(ctx);
                            }
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
                    height: Dim().d40,
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  /// Reciever Contact Details
  Future _recieverSheet({name, mobile}) {
    // _selectedIndex = listname.indexWhere((element) => element['name'] == name);
    TextEditingController nameCtrl = TextEditingController(text: name);
    TextEditingController mobileCtrl = TextEditingController(text: mobile);
    return showModalBottomSheet<void>(
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: const BoxConstraints(maxHeight: 600.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Dim().d20),
          topRight: Radius.circular(Dim().d20),
        ),
      ),
      context: ctx,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: Dim().d20),
            child: Form(
              key: recformKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Dim().d20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Receiver Details',
                        style: Sty().mediumText.copyWith(
                            fontFamily: 'MulishSemi',
                            fontWeight: FontWeight.w500,
                            fontSize: Dim().d20,
                            color: Clr().textcolor),
                      ),
                      recDetName == null
                          ? Container()
                          : InkWell(
                              onTap: () {
                                STM().back2Previous(ctx);
                              },
                              child: Icon(
                                Icons.close,
                                color: Clr().primaryColor,
                              ))
                    ],
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
                            if (recformKey.currentState!.validate()) {
                              setState(() {
                                RecConVal != null;
                                HomeState.recContrl.sink.add({
                                  'name': nameCtrl.text,
                                  'mobile': mobileCtrl.text,
                                });
                              });
                              STM().back2Previous(ctx);
                            }
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
                    height: Dim().d40,
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  /// currentLocation
  getCurrentLct() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    LocationPermission permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position? position = await Geolocator.getCurrentPosition();
      list =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      setState(() {
        curtLat = position.latitude;
        curtLng = position.longitude;
        addressVal =
            '${list[1].thoroughfare == '' ? list[0].thoroughfare : list[1].thoroughfare} ${list[1].subLocality == '' ? list[0].subLocality : list[1].subLocality} ${list[1].postalCode == '' ? list[0].postalCode : list[1].postalCode} ${list[1].country == '' ? list[0].country : list[1].country}';
        address.add({
          'pincode': list[0].postalCode == ''
              ? list[1].postalCode
              : list[0].postalCode,
          'state': list[0].administrativeArea == ''
              ? list[1].administrativeArea
              : list[0].administrativeArea,
          'city': addressVal,
          'lat': position.latitude,
          'lng': position.longitude,
        });
      });
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      AwesomeDialog(
          context: ctx,
          width: double.infinity,
          dialogType: DialogType.noHeader,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dim().d12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Kindly grant location permission through your device settings.',
                    style: Sty().mediumText.copyWith(
                        color: Clr().clr29, fontWeight: FontWeight.w400)),
                SizedBox(
                  height: Dim().d12,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () async {
                            await Geolocator.openAppSettings().then((value) {
                              setState(() {
                                SystemNavigator.pop();
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Clr().clr29,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(Dim().d8),
                            child: Text(
                              'Go Settings',
                              style:
                                  Sty().smallText.copyWith(color: Clr().white),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: Dim().d12,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            STM().back2Previous(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Clr().clr29,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(Dim().d8),
                            child: Text(
                              'Cancel',
                              style:
                                  Sty().smallText.copyWith(color: Clr().white),
                            ),
                          )),
                    ),
                  ],
                )
              ],
            ),
          )).show();
    }
  }

  ///location dialog
  locationDialog() {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.scale,
        width: double.infinity,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dim().d12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/loc.png', fit: BoxFit.fitWidth),
              Text('Location permission is required',
                  style: Sty().mediumText.copyWith(
                      color: Clr().clr29,
                      fontSize: Dim().d16,
                      fontWeight: FontWeight.w700)),
              Text(
                  'To enhance your experience and provide accurate address information, please grant permission to enable location services on your device.',
                  textAlign: TextAlign.center,
                  style: Sty().mediumText.copyWith(
                      color: Clr().textcolor,
                      fontSize: Dim().d14,
                      fontWeight: FontWeight.w400)),
              SizedBox(height: Dim().d20),
              ElevatedButton(
                  onPressed: () async {
                    STM().back2Previous(ctx);
                    bool check = await Permission.location.isGranted;
                    getCurrentLct();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Clr().clr29,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dim().d16),
                      )),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: Dim().d12),
                    child: Center(
                      child: Text('Continue',
                          style: Sty().mediumText.copyWith(
                              color: Clr().white,
                              fontWeight: FontWeight.w500,
                              fontSize: Dim().d16)),
                    ),
                  )),
              SizedBox(height: Dim().d20),
            ],
          ),
        )).show();
  }

  /// api intgertaion

  apiIntegrate({apiname, type, value}) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var data = FormData.fromMap({});
    switch (apiname) {
      // case 'add_favourite':
      //   data = FormData.fromMap({
      //     'stock_id': value,
      //   });
      //   break;
    }
    FormData body = data;
    var result = type == 'post'
        ? await STM().postWithToken(ctx, Str().loading, apiname, body, sToken)
        : await STM().getcat(ctx, Str().loading, apiname, sToken);
    switch (apiname) {
      case 'goods_type':
        if (result['success']) {
          setState(() {
            goodsList = result['data'];
          });
        } else {
          setState(() {
            STM().errorDialog(ctx, result['message']);
          });
        }
        break;
      case 'profile_details':
        if (result['success']) {
          setState(() {
            name = result['data']['name'];
          });
        } else {
          setState(() {
            print(result['message']);
            STM().errorDialog(ctx, result['message']);
          });
        }
        break;
    }
  }
}
