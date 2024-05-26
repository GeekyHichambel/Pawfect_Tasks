import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import '../../Components/AppTheme.dart';
import '../../GLOBALS.dart';

class ThirdPage extends StatefulWidget{
  const ThirdPage({
    super.key,
  });

  @override
  ThirdPageState createState()=> ThirdPageState();
}

class ThirdPageState extends State<ThirdPage> with AutomaticKeepAliveClientMixin{
  static DateTime selectedDate = DateTime.now();
  static int selected = 1;
  DateTime minimumDate = DateTime.now();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context){
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 25, bottom: 0),
          child:  RichText(
              text: TextSpan(
                  text: '*', style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.w700),
                  children: [
                    TextSpan(text: 'Date', style: TextStyle(color: AppTheme.colors.friendlyBlack, fontFamily: Globals.sysFont, fontSize: 18, fontWeight: FontWeight.w700),),
                  ])),
        ),
        const SizedBox(height: 5,),
        SizedBox(
          height: 200,
          child: ScrollDatePicker(
            minimumDate: minimumDate,
            maximumDate: minimumDate.add(const Duration(days: 7)),
            selectedDate: selectedDate,
            onDateTimeChanged: (DateTime value) {
              setState(() {
                selectedDate = value;
              });
            },
            options: DatePickerOptions(backgroundColor: Colors.white.withOpacity(0.0)),
          ),
        ),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.workspace_premium_rounded, color: Globals.isPremium? AppTheme.colors.onsetBlue : AppTheme.colors.onsetBlue.withOpacity(0.5),),
                      Text('Repeat Task', style: TextStyle(color: Globals.isPremium? AppTheme.colors.friendlyBlack : AppTheme.colors.friendlyBlack.withOpacity(0.3), fontFamily: Globals.sysFont, fontSize: 18, fontWeight: FontWeight.w700),)
                    ],
                  ),
              const SizedBox(height: 5,),
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    border: Border.all(color: Globals.isPremium? AppTheme.colors.onsetBlue : AppTheme.colors.onsetBlue.withOpacity(0.5), strokeAlign: BorderSide.strokeAlignOutside)
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: selected==1? Globals.isPremium? AppTheme.colors.onsetBlue : AppTheme.colors.onsetBlue.withOpacity(0.5) : null,
                          border: Border(right: BorderSide(color: Globals.isPremium? AppTheme.colors.onsetBlue : AppTheme.colors.onsetBlue.withOpacity(0.5))),
                          borderRadius: selected==1? const BorderRadius.only(topLeft: Radius.circular(16.0),bottomLeft: Radius.circular(16.0)) : null,
                      ),
                      child: TextButton(onPressed: (){
                        if (Globals.isPremium) {
                          setState(() {
                            selected = 1;
                          });
                        }else{
                          GlobalVar.globalVar.showToast('This is a premium feature');
                        }
                      },style: const ButtonStyle(
                        // padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 10)),
                      ),
                        child: Text('1D' ,style: TextStyle(
                          fontFamily: Globals.sysFont,
                          color: Globals.isPremium? AppTheme.colors.complimentaryBlack : AppTheme.colors.complimentaryBlack.withOpacity(0.3),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        )),),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: selected==3? AppTheme.colors.onsetBlue : null,
                          border: Border(right: BorderSide(color: Globals.isPremium? AppTheme.colors.onsetBlue : AppTheme.colors.onsetBlue.withOpacity(0.5)))
                      ),
                      child: TextButton(onPressed: (){
                        if (Globals.isPremium) {
                          setState(() {
                            selected = 3;
                          });
                        }else{
                          GlobalVar.globalVar.showToast('This is a premium feature');
                        }
                      },style: const ButtonStyle(
                        // padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 10)),
                      ),
                        child: Text('3D' ,style: TextStyle(
                          fontFamily: Globals.sysFont,
                          color: Globals.isPremium? AppTheme.colors.complimentaryBlack : AppTheme.colors.complimentaryBlack.withOpacity(0.3),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        )),),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: selected==7? AppTheme.colors.onsetBlue : null,
                          border: Border(right: BorderSide(color: Globals.isPremium? AppTheme.colors.onsetBlue : AppTheme.colors.onsetBlue.withOpacity(0.5)))
                      ),
                      child: TextButton(onPressed: (){
                        if (Globals.isPremium) {
                          setState(() {
                            selected = 7;
                          });
                        }else{
                          GlobalVar.globalVar.showToast('This is a premium feature');
                        }
                      },style: const ButtonStyle(
                        // padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 10)),
                      ),
                        child: Text('1W' ,style: TextStyle(
                          fontFamily: Globals.sysFont,
                          color: Globals.isPremium? AppTheme.colors.complimentaryBlack : AppTheme.colors.complimentaryBlack.withOpacity(0.3),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        )),),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: selected==30? AppTheme.colors.onsetBlue : null,
                        borderRadius: selected==30? const BorderRadius.only(topRight: Radius.circular(16.0),bottomRight: Radius.circular(16.0)) : null,
                      ),
                      child: TextButton(onPressed: (){
                        if (Globals.isPremium){
                          setState(() {
                            selected = 30;
                          });
                        }else{
                          GlobalVar.globalVar.showToast('This is a premium feature');
                        }
                      },style: const ButtonStyle(
                        // padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 10)),
                      ),
                        child: Text('1M' ,style: TextStyle(
                          fontFamily: Globals.sysFont,
                          color: Globals.isPremium? AppTheme.colors.complimentaryBlack : AppTheme.colors.complimentaryBlack.withOpacity(0.3),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        )),),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Icon(Icons.info_outline_rounded, color: Globals.isPremium? AppTheme.colors.friendlyBlack : AppTheme.colors.friendlyBlack.withOpacity(0.3), size: 24,),
              const SizedBox(height: 5,),
              Text('Repeat your task over a course of time',style: TextStyle(
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