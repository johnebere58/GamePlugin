
import 'package:flutter/material.dart';
import '../assets/color_assets.dart';

class MyCheckBox extends StatefulWidget {

  final Function? onChecked;
  final bool selected;
  final double size;
  final Color boxColor;
  final Color checkColor;
  final Color iconColor;
  const MyCheckBox({this.onChecked,this.selected= false,this.size=20.0,
    this.checkColor=blue0,this.boxColor=default_white,this.iconColor=white,Key? key}):super(key:key);

   @override
   _MyCheckBoxState createState() => _MyCheckBoxState();
 }

 class _MyCheckBoxState extends State<MyCheckBox> {

  late Function onChecked;
  late bool selected;
  late double size;
  late Color boxColor;
  late Color checkColor;
  late Color iconColor;
  @override
  void initState() {
    onChecked = widget.onChecked!;
    selected = widget.selected;
    size = widget.size;
    boxColor = widget.boxColor;
    checkColor = widget.checkColor;
    iconColor = widget.iconColor;
    super.initState();
  }

   @override
   Widget build(BuildContext context) {
     return GestureDetector(
       onTap: (){
         onChecked(!selected);
       },

       child: Container(//duration: Duration(milliseconds: 600),
         padding: const EdgeInsets.all(2),
         decoration: BoxDecoration(
             shape: BoxShape.circle,
             color: selected?transparent:boxColor.withOpacity(.3),
             border:
             Border.all(color:checkColor, width: 2)
         ),
         child: AnimatedContainer(duration: const Duration(milliseconds: 600),
           width: size,
           height: size,
           margin: const EdgeInsets.all(.5),
           decoration: BoxDecoration(
             shape: BoxShape.circle,
             color: selected ? checkColor : transparent,
           ),
           child: Icon(
             Icons.check,
             size: size-5,
             color: !selected?transparent:iconColor,
           ),
         ),
       ),
     );
   }

   checkBox(bool selected,{double size=20,checkColor=blue0,iconColor=white,boxColor=default_white,
     onChecked}){
     return GestureDetector(
       onTap: onChecked==null?null:(){
         onChecked(!selected);
       },

       child: Container(
         padding: const EdgeInsets.all(2),
         decoration: BoxDecoration(
             shape: BoxShape.circle,
             color: selected?transparent:boxColor.withOpacity(.3),
             border:
             Border.all(color:checkColor, width: 2)
         ),
         child: AnimatedContainer(duration: const Duration(milliseconds: 600),
           width: size,
           height: size,
           margin: const EdgeInsets.all(.5),
           decoration: BoxDecoration(
             shape: BoxShape.circle,
             color: selected ? checkColor : transparent,
           ),
           child: Icon(
             Icons.check,
             size: size-5,
             color: !selected?transparent:iconColor,
           ),
         ),
       ),
     );
   }
 }
