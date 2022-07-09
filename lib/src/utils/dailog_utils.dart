
import 'package:flutter/material.dart';
import 'package:gameplugin/src/assets/color_assets.dart';
import 'package:gameplugin/src/dialogs/message_dialog.dart';
import 'package:gameplugin/src/utils/transitions.dart';

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
