import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gameplugin/src/utils/transitions.dart';

Container addLine(
    double size, color, double left, double top, double right, double bottom) {
  return Container(
    height: size,
    width: double.infinity,
    color: color,
    margin: EdgeInsets.fromLTRB(left, top, right, bottom),
  );
}

SizedBox addSpace(double size) {
  return SizedBox(
    height: size,
  );
}

addSpaceWidth(double size) {
  return SizedBox(
    width: size,
  );
}

TextStyle textStyle(bool bold, double size, color,
    {underlined = false, bool withShadow = false,
      double shadowOffset=4.0,
      bool crossed=false,
      bool italic=false}) {

  return TextStyle(
      color: color,
      // fontWeight:
      // // thick?FontWeight.bold:
      // FontWeight.w500,height: height,
      // fontFamily:
      // type==0 && light? "Inter_Light":
      // type==0 && semi? "Inter_Semi_Bold":
      // type==0 && !bold? "Inter_Regular":
      // type==0 && bold? "Inter_Bold":
      // type==1 && semi? "FiraSans-SemiBold":
      // type==1 && thick? "FiraSans-Ultra":
      // type==1 && light? "FiraSans-Light":
      // type==1 && bold? "FiraSans-Bold":
      // type==2 && light? "EuclidCircularB-Light":
      // type==2 && semi? "EuclidCircularB-SemiBold":
      // type==2 && !bold? "EuclidCircularB":
      // type==2 && bold? "EuclidCircularB-Bold":
      // "FiraSans-Regular",
      fontWeight: bold?FontWeight.bold:FontWeight.normal,
      fontStyle: italic?FontStyle.italic:FontStyle.normal,
      fontSize: size,
      shadows: !withShadow
          ? null
          : (<Shadow>[
        Shadow(offset: Offset(shadowOffset,shadowOffset), blurRadius: 6.0, color: Colors.black.withOpacity(.5)),
      ]),
      decoration:
      crossed?TextDecoration.lineThrough:underlined ? TextDecoration.underline : TextDecoration.none);
}

launchNewScreen(BuildContext context, item, {Function(dynamic d)? result,
  opaque = false,bool replace=false,
  transitionBuilder,transitionDuration,bool scale=false,
  slideUp=false,slide=false,fade=false,bool ignoreIOS=false}) {

  PageRoute pageRoute =

  Platform.isIOS && !ignoreIOS
      ? CupertinoPageRoute(builder: (context) {
    return item;
  },) :
  PageRouteBuilder(
      transitionsBuilder:
      fade?fadeTransition:
      slideUp?slideUpTransition:
      transitionBuilder??
          slideTransition,
      transitionDuration: transitionDuration??const Duration(milliseconds: 300),
      opaque: opaque,
      pageBuilder: (context, _, __) {
        return item;
      });

  if(replace){
    Navigator.pushReplacement(
        context,
        pageRoute).then((_) {
      if (_ != null) {
        if (result != null) result(_);
      }
    });
    return;
  }
  Navigator.push(
      context,
      pageRoute).then((_) {
    if (_ != null) {
      if (result != null) result(_);
    }
  });

}



