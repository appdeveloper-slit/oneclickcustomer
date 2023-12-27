import 'package:flutter/material.dart';
import 'package:one_click/values/dimens.dart';
import 'package:one_click/values/styles.dart';
import '../home.dart';
import '../manage/static_method.dart';
import '../my_profile.dart';
import '../my_request.dart';
import '../notification.dart';
import '../values/colors.dart';

Widget bottomBarLayout(ctx, index) {
  return BottomNavigationBar(
    elevation: 3,
    backgroundColor: Clr().white,
    fixedColor: Clr().clr29,
    selectedLabelStyle: Sty().mediumText.copyWith(
        color: Clr().clr29, fontWeight: FontWeight.w500, fontSize: Dim().d12),
    unselectedLabelStyle: Sty().mediumText.copyWith(
        color: Clr().cdc, fontWeight: FontWeight.w500, fontSize: Dim().d12),
    selectedFontSize: 00.0,
    unselectedFontSize: 00.0,
    type: BottomNavigationBarType.fixed,
    currentIndex: index,
    onTap: (i) async {
      switch (i) {
        case 0:
          STM().finishAffinity(ctx, Home());
          break;
        case 1:
          STM().redirect2page(ctx, NotificationPage());
          break;
        case 2:
          STM().replacePage(ctx, MyRequest());
          break;
        case 3:
          index == 3
              ? STM().replacePage(ctx, MyProfile(index: 3))
              : STM().redirect2page(ctx, MyProfile());
          break;
      }
    },
    items: STM().getBottomList(index),
  );
}
