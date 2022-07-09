
import 'package:flutter/material.dart';
import 'package:gameplugin/src/assets/color_assets.dart';
import 'package:gameplugin/src/dialogs/list_dialog.dart';
import 'package:gameplugin/src/dialogs/message_dialog.dart';
import 'package:gameplugin/src/utils/transitions.dart';
import 'package:gameplugin/src/utils/widget_utils.dart';

void yesNoDialog(context, title, message, clickedYes,
    {bool cancellable = true, color = red0,clickYesText="Yes",clickNoText="Cancel"}) {
  Navigator.push(
      context,
      PageRouteBuilder(
          transitionsBuilder: slideTransition,
          opaque: false,
          pageBuilder: (context, _, __) {
            return MessageDialog(
              Icons.error,
              color,
              title,
              message,
              clickYesText,
              noText: clickNoText,
              cancellable: cancellable,
            );
          })).then((_) {
    if (_ != null) {
      if (_ == true) {
        clickedYes();
      }
    }
  });
}

showListDialog(context,List items, onSelected,
    {title, images, bool useTint = true,selections,bool returnIndex=false,
      bool singleSelection=false}){
  launchNewScreen(context,
      ListDialog(items,
        title: title, images: images,useTint: useTint,selections: selections,
        singleSelection: singleSelection,),result: (_){
        if(_ is List){
          onSelected(_);
        }else{
          onSelected(returnIndex?items.indexOf(_):_);
        }
      },opaque: false,
      transitionBuilder:slideUpTransition,ignoreIOS: true,
      transitionDuration: const Duration(milliseconds: 800));
}