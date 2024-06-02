import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart' as flutter_animate;

import '../../Components/AppTheme.dart';
import '../../Components/CustomTextField.dart';
import '../../GLOBALS.dart';

class FirstPage extends StatefulWidget {
  final TextEditingController Tcontroller;
  final TextEditingController Dcontroller;

  const FirstPage({
    super.key,
    required this.Tcontroller,
    required this.Dcontroller,
  });

  @override
  FirstPageState createState() => FirstPageState();
}

class FirstPageState extends State<FirstPage> with AutomaticKeepAliveClientMixin{
  final FocusNode Tnode = FocusNode();
  final FocusNode Dnode = FocusNode();
  static IconData? currentIcon;
  static Color? currentColor;
  bool isTfocus = false;
  bool isDfocus = false;

  @override
  bool get wantKeepAlive => true;

  Future<void> iconPick(BuildContext context) async{
    ScrollController sIController = ScrollController();
    ScrollController sCController = ScrollController();

    List<IconData> icons = [
      Icons.gamepad_rounded,
      Icons.shopping_bag_rounded,
      Icons.access_alarm_rounded,
      Icons.laptop_chromebook_rounded,
      Icons.menu_book_rounded,
      Icons.fastfood_rounded,
      Icons.sports_basketball_rounded,
      Icons.sailing_rounded,
      Icons.home_max_rounded,
      Icons.question_answer_rounded,
      Icons.cake_rounded,
      Icons.connecting_airports_rounded,
      Icons.directions_car_filled_rounded,
      Icons.sports_gymnastics_rounded,
      Icons.groups_rounded,
      Icons.bed_rounded,
    ];
    List<Color> colors = [
      Colors.red,
      Colors.green,
      AppTheme.colors.onsetBlue,
      AppTheme.colors.pukeOrange,
      AppTheme.colors.lightBrown,
      Colors.purple,
      Colors.deepPurple,
      Colors.pink,
      Colors.lime,
    ];
    await showDialog(context: context, builder: (context){
      return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
        return SizedBox(
          height: 300,
          child: Stack(
            children: [AlertDialog(
              elevation: 0,
              scrollable: true,
              alignment: Alignment.center,
              contentPadding: const EdgeInsets.all(20.0),
              backgroundColor: AppTheme.colors.friendlyBlack,
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(16.0))),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text('Task Icon', style: TextStyle(color: AppTheme.colors.onsetBlue, fontFamily: Globals.sysFont, fontSize: 18, fontWeight: FontWeight.w700),),
                  const SizedBox(height: 10,),
                  Container(
                      decoration: BoxDecoration(
                        color: AppTheme.colors.friendlyWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      height: 100, child: ScrollbarTheme(
                    data: ScrollbarThemeData(
                      crossAxisMargin: 2,
                      mainAxisMargin: 8,
                      radius: const Radius.circular(16.0),
                      thumbVisibility: const MaterialStatePropertyAll<bool>(true),
                      trackVisibility: const MaterialStatePropertyAll<bool>(true),
                      thumbColor: MaterialStatePropertyAll<Color>(AppTheme.colors.blissCream),
                      trackColor: const MaterialStatePropertyAll<Color>(Colors.transparent),
                      trackBorderColor: const MaterialStatePropertyAll<Color>(Colors.transparent),
                    ),
                    child: Scrollbar(
                      radius: const Radius.circular(16.0),
                      controller: sIController,
                      child: GridView.builder(
                        controller: sIController,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 30.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemCount: icons.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              currentIcon = icons[index];
                              Navigator.of(context).pop(currentIcon);
                            },
                            child: Icon(icons[index],color: AppTheme.colors.friendlyWhite, size: 18,),
                          );
                        },
                      ),
                    ),
                  )),
                  const SizedBox(height: 20,),
                  Text('Task Color', style: TextStyle(color: AppTheme.colors.onsetBlue, fontFamily: Globals.sysFont, fontSize: 18, fontWeight: FontWeight.w700),),
                  const SizedBox(height: 10,),
                  Container(
                      decoration: BoxDecoration(
                        color: AppTheme.colors.friendlyWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      height: 50, child: ScrollbarTheme(
                    data: ScrollbarThemeData(
                      crossAxisMargin: 2,
                      mainAxisMargin: 8,
                      radius: const Radius.circular(16.0),
                      thumbVisibility: const MaterialStatePropertyAll<bool>(true),
                      trackVisibility: const MaterialStatePropertyAll<bool>(true),
                      thumbColor: MaterialStatePropertyAll<Color>(AppTheme.colors.blissCream),
                      trackColor: const MaterialStatePropertyAll<Color>(Colors.transparent),
                      trackBorderColor: const MaterialStatePropertyAll<Color>(Colors.transparent),
                    ),
                    child: Scrollbar(
                      scrollbarOrientation: ScrollbarOrientation.bottom,
                      radius: const Radius.circular(16.0),
                      controller: sCController,
                      child: GridView.builder(
                        controller: sCController,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 30.0,
                        ),
                        itemCount: colors.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: (){
                                currentColor = colors[index];
                                Navigator.of(context).pop(currentColor);
                              },
                              child: Container(height: 16, width: 16,
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: colors[index],
                                  shape: BoxShape.circle,
                                ),)
                          );
                        },
                      ),
                    ),
                  )),
                ]),),
          ]),
        );
      }).animate(effects: [
        flutter_animate.FadeEffect(duration: 200.ms, curve: Curves.fastLinearToSlowEaseIn),
        flutter_animate.ScaleEffect(duration: 200.ms, curve: Curves.easeIn)
      ]);
    });
  }

  @override
  void initState(){
    super.initState();
    Tnode.addListener(() {
      if (Tnode.hasFocus){
        setState(() {
          isTfocus = true;
        });
      }else{
        isTfocus = false;
      }
    });
    Dnode.addListener(() {
      if (Dnode.hasFocus){
        setState(() {
          isDfocus = true;
        });
      }else{
        isDfocus = false;
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child:Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(25),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: currentColor ?? AppTheme.colors.onsetBlue,
                    shape: BoxShape.circle,
                    boxShadow: const [BoxShadow(
                      color: Colors.transparent,
                      offset: Offset(0, 0),
                      blurRadius: 30.0,
                    ),
                    ]
                ),
                child: Center(
                  child: currentIcon == null ? Text('T',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Globals.sysFont,
                      fontSize: 40,
                      color: AppTheme.colors.friendlyWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ) : Icon(currentIcon, size: 40, color: AppTheme.colors.friendlyWhite,),
                ),
              ),
              Positioned(
                  bottom: 15,
                  right: 15,
                  child: ElevatedButton(
                    onPressed: () {
                      iconPick(context).then((_){
                        setState((){
                          currentIcon = currentIcon;
                          currentColor = currentColor;
                        });
                      });
                    },
                    style: ButtonStyle(
                      shape: const MaterialStatePropertyAll<OutlinedBorder>(CircleBorder(side: BorderSide())),
                      backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyBlack),
                      padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.zero),
                    ),
                    child: Icon(CupertinoIcons.pencil, color: AppTheme.colors.friendlyWhite,size: 16,),))
            ],
          ),
        ),
        const SizedBox(height: 20,),
        RichText(
            text: TextSpan(
                text: '*', style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.w700),
                children: [
                  TextSpan(text: 'Task Name', style: TextStyle(color: AppTheme.colors.friendlyBlack, fontFamily: Globals.sysFont, fontSize: 18, fontWeight: FontWeight.w700),),
                ])),
        CustomTextField(
            type: Globals.focused,
            labelText: '',
            focusNode: Tnode,
            controller: widget.Tcontroller,
            maxLength: 15,
            labelColor: AppTheme.colors.onsetBlue,
            cursorColor: Colors.grey,
            bgColor: AppTheme.colors.friendlyWhite.withOpacity(0.6),
            textColor: AppTheme.colors.friendlyBlack,
            borderColor: AppTheme.colors.onsetBlue.withOpacity(0.6),
            fontSize: 16,
            obscureText: false),
        const SizedBox(height: 20,),
        Text('Description', style: TextStyle(color: AppTheme.colors.friendlyBlack, fontFamily: Globals.sysFont, fontSize: 18, fontWeight: FontWeight.w700),),
        CustomTextField(
            type: Globals.focused,
            focusNode: Dnode,
            controller: widget.Dcontroller,
            maxLines: 5,
            maxLength: 150,
            labelText: '',
            labelColor: AppTheme.colors.onsetBlue,
            cursorColor: Colors.grey,
            bgColor: AppTheme.colors.friendlyWhite.withOpacity(0.6),
            textColor: AppTheme.colors.friendlyBlack,
            borderColor: AppTheme.colors.onsetBlue.withOpacity(0.6),
            fontSize: 16,
            obscureText: false),
      ],
    );
  }
}