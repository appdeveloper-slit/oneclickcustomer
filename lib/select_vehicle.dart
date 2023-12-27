import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_click/my_request.dart';
import 'package:one_click/values/colors.dart';
import 'package:one_click/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manage/static_method.dart';
import 'search_driver.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class SelectVehicle extends StatefulWidget {
  final requestList;

  const SelectVehicle({super.key, this.requestList});

  @override
  State<SelectVehicle> createState() => _SelectVehicleState();
}

class _SelectVehicleState extends State<SelectVehicle> {
  late BuildContext ctx;

  List<dynamic> vehiclelist = [];

  List<dynamic> instructionsList = [];

  var sToken;
  Map<String, dynamic> finalList = {};

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sToken = sp.getString('token');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        apiIntegrate(type: 'get', value: '', apiname: 'get_vehicles');
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

    return Scaffold(
      backgroundColor: Clr().white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Clr().white,
        leadingWidth: 52,
        title: Text(
          'Select Vehicle',
          style: Sty().largeText,
        ),
        centerTitle: true,
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
        child: Column(
          children: [
            SizedBox(
              height: Dim().d20,
            ),
            ListView.separated(
              physics: BouncingScrollPhysics(),
              itemCount: vehiclelist.length,
              padding: EdgeInsets.symmetric(horizontal: Dim().d4),
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return vehicleLayout(ctx, vehiclelist[index]);
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: Dim().d20,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget vehicleLayout(ctx, v) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Clr().borderColor.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 2,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Clr().shimmerColor, width: 0.2)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(
                Dim().d12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: Dim().d8,
                      ),
                      Image.asset('assets/truck.png'),
                      SizedBox(
                        width: Dim().d20,
                      ),
                      Text(
                        '${v['name']}',
                        style: Sty().mediumText.copyWith(
                            color: Clr().textcolor,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                          onTap: () {
                            _showInstructionDialog(ctx, v['instructions']);
                          },
                          child: SvgPicture.asset('assets/info.svg')),
                      SizedBox(
                        height: Dim().d28,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dim().d8),
              child: Divider(),
            ),
            SizedBox(
              height: Dim().d8,
            ),
            Padding(
              padding: EdgeInsets.only(left: Dim().d20),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    'Capacity',
                    style: Sty().microText.copyWith(
                        color: Clr().textGrey, fontWeight: FontWeight.w600),
                  )),
                  Text(':'),
                  Expanded(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${v['capacity']}',
                            style: Sty().smallText,
                          ))),
                ],
              ),
            ),
            SizedBox(
              height: Dim().d8,
            ),
            Padding(
              padding: EdgeInsets.only(left: Dim().d20),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    'Size',
                    style: Sty().microText.copyWith(
                        color: Clr().textGrey, fontWeight: FontWeight.w600),
                  )),
                  Text(':'),
                  Expanded(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${v['size']}',
                            style: Sty().smallText,
                          ))),
                ],
              ),
            ),
            SizedBox(
              height: Dim().d8,
            ),
            Padding(
              padding: EdgeInsets.only(left: Dim().d20),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    'Select vehicle type',
                    style: Sty().microText.copyWith(
                        color: Clr().textGrey, fontWeight: FontWeight.w600),
                  )),
                  Text(':'),
                  Expanded(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '${v['type']}',
                            style: Sty().smallText,
                          ))),
                ],
              ),
            ),
            SizedBox(
              height: Dim().d12,
            ),
            Center(
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(ctx).size.width * 100,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        finalList = {
                          "vehicle_id": v['id'],
                        };
                        finalList.addAll(widget.requestList);
                      });
                      apiIntegrate(
                          type: 'post', value: '', apiname: 'add_request');
                      print(finalList);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Clr().primaryColor,
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        )),
                    child: Text(
                      'Confirm',
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
    );
  }

  _showInstructionDialog(ctx, list) {
    AwesomeDialog(
      isDense: true,
      context: ctx,
      dialogType: DialogType.NO_HEADER,
      animType: AnimType.BOTTOMSLIDE,
      alignment: Alignment.centerLeft,
      body: Container(
        padding: EdgeInsets.all(Dim().d12),
        child: Column(
          children: [
            Text(
              'Instruction',
              style: Sty().mediumText.copyWith(
                    color: Clr().textcolor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
            ),
            SizedBox(
              height: Dim().d20,
            ),
            ListView.separated(
              physics: BouncingScrollPhysics(),
              itemCount: list.length,
              padding: EdgeInsets.symmetric(horizontal: Dim().d4),
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return infoLayout(ctx, index, list);
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: Dim().d20,
                );
              },
            ),
            SizedBox(
              height: Dim().d24,
            ),
          ],
        ),
      ),
    ).show();
  }

  Widget infoLayout(ctx, index, list) {
    var v = list[index];
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: Clr().secondary,
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        SizedBox(
          width: Dim().d12,
        ),
        Expanded(
            child: Text(
          v.toString(),
        ))
      ],
    );
  }

  /// api intgertaion
  apiIntegrate({apiname, type, value}) async {
    var data = FormData.fromMap({});
    switch (apiname) {
      case 'add_request':
        data =  FormData.fromMap(finalList);
        break;
    }
    FormData body = data;
    var result = type == 'post'
        ? await STM().postWithToken(ctx, Str().loading, apiname, body, sToken)
        : await STM().getcat(ctx, Str().loading, apiname, sToken);
    switch (apiname) {
      case 'get_vehicles':
        if (result['success']) {
          setState(() {
            vehiclelist = result['data'];
          });
        } else {
          setState(() {
            STM().errorDialog(ctx, result['message']);
          });
        }
        break;
      case 'add_request':
        if (result['success']) {
          STM().successDialogWithReplace(ctx, result['message'], SearchDriver(id: result['data']['request_id'],));
        } else {
          setState(() {
            STM().errorDialog(ctx, result['message']);
          });
        }
        break;
    }
  }
}
