import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gameplugin/src/assets/color_assets.dart';
import 'package:gameplugin/src/utils/widget_utils.dart';
import 'package:gameplugin/src/widgets/my_check_box.dart';

class ListDialog extends StatefulWidget {
  final String? title;
  final List items;
  final List? images;
  final bool useTint;
  final List? selections;
  final bool singleSelection;

  const ListDialog(this.items,
      {this.title,
        this.images,
        this.useTint = true,
        this.selections,
        this.singleSelection=false,Key? key }):super(key:key);

  @override
  _ListDialogState createState() => _ListDialogState();
}

class _ListDialogState extends State<ListDialog> {

  List selections = [];
  late bool multiple;
  bool showBack=false;
  bool hideUI=true;
  late List images;

  @override
  void initState() {
    super.initState();
    images = widget.images ?? [];
    multiple = widget.selections!=null;
    selections = widget.selections??[];

    Future.delayed(const Duration(milliseconds: 200),(){
      hideUI=false;
      setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 1000),(){
      showBack=true;
      setState(() {

      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: <Widget>[
      GestureDetector(
        onTap: () {
          closePage((){ Navigator.pop(context);});
        },
        child: AnimatedOpacity(
          opacity: showBack?1:0,duration: const Duration(milliseconds: 300),
          child: ClipRect(
              child:BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                  child: Container(
                    color: black.withOpacity(.7),
                  ))
          ),
        ),
      ),
      page()
    ]);
  }

  page() {
    return AnimatedOpacity(
      opacity: hideUI?0:1,duration: const Duration(milliseconds: 400),
      child: Center(
        child: Container(
        //   constraints: BoxConstraints(maxWidth: getScreenWidth(context)>500?500:double.infinity,
        // ),
          padding: const EdgeInsets.fromLTRB(60, 45, 60, 25),
          child: Card(
            clipBehavior: Clip.antiAlias,
            color: white,elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Stack(
              children: [
                Container(
                  height: 75,
//                  decoration: BoxDecoration(
//                    color: blue0,
//
//                  ),
                ),
                Container(
                  height: 80,
                  decoration: const BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100)
                      )
                  ),
                ),
//                Padding(
//                  padding: const EdgeInsets.all(4.0),
//                  child: Opacity(opacity: .3,child: Image.asset(ic_plain,height: 25,width: 25,)),
//                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if(widget.title!=null)Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          widget.title!,
                          style: textStyle(false, 16, blue0),
                        ),
                      ),
                      addSpace(5),
                      Flexible(fit: FlexFit.loose,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(

                              maxHeight: (MediaQuery.of(context).size.height / 2) +
                                  (MediaQuery.of(context).orientation ==
                                          Orientation.landscape
                                      ? 0
                                      : (MediaQuery.of(context).size.height / 5))),
                          child: Scrollbar(
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              itemBuilder: (context, position) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    position == 0
                                        ? Container()
                                        : addLine(
                                            .5, black.withOpacity(.1), 0, 0, 0, 0),
                                    GestureDetector(
                                      onTap: () {
                                        if(multiple){
                                          bool selected = selections.contains(widget.items[position]);
                                          if(selected){
                                            selections.remove(widget.items[position]);
                                          }else{
                                            if(widget.singleSelection){
                                              selections.clear();
                                            }
                                            selections.add(widget.items[position]);
                                          }
                                          setState(() {

                                          });
                                          return;
                                        }
                                        closePage((){ Navigator.of(context).pop(widget.items[position]); });

                                      },
                                      child: Container(
                                        color: white,
                                        width: double.infinity,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              images.isEmpty
                                                  ? Container()
                                                  : (images[position] is! String)
                                                      ? Icon(
                                                          images[position],
                                                          size: 20,
                                                          color: !widget.useTint
                                                              ? null
                                                              : blue0,
                                                        )
                                                      : Image.asset(
                                                          images[position],
                                                          width: 20,
                                                          height: 20,
                                                          color: !widget.useTint
                                                              ? null
                                                              : blue0,
                                                        ),
                                              images.isNotEmpty
                                                  ? addSpaceWidth(10)
                                                  : Container(),
                                              Flexible(
                                                flex:1,fit:FlexFit.tight,
                                                child: Text(
                                                  widget.items[position],
                                                  style: textStyle(
                                                      false, 16, black.withOpacity(.8)),
                                                ),
                                              ),
                                              if(multiple)addSpace(10),
                                              if(multiple)MyCheckBox(selected:selections.contains(widget.items[position]))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              itemCount: widget.items.length,
                              shrinkWrap: true,
                            ),
                          ),
                        ),
                      ),
//                addLine(.5, black.withOpacity(.1), 0, 0, 0, 0),
                      if (multiple && selections.isNotEmpty)
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
//                      width: double.infinity,
                              height: 40,
                              margin: const EdgeInsets.all(10),
                              child: TextButton(

                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
//                                      side: BorderSide(color: blue0,width: 1),
                                        borderRadius: BorderRadius.circular(25)),
                                    backgroundColor: blue0,
                                  ),
                                  onPressed: () {
                                    /*if(selections.isEmpty){
                                      toastInAndroid("Nothing Selected");
                                      return;
                                    }*/
                                    closePage((){ Navigator.pop(context,selections);});
                                  },
                                  child: Text(
                                    "OK",
                                    style: textStyle(true, 16, white),
                                  ))),
                        )
                      //gradientLine(alpha: .1)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  closePage(onClosed){
    showBack=false;
    setState(() {

    });
    Future.delayed(const Duration(milliseconds: 600),(){
      Future.delayed(const Duration(milliseconds: 100),(){
        hideUI=true;
        setState(() {});
      });
      onClosed();
    });
  }
}
