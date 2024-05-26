import 'dart:ui';

import 'package:PawfectTasks/Components/CustomAppBar.dart';
import 'package:PawfectTasks/Components/WebOpenerIcon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../Components/Animations.dart';
import '../../Components/AppTheme.dart';
import '../../GLOBALS.dart';

class aboutUs extends StatefulWidget{
  const aboutUs({Key? key}) : super(key: key);
  @override
  aboutUsState createState() => aboutUsState();
}

class aboutUsState extends State<aboutUs> with SingleTickerProviderStateMixin{
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      bottomSheet: BottomSheet(
        backgroundColor: AppTheme.colors.friendlyWhite,
        elevation: 0.0,
        enableDrag: false,
        onClosing: () {  },
        builder: (BuildContext context) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WebOpenerIcon(imagePath: 'assets/icons/insta.png', link: 'https://www.instagram.com/pawfecttasks/'),
                WebOpenerIcon(imagePath: 'assets/icons/X.png', link: 'https://www.x.com/PawfectTasks'),
                WebOpenerIcon(imagePath: 'assets/icons/discord.png', link: 'https://www.discord.gg/YvRby4YdFg'),
                WebOpenerIcon(imagePath: 'assets/icons/youtube.png', link: 'https://www.youtube.com/@PawfectTasks'),
              ]
            ),
          );
        },
      ),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomAppBar(name: 'About'),
      ),
      backgroundColor: AppTheme.colors.friendlyWhite,
      body: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
          child: SingleChildScrollView(
              physics: const RangeMaintainingScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInAnimation(delay: 1,
                      child: Text('Version' ,style: TextStyle(
                        fontFamily: Globals.sysFont,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colors.onsetBlue,
                        fontSize: 16,)),),
                    const SizedBox(height: 5,),
                    FadeInAnimation(delay: 1,
                      child: Text(Globals.VERSION ,style: TextStyle(
                        fontFamily: Globals.sysFont,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colors.friendlyBlack,
                        fontSize: 12,)),),
                    const SizedBox(height: 15,),
                    FadeInAnimation(delay: 1.25,child: Icon(Icons.info_outline_rounded, color: AppTheme.colors.blissCream, size: 24,)),
                    const SizedBox(height: 5,),
                    FadeInAnimation(
                      delay: 1.25,
                      child: Text('Current Version code' ,style: TextStyle(
                        fontFamily: Globals.sysFont,
                        color: AppTheme.colors.blissCream,
                        fontSize: 12,
                      )),
                    ),
                    const SizedBox(height: 20,),
                    FadeInAnimation(delay: 1.5,
                      child: Text('Check for updates' ,style: TextStyle(
                        fontFamily: Globals.sysFont,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colors.onsetBlue,
                        fontSize: 16,)),),
                    const SizedBox(height: 15,),
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: FadeInAnimation(
                        delay: 1.5,
                        child: loading? SpinKitThreeBounce(color: AppTheme.colors.onsetBlue,) : Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                              border: Border.all(color: AppTheme.colors.onsetBlue, strokeAlign: BorderSide.strokeAlignOutside)
                          ),
                          child: TextButton(onPressed: (){
                            setState(() {
                              loading = true;
                            });
                            Globals.checkUpdates(context).then((_){
                              setState(() {
                                loading = false;
                              });
                            });
                          },style: const ButtonStyle(
                            padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 20)),
                          ),
                            child: Text('Check' ,style: TextStyle(
                              fontFamily: Globals.sysFont,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.colors.complimentaryBlack,
                              fontSize: 12,
                            )),),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    CheckboxListTile(value: Globals.autoUpdateCheck, onChanged: (val) async{
                      setState(() {
                        Globals.autoUpdateCheck = val!;
                      });
                      await Globals.prefs.write(key: 'autoUpdateCheck', value: Globals.autoUpdateCheck.toString());
                    },
                      title: Text('Automatic check on startup', style: TextStyle(
                        fontFamily: Globals.sysFont,
                        color: AppTheme.colors.friendlyBlack,
                        fontSize: 12,
                      )),
                      contentPadding: const EdgeInsets.all(0.0),
                      checkColor: AppTheme.colors.onsetBlue,
                    ),
                    const SizedBox(height: 15,),
                    FadeInAnimation(delay: 1.75,child: Icon(Icons.info_outline_rounded, color: AppTheme.colors.blissCream, size: 24,)),
                    const SizedBox(height: 5,),
                    FadeInAnimation(
                      delay: 1.75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Check for any available updates' ,style: TextStyle(
                            fontFamily: Globals.sysFont,
                            color: AppTheme.colors.blissCream,
                            fontSize: 12,
                          )),
                          const SizedBox(height: 20,),
                          RichText(text: TextSpan(
                            style: TextStyle(
                              fontFamily: Globals.sysFont,
                              color: AppTheme.colors.blissCream,
                              fontSize: 12,
                            ),
                            children: const [
                              TextSpan(text: 'Note:\n\n', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                              TextSpan(text: '- Before you update the app, make sure that you have enabled the permission'),
                              TextSpan(text: ' \'Download from unknown sources\' ', style: TextStyle(fontWeight: FontWeight.w900)),
                              TextSpan(text: 'for this app'),
                              TextSpan(text: '\n\n- You can\'t rollback once you update the app')
                            ]
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),
                    FadeInAnimation(delay: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.of(context).pushNamed('/S>policy');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text('Privacy Policy' ,style: TextStyle(
                                fontFamily: Globals.sysFont,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.colors.onsetBlue,
                                fontSize: 16,)),
                              Icon(CupertinoIcons.arrow_right_circle, color: AppTheme.colors.friendlyBlack
                                ,),
                            ],
                          ),
                        ),
                      ),),
                    const SizedBox(height: 20,),
                  ])))
    ));
  }
}