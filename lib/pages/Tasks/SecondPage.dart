import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../Components/AppTheme.dart';
import '../../Components/CustomTextField.dart';
import '../../Components/OutlinedText.dart';
import '../../GLOBALS.dart';

class SecondPage extends StatefulWidget{
  final TextEditingController DUcontroller;
  final GlobalKey<ScaffoldState> Skey;

  const SecondPage({
  super.key,
    required this.DUcontroller,
    required this.Skey,
  });

  @override
  SecondPageState createState()=> SecondPageState();
}

class SecondPageState extends State<SecondPage> with AutomaticKeepAliveClientMixin{
  final FocusNode DUnode = FocusNode();
  static Duration startTime = const Duration();
  static Duration duuration = const Duration(minutes: 0);
  static bool reminder = false;
  bool reminder_valid = true;

  @override
  bool get wantKeepAlive => true;

  Future <void> SetDuration() async{
    widget.Skey.currentState?.showBottomSheet(elevation: 5, shape:  RoundedRectangleBorder(side: BorderSide(width: 0.2,color: AppTheme.colors.complimentaryBlack),borderRadius: const BorderRadius.all(Radius.circular(10))),backgroundColor: AppTheme.colors.friendlyWhite,(context) {
      return SizedBox(
          height: 240,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child:  CupertinoTimerPicker(onTimerDurationChanged: (duration){
                      duuration = duration;
                    },
                    mode: CupertinoTimerPickerMode.hm,
                    initialTimerDuration: const Duration(minutes: 0),
                    minuteInterval: 15,
                  ),
          ),
          const SizedBox(height: 10.0,),
          GestureDetector(
          onTap: (){
                      final int hours = duuration.inHours;
                      final int minutes = hours == 0 ? duuration.inMinutes : duuration.inMinutes - (hours * 60) ;
                      setState(() {
                        if (hours == 0){
                          widget.DUcontroller.text = '$minutes min.';
                        }else{
                          widget.DUcontroller.text = '$hours hours $minutes min.';
                        }
                      });
                      Navigator.of(context).pop();
                    },
                    child: OutlinedText(text: 'Done', fillColor: Colors.green, outlineColor: AppTheme.colors.friendlyBlack,strokeWidth: 1,)),
                const SizedBox(height: 10.0,),
                GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: OutlinedText(text: 'Cancel', fillColor: Colors.red, outlineColor: AppTheme.colors.friendlyBlack,strokeWidth: 1,)),
              ],
            ),
          )
      );
    });
  }

  @override
  Widget build(BuildContext context){
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 25, bottom: 25),
          child:  RichText(
              text: TextSpan(
                  text: '*', style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.w700),
                  children: [
                    TextSpan(text: 'Time', style: TextStyle(color: AppTheme.colors.friendlyBlack, fontFamily: Globals.sysFont, fontSize: 18, fontWeight: FontWeight.w700),),
                  ])),
        ),
        SizedBox(
          height: 200,
          child: CupertinoTimerPicker(onTimerDurationChanged: (duration){
              startTime = duration;
            },
            mode: CupertinoTimerPickerMode.hm,
          ),
        ),
        const SizedBox(height: 20,),
        Text('Duration', style: TextStyle(color: AppTheme.colors.friendlyBlack, fontFamily: Globals.sysFont, fontSize: 18, fontWeight: FontWeight.w700),),
        const SizedBox(height: 5,),
        CustomTextField(
            type: Globals.focused,
            focusNode: DUnode,
            suffixIcon: TextButton(
              onPressed: (){
                SetDuration();
              }, child: Text('Set', style: TextStyle(color: AppTheme.colors.onsetBlue, fontFamily: Globals.sysFont, fontSize: 16, fontWeight: FontWeight.w700),),
            ),
            controller: widget.DUcontroller,
            maxLines: 1,
            labelText: '',
            labelColor: AppTheme.colors.onsetBlue,
            cursorColor: Colors.grey,
            bgColor: AppTheme.colors.friendlyWhite.withOpacity(0.6),
            textColor: AppTheme.colors.onsetBlue,
            borderColor: AppTheme.colors.friendlyBlack.withOpacity(0.6),
            fontSize: 16,
            readOnly: true,
            obscureText: false),
        const SizedBox(height: 20,),
        GestureDetector(
          onTap: Globals.isPremium? (){
            //nothing
          } : (){
            GlobalVar.globalVar.showToast('This is a premium feature');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.workspace_premium_rounded, color: Globals.isPremium? AppTheme.colors.onsetBlue : AppTheme.colors.onsetBlue.withOpacity(0.5),),
                      Text('Remind Me', style: TextStyle(color: Globals.isPremium? AppTheme.colors.friendlyBlack : AppTheme.colors.friendlyBlack.withOpacity(0.3), fontFamily: Globals.sysFont, fontSize: 18, fontWeight: FontWeight.w700),)
                    ],
                  ),
                  Switch(value: reminder, onChanged: (value){
                    if (Globals.isPremium) {
                      setState(() {
                        reminder = value;
                      });
                    }},
                    trackColor: MaterialStatePropertyAll(Globals.isPremium? AppTheme.colors.friendlyWhite.withOpacity(0.54) : AppTheme.colors.friendlyWhite.withOpacity(0.24)),
                    thumbColor: MaterialStatePropertyAll(Globals.isPremium? AppTheme.colors.onsetBlue : AppTheme.colors.onsetBlue.withOpacity(0.5)),
                    trackOutlineColor: MaterialStatePropertyAll(Globals.isPremium? AppTheme.colors.onsetBlue : AppTheme.colors.onsetBlue.withOpacity(0.5)),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Icon(Icons.info_outline_rounded, color: Globals.isPremium? AppTheme.colors.friendlyBlack : AppTheme.colors.friendlyBlack.withOpacity(0.3), size: 24,),
              const SizedBox(height: 5,),
              Text('Gives you a reminder beforehand so you don\'t miss your task',style: TextStyle(
                fontFamily: Globals.sysFont,
                color: Globals.isPremium? AppTheme.colors.friendlyBlack : AppTheme.colors.friendlyBlack.withOpacity(0.3),
                fontSize: 12,
              )),
            ],
          ),
        ),
      ],
    );
  }
}