import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_click/values/colors.dart';
import 'package:one_click/values/dimens.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'manage/static_method.dart';
import 'my_request.dart';
import 'values/styles.dart';

class SearchDriver extends StatefulWidget {
  final id;

  const SearchDriver({super.key, this.id});

  @override
  State<StatefulWidget> createState() {
    return SearchDriverPage();
  }
}

class SearchDriverPage extends State<SearchDriver> with WidgetsBindingObserver {
  late BuildContext ctx;

  // Set the initial time to 10 minutes
  int _timeInSeconds = 5;
  Timer? _timer;
  static StreamController<PusherEvent> chatCtrl =
      StreamController<PusherEvent>.broadcast();

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeInSeconds > 0) {
          _timeInSeconds--;
        } else {
          _timer?.cancel();
          _rideConfirmedDialog(ctx);
          // You can add code here to handle timer completion, e.g., show a dialog.
        }
      });
    });
  }

  loadLayout(b) async {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        body: Padding(
          padding: EdgeInsets.all(Dim().d12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/conride.png',
                height: Dim().d280,
              ),
              SizedBox(
                height: Dim().d8,
              ),
              b
                  ? Text('Ride is Confirmed',
                      style: Sty().mediumText.copyWith(
                          color: Clr().black,
                          fontWeight: FontWeight.w500,
                          fontSize: Dim().d28))
                  : Text('Ride is Cancelled',
                      style: Sty().mediumText.copyWith(
                          color: Clr().black,
                          fontWeight: FontWeight.w500,
                          fontSize: Dim().d28)),
              SizedBox(
                height: Dim().d12,
              ),
              b
                  ? Text(
                      'We have found a driver',
                      style: Sty().mediumText.copyWith(
                          color: Color(0xff606268),
                          fontWeight: FontWeight.w400,
                          fontSize: Dim().d16),
                    )
                  : Text(
                      "We couldn't find a driver at a moment",
                      textAlign: TextAlign.center,
                      style: Sty().mediumText.copyWith(
                          color: Color(0xff606268),
                          fontWeight: FontWeight.w400,
                          fontSize: Dim().d16),
                    ),
              SizedBox(
                height: Dim().d20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dim().d36),
                child: ElevatedButton(
                    onPressed: () {
                      STM().replacePage(context, MyRequest(point: b ? 0 : 3));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(Dim().d20)))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: Dim().d12),
                      child: Center(
                        child: Text('Details',
                            style: Sty().mediumText.copyWith(
                                color: Clr().white, fontSize: Dim().d12)),
                      ),
                    )),
              ),
              SizedBox(
                height: Dim().d20,
              ),
            ],
          ),
        )).show();
  }

  getSessionData() async {
    setState(() {
      chatCtrl.stream.listen((e) async {
        Map<String, dynamic> v = jsonDecode(e.data.toString());
        if (int.parse(v['data']['request_id'].toString()) ==
            int.parse(widget.id.toString())) {
          loadLayout(true);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getSessionData();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return WillPopScope(
      onWillPop: () async {
        STM().replacePage(ctx, MyRequest());
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Clr().white,
          leadingWidth: 52,
          leading: InkWell(
              onTap: () {
                STM().replacePage(ctx, MyRequest());
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
            "Searching For a Driver",
            style:
                Sty().largeText.copyWith(fontSize: 20, color: Clr().textcolor),
          ),
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(ctx).size.height,
          child: Column(
            children: [
              SizedBox(
                height: Dim().d40,
              ),
              SvgPicture.asset("assets/search_driver.svg"),
              SizedBox(
                height: Dim().d32,
              ),
              TweenAnimationBuilder<Duration>(
                  duration: const Duration(minutes: 10),
                  tween: Tween(begin: const Duration(minutes: 10), end: Duration.zero),
                  onEnd: () {
                    loadLayout(false);
                  },
                  builder:
                      (BuildContext context, Duration value, Widget? child) {
                    final minutes = value.inMinutes;
                    final seconds = value.inSeconds % 60;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "0$minutes:$seconds",
                        textAlign: TextAlign.center,
                        style: Sty().smallText.copyWith(
                            color: Clr().secondary,
                            fontWeight: FontWeight.w600,
                            fontFamily: "MulshiSemi",
                            fontSize: Dim().d28),
                      ),
                    );
                  }),
              SizedBox(
                height: Dim().d20,
              ),
              Text(
                'Searching for a driver...',
                style: Sty().mediumText.copyWith(
                    color: Clr().primaryColor, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: Dim().d16,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dim().d24,
                ),
                child: Text(
                  'Please wait for few minutes while we reach to the available driver',
                  textAlign: TextAlign.center,
                  style: Sty().smallText.copyWith(
                        color: Clr().textGrey,
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
                       STM().replacePage(ctx, MyRequest());
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Clr().primaryColor,
                          elevation: 0.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Details',
                            style: Sty().mediumText.copyWith(
                                  fontSize: 16,
                                  color: Clr().white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _rideConfirmedDialog(ctx) {
    AwesomeDialog(
      isDense: false,
      context: ctx,
      dialogType: DialogType.NO_HEADER,
      animType: AnimType.BOTTOMSLIDE,
      alignment: Alignment.centerLeft,
      body: Container(
        padding: EdgeInsets.all(Dim().d12),
        child: Column(
          children: [
            SvgPicture.asset("assets/ride_confirm.svg"),
            SizedBox(
              height: Dim().d20,
            ),
            Text(
              'Ride is Confirmed',
              style: Sty().mediumText.copyWith(
                    color: Clr().textcolor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
            ),
            SizedBox(
              height: Dim().d8,
            ),
            Text(
              'We have found a driver',
              style: Sty().mediumText.copyWith(
                    color: Clr().textGrey,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
            ),
            SizedBox(
              height: Dim().d24,
            ),
            Center(
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(ctx).size.width * 100,
                child: ElevatedButton(
                    onPressed: () {
                      // if (formKey.currentState!.validate()) {
                      //   STM().checkInternet(context, widget).then((value) {
                      //     if (value) {
                      //       // sendOtp();
                      STM().redirect2page(ctx, MyRequest());
                      //     }
                      //   });
                      // }
                      // ;
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Clr().primaryColor,
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        )),
                    child: Text(
                      'See Details',
                      style: Sty().mediumText.copyWith(
                            fontSize: 16,
                            color: Clr().white,
                            fontWeight: FontWeight.w600,
                          ),
                    )),
              ),
            ),
            SizedBox(
              height: Dim().d16,
            ),
          ],
        ),
      ),
    ).show();
  }
}
