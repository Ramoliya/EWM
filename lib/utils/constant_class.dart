import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'colors_app.dart';

class ConstantClass {

  // Print format
  static PrintMessage(var message) {
    if (kDebugMode) {
      print(message.toString());
    }
  }

  // Toast format
  static ToastMessage(var message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: ColorsApp.colorBlack.withOpacity(0.4),
        textColor: ColorsApp.colorWhite,
        fontSize: 14.0);
  }

  // Progress bar UI
  static Widget apiLoadingAnimation(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,

        child: CircularProgressIndicator()
    );
  }
}