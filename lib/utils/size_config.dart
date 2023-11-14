
import 'package:flutter/material.dart';

import 'common.dart';

class SizeConfig {
  late MediaQueryData _mediaQueryData;
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;
  static double blockSizeHorizontal = 0.0;
  static double blockSizeVertical = 0.0;

  static double _safeAreaHorizontal = 0.0;
  static double _safeAreaVertical = 0.0;
  static double safeBlockHorizontal = 0.0;
  static double safeBlockVertical = 0.0;
  static double scaleFactor = 0.0;

  static final SizeConfig _singleton = SizeConfig._internal();

  factory SizeConfig() {
    return _singleton;
  }

  SizeConfig._internal();

  Future init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
    scaleFactor = _mediaQueryData.textScaleFactor;

    if (screenWidth >= 600) {
      safeBlockHorizontal = safeBlockHorizontal - 2;
      safeBlockVertical = safeBlockVertical - 1.50;
    }

    mPrint("screenWidth==>$screenWidth");
    mPrint("screenHeight==>$screenHeight");
    mPrint("blockSizeHorizontal==>$blockSizeHorizontal");
    mPrint("blockSizeVertical==>$blockSizeVertical");
    mPrint("safeBlockHorizontal==>$safeBlockHorizontal");
    mPrint("safeBlockVertical==>$safeBlockVertical");
    mPrint("textScaleFactor==>${_mediaQueryData.textScaleFactor}");
    return Future.value();
  }
}