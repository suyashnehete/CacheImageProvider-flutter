import 'package:flutter/material.dart';

class Media {
  static late double screenWidth;
  static late double screenHeight;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static late double text = 0;
  static late double image = 0;
  static late double height = 0;
  static late double width = 0;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  static int profilePhotoSize = 0;
  static int postPhotoWidth = 0;
  static int postPhotoHeight = 0;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      screenWidth = constraints.maxHeight;
      screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockWidth = screenWidth / 100;
    _blockHeight = screenHeight / 100;

    text = _blockHeight;
    image = _blockWidth;
    height = _blockHeight;
    width = _blockWidth;
    profilePhotoSize = (Media.width * 50).toInt();
    postPhotoHeight = (Media.width * 85).toInt();
    postPhotoWidth = (Media.width * 100).toInt();
  }
}