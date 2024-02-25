import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:PawfectTasks/Components/Animations.dart';
import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/Components/CustomBox.dart';
import 'package:PawfectTasks/GLOBALS.dart';
import 'package:PawfectTasks/db/database.dart';

import '../Components/CustomTextField.dart';

class MyPet extends StatefulWidget{
  const MyPet({Key? key}) : super(key: key);
  @override
  _MyPetState createState() => _MyPetState();
}

class _MyPetState extends State<MyPet> with SingleTickerProviderStateMixin{
  final ImageProvider imageProvider = const CachedNetworkImageProvider('https://media.discordapp.net/attachments/767980613960990727/1211227145251196969/idle_dog.gif?ex=65ed6e2e&is=65daf92e&hm=d811b6949d85bc3cd9bfae8b5107eea40f67a043f8a34788c058435f96f3b682&=&width=550&height=550');
  late String cPetName = 'Labra';
  late int cPetHp = 100;
  late int cPetHunger = 0;
  late String cPetMood = 'Happy';
  final TextEditingController NameC = TextEditingController();
  bool loading = false;

  String getTip(){
    Random random = Random();
    List<String> tips = [
      'Be wary of your pet\'s condition',
      'Keep your friend happy and he shall make you happy',
      'Don\'t forget to feed your friend on time',
      'Stay productive unless you wanna account for the loss of your mate'
    ];
    int randIndex = random.nextInt(tips.length);
    return tips[randIndex];
  }

  void getPetDetails() async{
    if (Globals.LoggedIN) {
      final user = await DataBase.petsCollection?.child(Globals.user).get();
      String? nickname = user?.child('petStatus/labra/nickname').value.toString();
      int? hp = user?.child('petStatus/labra/health').value as int;
      int? hunger = user?.child('petStatus/labra/starvation').value as int;
      String? mood = user?.child('petStatus/labra/mood').value.toString();
      if (cPetName != nickname || cPetHp != hp || cPetHunger != hunger || cPetMood != mood) {
        if (mounted) {
          setState(() {
            cPetName = nickname!;
            cPetHp = hp;
            cPetHunger = hunger;
            cPetMood = mood!;
          });
        }
      }
      if (cPetHunger > 0 || cPetHp < 100){
        if (cPetHp <= 100 && cPetHp >=  80){
          if (cPetHunger > 0 && cPetHunger <= 20){
           mood = 'Happy';
          }else if (cPetHunger > 20 && cPetHunger <= 50){
            mood = 'Normal';
          }else if (cPetHunger > 50 && cPetHunger <=80){
            mood = 'Sad';
          }else{
            mood = 'Angry';
          }
        }else if (cPetHp < 80 && cPetHp >= 50){
          mood = 'Normal';
        }else  if (cPetHp < 50 && cPetHp >= 20){
          mood = 'Sad';
        }else{
          mood = 'Angry';
        }
      }else{
        mood = 'Happy';
      }
      if (cPetMood != mood) {
        setState(() {
          cPetMood = mood!;
        });
      }
      await DataBase.petsCollection?.child(Globals.user).child('petStatus/labra').update({
        'mood' : mood,
      });
    }
  }
  Future<void> nameChange() async{
    try {
      String nickN = NameC.text;
      if (nickN.isEmpty) {
        GlobalVar.globalVar.showToast('NickName can\'t be empty');
        throw Exception('NickName can\'t be empty');
      }
      await DataBase.petsCollection?.child(Globals.user).child('petStatus/labra').update({
        'nickname' : nickN,
      });
      setState(() {
        cPetName = nickN;
        if(kDebugMode) {
          print(cPetName);
        }
      });
    }catch (e){
      if(kDebugMode){
        print('Error: $e');
      }
    }
  }

  Future<void> openDialog(BuildContext context) async{
    await showDialog(
        context: context, builder: (context){
       return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return SizedBox(height: 300,
            child: AlertDialog(
              scrollable: true,
              alignment: Alignment.center,
              contentPadding: const EdgeInsets.all(20.0),
              backgroundColor: AppTheme.colors.friendlyBlack,
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(16.0))),
              content: Column(
                children: [
                  Text('Name your buddy!', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyWhite),),
                  const SizedBox(height: 20,),
                  CustomTextField(
                    inputType: TextInputType.name,
                    fontSize: 16.0,
                    controller: NameC,
                    labelColor: AppTheme.colors.onsetBlue,
                    bgColor: AppTheme.colors.friendlyWhite,
                    cursorColor: AppTheme.colors.pleasingWhite,
                    textColor: AppTheme.colors.onsetBlue,
                    borderColor: AppTheme.colors.onsetBlue, obscureText: false,
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      loading? CircularProgressIndicator(color: AppTheme.colors.onsetBlue,) :
                      ElevatedButton(onPressed: (){
                        setState(() {
                          loading = true;
                        });
                        nameChange().then((_){
                          setState(() {
                            loading = false;
                          });
                          NameC.clear();
                          Navigator.of(context).pop();
                        });
                      }, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyWhite)),
                          child: const Text('Save', style: TextStyle(color: Colors.green),)),
                      ElevatedButton(onPressed: (){
                        NameC.clear();
                        Navigator.of(context).pop();
                      }, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyWhite)),
                          child: const Text('Cancel', style: TextStyle(color: Colors.red),))
                    ],
                  )
                ],
              ),
            ),
          ).animate(effects: [
            FadeEffect(duration: 200.ms, curve: Curves.fastLinearToSlowEaseIn),
            ScaleEffect(duration: 200.ms, curve: Curves.easeIn)
          ]);
        }
      );
    });
  }

  void setupListener() {
    DataBase.petsCollection?.child(Globals.user).child('petStatus').onValue.listen((event) async {
      if (event.snapshot.value != null){
        final user = await DataBase.petsCollection?.child(Globals.user).get();
        setState(() {
          cPetName = user!.child('petStatus/labra/nickname').value.toString();
          cPetHp = user.child('petStatus/labra/health').value as int;
          cPetHunger = user.child('petStatus/labra/starvation').value as int;
          cPetMood = user.child('petStatus/labra/mood').value.toString();
        });
      }
    }, onError: (error){
      if (kDebugMode) print('Error in DB: $e');
    });
  }

  @override
  void initState(){
    super.initState();
    if (mounted) {
      getPetDetails();
      setupListener();
    }
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
}

  @override
  void dispose(){
    NameC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    precacheImage(imageProvider, context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 30,vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: Globals.LoggedIN? [
             Expanded(child: Center(
                child: CustomBox(
                    color: AppTheme.colors.friendlyWhite,
                    border: Border(
                        top: BorderSide(color: AppTheme.colors.blissCream, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                        left: BorderSide(color: AppTheme.colors.blissCream, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                        right: BorderSide(color: AppTheme.colors.blissCream, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                        bottom: BorderSide(color: AppTheme.colors.blissCream, width: 5.0, strokeAlign: BorderSide.strokeAlignInside)),
                    shadow: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Image(
                          image: imageProvider,
                        )
                      ),
                    )
                ),
            ) ,
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: (){

                }, style: ButtonStyle(
                    fixedSize: const MaterialStatePropertyAll(Size(65,65)),
                    backgroundColor: MaterialStatePropertyAll(AppTheme.colors.onsetBlue),
                    elevation: const MaterialStatePropertyAll(5),
                    padding: const MaterialStatePropertyAll(EdgeInsetsDirectional.all(16.0)),
                    shape: MaterialStatePropertyAll<OutlinedBorder>(CircleBorder(
                      side: BorderSide(color: AppTheme.colors.onsetBlue, width: 2.5, strokeAlign: BorderSide.strokeAlignInside),
                    ))
                ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Image.asset('assets/feed.png', color: AppTheme.colors.friendlyWhite,),),
                    Text('Feed', style: TextStyle(color: AppTheme.colors.friendlyWhite, fontFamily: Globals.sysFont, fontSize: 7),),
                  ],
                )).animate(
                  effects: [
                    MoveEffect(delay: 800.ms,
                      begin: const Offset(-100, 0),
                      end: const Offset(0, 0),
                      curve: Curves.decelerate,
                    ),
                    VisibilityEffect(
                      delay: 500.ms,
                    ),
                    RotateEffect(
                      delay: 1.seconds,
                      duration: 800.ms,
                      begin: 0,
                      end: 1,
                      curve: Curves.decelerate,
                    ),
                  ]
                ),
                ElevatedButton(onPressed: (){

                }, style: ButtonStyle(
                    fixedSize: const MaterialStatePropertyAll(Size(65,65)),
                    backgroundColor: MaterialStatePropertyAll(AppTheme.colors.onsetBlue),
                    elevation: const MaterialStatePropertyAll(5),
                    padding: const MaterialStatePropertyAll(EdgeInsetsDirectional.all(16.0)),
                    shape: MaterialStatePropertyAll<OutlinedBorder>(CircleBorder(
                      side: BorderSide(color: AppTheme.colors.onsetBlue, width: 2.5),
                    ))
                ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Image.asset('assets/interact.png', color: AppTheme.colors.friendlyWhite,),),
                        Text('Interact', style: TextStyle(color: AppTheme.colors.friendlyWhite, fontFamily: Globals.sysFont, fontSize: 7),),
                      ],
                    )).animate(
                  effects: [
                    MoveEffect(delay: 800.ms,
                      begin: const Offset(100,0),
                      end: const Offset(0, 0),
                      curve: Curves.decelerate,
                    ),
                    VisibilityEffect(
                      delay: 500.ms,
                    ),
                    RotateEffect(
                      delay: 1.seconds,
                      duration: 800.ms,
                      begin: 0,
                      end: 1,
                      curve: Curves.decelerate,
                    ),
                  ]
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Text(getTip(), style: TextStyle(color: AppTheme.colors.friendlyBlack, fontFamily: Globals.sysFont), textAlign: TextAlign.center,).animate(
              onInit: (controller){
                controller.forward();
              },
                effects: [
                ScaleEffect(delay: 100.ms,
                            duration: 300.ms,
                            begin: const Offset(0, 0),
                            end: const Offset(1, 1),
                            curve: Curves.easeIn
                ),
                ScaleEffect(delay: 3.seconds,
                            duration: 300.ms,
                            begin: const Offset(1, 1),
                            end: const Offset(0, 0),
                            curve: Curves.easeOut
                ),
            ]),
            const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(child: FadeInAnimation(
                            delay: 1,
                            child: CustomBox(
                              color: AppTheme.colors.onsetBlue,
                              shadow: Colors.transparent,
                              border: Border(
                                  top: BorderSide(color: AppTheme.colors.darkOnsetBlue, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                                  left: BorderSide(color: AppTheme.colors.darkOnsetBlue, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                                  right: BorderSide(color: AppTheme.colors.darkOnsetBlue, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                                  bottom: BorderSide(color: AppTheme.colors.darkOnsetBlue, width: 5.0, strokeAlign: BorderSide.strokeAlignInside)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(cPetName, style: TextStyle(color: AppTheme.colors.friendlyWhite, fontFamily: Globals.sysFont, fontSize: 20),),
                                        const SizedBox(width: 10,),
                                        IconButton(onPressed: (){
                                          openDialog(context);
                                        }, icon: const Icon(Icons.edit_rounded), color: AppTheme.colors.blissCream)
                                      ],
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Image.asset('assets/hp.png', width: 25, height: 25, fit: BoxFit.fill,),
                                            const SizedBox(height: 5,),
                                            CustomBox(
                                                color: AppTheme.colors.friendlyWhite,
                                                shadow: Colors.transparent,
                                                child:  Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Text('$cPetHp', style: TextStyle(color: cPetHp <= 20? Colors.red : cPetHp <=50? Colors.orange : cPetHp <= 80? Colors.yellow : Colors.lightGreen,  fontFamily: Globals.sysFont,),),
                                                ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Image.asset('assets/hunger.png', width: 30, height: 30, fit: BoxFit.fill,),
                                            const SizedBox(height: 0,),
                                            CustomBox(
                                              color: AppTheme.colors.friendlyWhite,
                                              shadow: Colors.transparent,
                                              child:  Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: Text('$cPetHunger', style: TextStyle(color: cPetHunger <= 20? Colors.lightGreen : cPetHp <=50? Colors.yellow : cPetHp <= 80? Colors.orange : Colors.red, fontFamily: Globals.sysFont,),),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Image.asset('assets/mood.png', width: 25, height: 25, fit: BoxFit.fill,),
                                            const SizedBox(height: 5,),
                                            CustomBox(
                                              color: AppTheme.colors.friendlyWhite,
                                              shadow: Colors.transparent,
                                              child:  Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: Text(cPetMood, style: TextStyle(color: cPetMood == 'Happy'? Colors.pink : cPetMood == 'Normal' ? Colors.lightGreen : cPetMood == 'Sad' ? Colors.blueAccent : Colors.red, fontFamily: Globals.sysFont,),),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ))
                          ),
                ],
              ),
          ] : [
            Image.asset('assets/loginFirst.png', height: 200, width: 200, fit: BoxFit.fill,),
            const SizedBox(height: 20,),
            Center(child: Text('Kindly login first to access this section', style: TextStyle(fontWeight: FontWeight.bold,color: AppTheme.colors.friendlyBlack, fontFamily: Globals.sysFont, fontSize: 14)),),
          ],
        )
      )
    );
  }
}