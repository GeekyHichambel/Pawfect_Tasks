import 'dart:async';
import 'dart:math';
import 'package:PawfectTasks/Components/NotLoggedIn.dart';
import 'package:PawfectTasks/Components/OutlinedText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:PawfectTasks/Components/Animations.dart';
import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/Components/CustomBox.dart';
import 'package:PawfectTasks/GLOBALS.dart';
import 'package:PawfectTasks/db/database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:timezone/timezone.dart';
import '../Components/CustomTextField.dart';

class MyPet extends StatefulWidget{
  const MyPet({Key? key}) : super(key: key);
  @override
  _MyPetState createState() => _MyPetState();
}

class _MyPetState extends State<MyPet> with SingleTickerProviderStateMixin{
  final List<ImageProvider> imageProvider = [
    const CachedNetworkImageProvider('https://firebasestorage.googleapis.com/v0/b/pawfecttasks.appspot.com/o/gifs%2FDogIdle.gif?alt=media&token=eb663344-10c4-4c31-8b81-a982ca5be57d'),
    const CachedNetworkImageProvider('https://firebasestorage.googleapis.com/v0/b/pawfecttasks.appspot.com/o/gifs%2Frip.gif?alt=media&token=55dde51d-26a9-4b74-93c0-2dc6de3e69c7'),
  ];
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
      if(kDebugMode) print(nickN);
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

  Future<void> feedThePet(BuildContext context) async{
    try{
      final user = await DataBase.itemCollection?.child(Globals.user).get();
      double maximum = double.parse(user!.child('petFood').value.toString())*0.01;
      int labelValue = 0;
      if (maximum > 1.0){
        maximum = 1.0;
      }
      double value = 0.0;
      if(kDebugMode) print(maximum);

      Future<void> feeeed(itemRef, int Tofeed) async{
        final user = await DataBase.petsCollection?.child(Globals.user).get();
        final initialFood = itemRef?.child('petFood').value as int;
        final int hunger = user?.child('petStatus/labra/starvation').value as int;
        final int health = user?.child('petStatus/labra/health').value as int;
        int ToSpend = Tofeed;
        int newHunger=hunger;
        final int newFood;
        int newHealth=100;
        if (health < 100){
          newHealth = health + Tofeed;
          if (newHealth > 100){
            newHunger = hunger - (newHealth - 100);
          }
        }else {
          newHunger = hunger - Tofeed;
        }
        newHealth = newHealth.clamp(0, 100);
        newHunger = newHunger.clamp(0, 100);
        newFood = initialFood - ToSpend;
        await itemRef?.ref.update({
          'petFood' : newFood,
        });
        await user?.child('petStatus/labra').ref.update({
          'starvation' : newHunger,
          'health' : newHealth,
          'lastFed' : TZDateTime.now(getLocation('Asia/Kolkata')).toString(),
          'lastHunger' : newHunger,
        });
        getPetDetails();
      }
      await showDialog(context: context, builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState){
          return SizedBox(height: 300,
            child: AlertDialog(
              elevation: 0,
              scrollable: true,
              alignment: Alignment.center,
              contentPadding: const EdgeInsets.all(20),
              backgroundColor: AppTheme.colors.friendlyBlack,
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(16))),
              content: Column(
                children: [
                  Text('How much to feed?', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyWhite),),
                  const SizedBox(height: 20,),
                  Slider(value: value,
                      max: maximum,
                      inactiveColor: AppTheme.colors.friendlyWhite,
                      activeColor: AppTheme.colors.onsetBlue,
                      thumbColor: AppTheme.colors.onsetBlue,
                      onChanged: (newValue){
                        setState((){
                          value = double.parse(newValue.toStringAsFixed(2));
                          labelValue = (value*100).round();
                          if(kDebugMode) print(value);
                        });
                  }),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('$labelValue', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyWhite, fontSize: 16),),
                      const SizedBox(width: 2,),
                      Image.asset('assets/foodIcon.png', width: 18, height: 18,),
                    ],
                  )),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      loading? SpinKitThreeBounce(color: AppTheme.colors.onsetBlue,) :
                      ElevatedButton(onPressed: labelValue!=0? (){
                        setState(() {
                          loading = true;
                        });
                        feeeed(user, labelValue).then((_){
                          setState(() {
                            loading = false;
                          });
                          Navigator.of(context).pop();
                        });
                      } : (){

                      }, style: ButtonStyle(backgroundColor: labelValue!=0? MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyWhite) : const MaterialStatePropertyAll<Color>(Colors.white60)),
                          child: Text('Feed', style: TextStyle(color: labelValue!=0? Colors.green : Colors.green[600]),)),
                      ElevatedButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyWhite)),
                          child: const Text('Cancel', style: TextStyle(color: Colors.red),))
                    ],
                  )
                ],
              ),
            )
          ).animate(effects: [
            FadeEffect(duration: 200.ms, curve: Curves.fastLinearToSlowEaseIn),
            ScaleEffect(duration: 200.ms, curve: Curves.easeIn)
          ]);
        });
      });
  }catch (e){
      if (kDebugMode){
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
              elevation: 0,
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
                      loading? SpinKitThreeBounce(color: AppTheme.colors.onsetBlue,) :
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
      if (kDebugMode) print('Error in DB: $error');
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
    precacheImage(imageProvider[0], context);
    precacheImage(imageProvider[1], context);
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image(
                          image: imageProvider[Globals.currentImage],
                      ),
                    ),
                ),
            ) ,
            ),
            const SizedBox(height: 20,),
            cPetHp == 0? Text('Shame on you!!',style: TextStyle(color: AppTheme.colors.friendlyBlack, fontFamily: Globals.sysFont, fontSize: 18)) : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: (){
                  feedThePet(context);
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
                                        Text(cPetName.length>8? '${cPetName.substring(0,5)}...': cPetName, style: TextStyle(color: AppTheme.colors.friendlyWhite, fontFamily: Globals.sysFont, fontSize: 20),),
                                        const SizedBox(width: 10,),
                                        cPetHp == 0? const SizedBox.shrink() : IconButton(onPressed: (){
                                          openDialog(context);
                                        }, icon: const Icon(Icons.edit_rounded), color: AppTheme.colors.friendlyWhite)
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
                                            Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: OutlinedText(text: cPetHp == 0? '☠' : '$cPetHp', fillColor: cPetHp <= 20? Colors.red : cPetHp <=50? Colors.orange : cPetHp <= 80? Colors.yellow[700] : Colors.lightGreen, outlineColor: AppTheme.colors.friendlyWhite, strokeWidth: 1.5,),
                                                ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Image.asset('assets/hunger.png', width: 30, height: 30, fit: BoxFit.fill,),
                                            const SizedBox(height: 0,),
                                           Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: OutlinedText(text: cPetHp == 0? '☠' : '$cPetHunger', fillColor: cPetHunger <= 20? Colors.lightGreen : cPetHunger <=50? Colors.yellow[700] : cPetHunger <= 80? Colors.orange : Colors.red, outlineColor: AppTheme.colors.friendlyWhite, strokeWidth: 1.5,),
                                              ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Image.asset('assets/mood.png', width: 25, height: 25, fit: BoxFit.fill,),
                                            const SizedBox(height: 5,),
                                           Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: OutlinedText(text: cPetHp == 0? '☠' : cPetMood, fillColor: cPetMood == 'Happy'? Colors.pink : cPetMood == 'Normal' ? Colors.green : cPetMood == 'Sad' ? Colors.blueAccent : Colors.red, outlineColor: AppTheme.colors.friendlyWhite, strokeWidth: 1.5),
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
            const NotLoggedInWidget()
          ]
        )
      )
    );
  }
}