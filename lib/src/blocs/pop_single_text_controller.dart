
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gameplugin/src/repository/repository.dart';
import 'package:gameplugin/src/models/ball_info.dart';
import 'package:gameplugin/src/models/text_data.dart';

class PopSingleTextController {

  static PopSingleTextController get instance => getIt<PopSingleTextController>();

  final StreamController<TextData> _streamController = StreamController.broadcast();

  Stream<TextData> get stream => _streamController.stream;

  void popText(Color textColor,String text,bool isCorrect){
    _streamController.add(TextData(textColor: textColor,text: text,isCorrect:isCorrect));
  }
  
  void popCorrect(){
    popText(Colors.blue, "Correct",true);
  }
  void popWrong(){
    popText(Colors.red, "Wrong",false);
  }
  
 }