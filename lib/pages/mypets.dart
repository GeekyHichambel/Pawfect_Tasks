import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gif/gif.dart';
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
  late GifController controller;
  late String cPetName = 'Labra';
  late int cPetHp = 100;
  late int cPetHunger = 0;
  late String cPetMood = 'Happy';
  final TextEditingController NameC = TextEditingController();
  bool loading = false;
  bool isLoaded = false;

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
        setState(() {
          cPetName = nickname!;
          cPetHp = hp;
          cPetHunger = hunger;
          cPetMood = mood!;
        });
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
              elevation: 5,
              alignment: Alignment.center,
              contentPadding: const EdgeInsets.all(20.0),
              backgroundColor: AppTheme.colors.complimentaryBlack,
              shadowColor: AppTheme.colors.blissCream,
              shape: const RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(16.0))),
              content: Column(
                children: [
                  Text('Name your buddy!', style: TextStyle(fontFamily: Globals.sysFont),),
                  const SizedBox(height: 20,),
                  CustomTextField(
                    inputType: TextInputType.name,
                    fontSize: 16.0,
                    controller: NameC,
                    labelColor: AppTheme.colors.onsetBlue,
                    bgColor: AppTheme.colors.blissCream,
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
                      }, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.gloryBlack)),
                          child: const Text('Save', style: TextStyle(color: Colors.green),)),
                      ElevatedButton(onPressed: (){
                        NameC.clear();
                        Navigator.of(context).pop();
                      }, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.gloryBlack)),
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

  @override
  void initState(){
    super.initState();
    controller = GifController(vsync: this);
    if (mounted) {
      getPetDetails();
    }
  }

  @override
  void didChangeDependencies(){
    GlobalVar.globalVar.loadImages('assets/pets/labrador/idle_dog.gif', context).then((_){
      setState(() {
        isLoaded = true;
      });
    });
    super.didChangeDependencies();
}

  @override
  void dispose(){
    NameC.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 30,vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Center(
                child: isLoaded? CustomBox(
                    color: AppTheme.colors.complimentaryBlack,
                    shadow: AppTheme.colors.blissCream,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Gif(
                        image: const AssetImage('assets/pets/labrador/idle_dog.gif'),
                        controller: controller,
                        autostart: Autostart.no,
                        placeholder: (context) => CircularProgressIndicator(color: AppTheme.colors.onsetBlue,),
                        onFetchCompleted: (){
                          controller.reset();
                          controller.loop();
                        },
                      ),
                    )
                ) : CircularProgressIndicator(color: AppTheme.colors.onsetBlue,)
            ) ,
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: (){

                }, style: ButtonStyle(
                    fixedSize: const MaterialStatePropertyAll(Size(65,65)),
                  backgroundColor: MaterialStatePropertyAll(AppTheme.colors.blissCream),
                  elevation: const MaterialStatePropertyAll(5),
                  padding: const MaterialStatePropertyAll(EdgeInsetsDirectional.all(16.0)),
                  shape: const MaterialStatePropertyAll<OutlinedBorder>(CircleBorder(
                    side: BorderSide.none,
                  ))
                ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Image.asset('assets/feed.png', color: AppTheme.colors.onsetBlue,),),
                    Text('Feed', style: TextStyle(color: AppTheme.colors.onsetBlue, fontFamily: Globals.sysFont, fontSize: 8),),
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
                    backgroundColor: MaterialStatePropertyAll(AppTheme.colors.blissCream),
                    elevation: const MaterialStatePropertyAll(5),
                    padding: const MaterialStatePropertyAll(EdgeInsetsDirectional.all(16.0)),
                    shape: const MaterialStatePropertyAll<OutlinedBorder>(CircleBorder(
                      side: BorderSide.none,
                    ))
                ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Image.asset('assets/interact.png', color: AppTheme.colors.onsetBlue),),
                        Text('Interact', style: TextStyle(color: AppTheme.colors.onsetBlue, fontFamily: Globals.sysFont, fontSize: 8),),
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
            Text(getTip(), style: TextStyle(color: AppTheme.colors.blissCream, fontFamily: Globals.sysFont),).animate(
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
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(cPetName, style: TextStyle(color: Colors.white, fontFamily: Globals.sysFont, fontSize: 20),),
                                        const SizedBox(width: 10,),
                                        IconButton(onPressed: (){
                                          openDialog(context);
                                        }, icon: const Icon(Icons.edit_rounded), color: AppTheme.colors.pleasingWhite)
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
                                            Text('$cPetHp', style: TextStyle(color: cPetHp <= 20? Colors.red : cPetHp <=50? Colors.orange : cPetHp <= 80? Colors.yellow : Colors.lightGreen,  fontFamily: Globals.sysFont),),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Image.asset('assets/hunger.png', width: 25, height: 25, fit: BoxFit.fill,),
                                            const SizedBox(height: 5,),
                                            Text('$cPetHunger', style: TextStyle(color: cPetHunger <= 20? Colors.lightGreen : cPetHp <=50? Colors.yellow : cPetHp <= 80? Colors.orange : Colors.red, fontFamily: Globals.sysFont),),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Image.asset('assets/mood.png', width: 30, height: 30, fit: BoxFit.fill,),
                                            const SizedBox(height: 0,),
                                            Text(cPetMood, style: TextStyle(color: cPetMood == 'Happy'? Colors.pink : cPetMood == 'Normal' ? Colors.lightGreen : cPetMood == 'Sad' ? Colors.blueAccent : Colors.red, fontFamily: Globals.sysFont),),
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
          ],
        )
      )
    );
  }
}