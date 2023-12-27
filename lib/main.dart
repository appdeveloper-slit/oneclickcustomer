import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:one_click/search_driver.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sp = await SharedPreferences.getInstance();
  bool isLogin = sp.getBool('is_login') ?? false;
  //Remove this method to stop OneSignal Debugging
  OneSignal.logout();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('d368a6ff-3184-46b0-b62b-d2ab2189d3b6');
  // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);
  /// pusher
  PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  await pusher.init(
    apiKey: '6ac8c1c1cb4a2ec26a8d',
    cluster: 'ap2',
    onEvent: (e) async{
      print('event : $e');
      SearchDriverPage.chatCtrl.sink.add(e);
    },
  );
  await pusher.subscribe(channelName: 'check_status-channel');
  await pusher.connect();
  await Future.delayed(const Duration(seconds: 3));
  runApp(
    MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      home: isLogin ? Home() : Login(),
    ),
  );
}
