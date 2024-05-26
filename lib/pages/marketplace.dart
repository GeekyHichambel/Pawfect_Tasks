import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/GLOBALS.dart';
import 'package:PawfectTasks/db/database.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:timezone/timezone.dart';
import '../Components/Animations.dart';
import '../Components/CustomBox.dart';
import '../Components/NotLoggedIn.dart';

class ImageInfo {
  final String name;
  final Uint8List imageData;
  final int price;
  final int foodValue;
  final int hp;
  ImageInfo(this.name, this.imageData, this.price, this.foodValue, this.hp);
  ImageInfo.forFood(this.name, this.imageData, this.price, this.foodValue) : hp = 0;
  ImageInfo.forPet(this.name, this.imageData, this.price, this.hp) : foodValue = 0;
}

class MarketPlace extends StatefulWidget{
  const MarketPlace({Key? key}) : super(key: key);
  @override
  MarketPlaceState createState() => MarketPlaceState();
}

class MarketPlaceState extends State<MarketPlace>{
  var cPawCoin = ValueNotifier(0);
  var cPetFood = ValueNotifier(0);
  var loading = ValueNotifier(false);
  String filter = 'Food';
  
  List<CoolDropdownItem> item_list = [
    CoolDropdownItem(label: 'Food', value: 'Food', icon: Image.asset('assets/foodIcon.png', width: 30, height: 30,)),
    CoolDropdownItem(label: 'Pets', value: 'Pets', icon: Image.asset('assets/pets.png', width: 30, height: 30,)),
  ];
  final DropdownController _controller = DropdownController();
  
  
  void setupUpdateListener(){
    DataBase.itemCollection?.child(Globals.user).child('pawCoin').onValue.listen((event) async { 
      if (event.snapshot.value != null){
        final user = await DataBase.itemCollection?.child(Globals.user).get();
          cPawCoin.value = user?.child('pawCoin').value as int;
      }
    });
    DataBase.itemCollection?.child(Globals.user).child('petFood').onValue.listen((event) async {
      if (event.snapshot.value != null){
        final user = await DataBase.itemCollection?.child(Globals.user).get();
          cPetFood.value = user?.child('petFood').value as int;
      }
    });
  }

  Future<List<ImageInfo>> fetchImages() async{
    try{
      List<ImageInfo> imageList = [];
      if (filter == 'Food') {
        final ListResult? result = await DataBase.marketFoodStorage?.listAll();
        if (result != null) {
          for (final Reference ref in result.items) {
            final String imageName = ref.name;
            final RegExp regExp = RegExp(
                r'^[0-9]\[(.*?)\]\[(\d+)\]\[(\d+)\]\.png$');
            final Match? match = regExp.firstMatch(imageName);
            if (match != null) {
              final String displayName = match.group(1)!;
              final int price = int.parse(match.group(2)!);
              final int foodValue = int.parse(match.group(3)!);
              final Uint8List? imageData = await ref.getData();
              if (imageData != null) {
                imageList.add(
                    ImageInfo.forFood(displayName, imageData, price, foodValue));
              }
            }
          }
        }
      }else if (filter == 'Pets'){
        final ListResult? result = await DataBase.marketPetStorage?.listAll();
        if (result != null){
          for (final Reference ref in result.items){
            final String imageName = ref.name;
            final RegExp regExp = RegExp(
                r'^[0-9]\[(.*?)\]\[(\d+)\]\[(\d+)\]\.png$'
            );
            final Match? match = regExp.firstMatch(imageName);
            if (match != null){
              final String displayName = match.group(1)!;
              final int price = int.parse(match.group(2)!);
              final int hp = int.parse(match.group(3)!);
              final Uint8List? imageData = await ref.getData();
              if (imageData != null){
                imageList.add(
                  ImageInfo.forPet(displayName, imageData, price, hp)
                );
              }
            }
          }
        }
      }
      return imageList;
    }catch(e){
      if (kDebugMode) print('Error fetching images: $e');
      return [];
    }
  }

Future<void> buyFood(BuildContext context,int foodValue, int cost) async{
    final user = await DataBase.itemCollection?.child(Globals.user).get();
    final int currentPawCoins = user?.child('pawCoin').value as int;
    final int currentPetFood = user?.child('petFood').value as int;
    if (currentPawCoins < cost){
      GlobalVar.globalVar.showToast('You don\'t have enough Paw Coins.');
      loading.value = false;
      return;
    }
    final newPawCoins = currentPawCoins - cost;
    final newPetFood = currentPetFood + foodValue;
    await DataBase.itemCollection?.child(Globals.user).update(
      {
        'pawCoin' : newPawCoins,
        'petFood' : newPetFood,
      }
    );
}

  Future<void> buyPet(BuildContext context,String petType, int cost) async{
    final user = await DataBase.itemCollection?.child(Globals.user).get();
    final int currentPawCoins = user?.child('pawCoin').value as int;
    if (currentPawCoins < cost){
      GlobalVar.globalVar.showToast('You don\'t have enough Paw Coins.');
      loading.value = false;
      return;
    }
    final newPawCoins = currentPawCoins - cost;
    await DataBase.itemCollection?.child(Globals.user).update(
        {
          'pawCoin' : newPawCoins,
        }
    );
    final TimeStamp = TZDateTime.now(getLocation('Asia/Kolkata'));
    await DataBase.petsCollection?.child(Globals.user).child('petStatus/labra').update(
      {
        'mood' : 'Happy',
        'health' : 100,
        'starvation' : 0,
        'lastHunger' : 0,
        'lastFed' : TimeStamp.toString(),
        'nickname' : 'Labra',
      }
    );
    Globals.currentImage = 0;
  }

Future<void> openDialog(BuildContext context, name, price, foodValue) async{
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Would you like to buy a $name?', style: TextStyle(color: AppTheme.colors.friendlyWhite, fontFamily: Globals.sysFont, fontSize: 12, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                    const SizedBox(height: 20,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: filter == 'Pets'? [
                          Text('$foodValue', style: TextStyle(color: AppTheme.colors.pinkyPink, fontFamily: Globals.sysFont, fontSize: 18),),
                          const SizedBox(width: 5,),
                          Image.asset('assets/hp.png', width: 24, height: 24,),
                        ] : [
                          Text('+$foodValue', style: TextStyle(color: AppTheme.colors.lightBrown, fontFamily: Globals.sysFont, fontSize: 18),),
                          const SizedBox(width: 5,),
                          Image.asset('assets/foodIcon.png', width: 24, height: 24,),
                        ],
                      ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Cost: $price', style: TextStyle(color: AppTheme.colors.friendlyWhite, fontFamily: Globals.sysFont, fontSize: 18),),
                        const SizedBox(width: 5,),
                        Image.asset('assets/pawCoin.png', width: 24, height: 24,),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ValueListenableBuilder(valueListenable: loading, builder: (context,value,child){
                          return value? SpinKitThreeBounce(color: AppTheme.colors.onsetBlue,) :  ElevatedButton(onPressed: (){
                          loading.value = true;
                          if (filter == 'Pets'){
                           buyPet(context, name, price).then((_){
                             loading.value = false;
                             Navigator.of(context).pop();
                           });
                          }else {
                            buyFood(context, foodValue, price).then((_) {
                              loading.value = false;
                              Navigator.of(context).pop();
                            });
                          }
                          }, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyWhite,)),
                          child: const Text('Hell Yeah!', style: TextStyle(color: Colors.green),));
                        }),
                        ElevatedButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyWhite)),
                            child: const Text('Nope', style: TextStyle(color: Colors.red),))
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
    if (mounted){
      setupUpdateListener();
    }
  }
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(padding: const EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: Globals.LoggedIN? [
            Text('Market Place', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.lightBrown,shadows: [
              Shadow(color: AppTheme.colors.blissCream, offset: Offset.fromDirection(1.0))
            ], fontSize: 22, fontWeight: FontWeight.w900, fontFeatures: const [
              FontFeature.caseSensitiveForms()
            ]),),
              const SizedBox(height: 20,),
              FadeInAnimation(delay: 1, child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CoolDropdown(
                      dropdownList: item_list,
                      controller: _controller,
                      dropdownOptions: const DropdownOptions(
                        width: 100,
                        duration: Duration(milliseconds: 100),
                      ),
                      dropdownItemOptions: DropdownItemOptions(
                        selectedBoxDecoration: BoxDecoration(color: AppTheme.colors.onsetBlue.withOpacity(0.45), borderRadius: const BorderRadius.all(Radius.circular(10))),
                        duration: const Duration(milliseconds: 100),
                        backDuration: const Duration(milliseconds: 200),
                        mainAxisAlignment: MainAxisAlignment.center,
                        textStyle: TextStyle(fontFamily: Globals.sysFont, fontWeight: FontWeight.w400, fontSize: 16, color: AppTheme.colors.friendlyBlack),
                        selectedTextStyle: TextStyle(fontFamily: Globals.sysFont, fontWeight: FontWeight.w700, fontSize: 16, color: AppTheme.colors.onsetBlue),
                        alignment: Alignment.center,
                      ),
                      resultOptions: ResultOptions(
                        openBoxDecoration: BoxDecoration(border: Border.all(color: AppTheme.colors.onsetBlue), borderRadius: const BorderRadius.all(Radius.circular(10))),
                        render: ResultRender.none,
                        width: 50,
                        icon: SizedBox(
                          width: 25,
                          height: 25,
                          child: Icon(Icons.shopping_cart_rounded, color: AppTheme.colors.onsetBlue,),
                        )
                      ),
                      onChange: (val){
                        setState((){
                          filter = val;
                        });
                      }
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ValueListenableBuilder(valueListenable: cPetFood, builder: (context, value, child){
                        return Text('$value', style: TextStyle(fontSize: 12, fontFamily: Globals.sysFont, color: AppTheme.colors.onsetBlue),);
                      }),
                      const SizedBox(width: 5,),
                      Image.asset('assets/foodIcon.png', width: 20, height: 20,),
                      const SizedBox(width: 15,),
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: IconButton(onPressed: (){

                        }, icon: const Icon(Icons.add),
                          hoverColor: AppTheme.colors.darkOnsetBlue,
                          style: ButtonStyle(
                            iconSize: const MaterialStatePropertyAll<double?>(10),
                            padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.all(5.0)),
                            shape: const MaterialStatePropertyAll<OutlinedBorder?>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0)))),
                            elevation: const MaterialStatePropertyAll<double?>(5.0),
                            iconColor: MaterialStatePropertyAll<Color?>(AppTheme.colors.pleasingWhite),
                            backgroundColor: MaterialStatePropertyAll<Color?>(AppTheme.colors.friendlyBlack),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5,),
                      ValueListenableBuilder(valueListenable: cPawCoin, builder: (context, value, child){
                        return Text('$value', style: TextStyle(fontSize: 12, fontFamily: Globals.sysFont, color: AppTheme.colors.onsetBlue),);
                      }),
                      const SizedBox(width: 5,),
                      Image.asset('assets/pawCoin.png', width: 20, height: 20,),
                    ],
                  ),
                ],
              )),
            const SizedBox(height: 5,),
            Expanded(child: Padding(padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                child: FadeInAnimation(delay: 1.5,child: CustomBox(
                  color: AppTheme.colors.friendlyWhite,
                  border: Border(
                      top: BorderSide(color: AppTheme.colors.blissCream, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                      left: BorderSide(color: AppTheme.colors.blissCream, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                      right: BorderSide(color: AppTheme.colors.blissCream, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                      bottom: BorderSide(color: AppTheme.colors.blissCream, width: 5.0, strokeAlign: BorderSide.strokeAlignInside)),
                  shadow: Colors.transparent,
                  child: FutureBuilder<List<ImageInfo>>(
                    future: fetchImages(),
                    builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError){
                        return Center(
                          child: SpinKitThreeBounce(color: AppTheme.colors.onsetBlue,)
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'MarketPlace is Empty',
                            style: TextStyle(
                              color: AppTheme.colors.friendlyBlack,
                            )
                          )
                        );
                      } else{
                        return Padding(padding: const EdgeInsets.all(16.0),
                          child: GridView.builder(
                            physics: const RangeMaintainingScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 30.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return FadeInAnimation(delay: 1, child: Column(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: (){
                                   openDialog(context, snapshot.data![index].name, snapshot.data![index].price, snapshot.data![index].hp);
                                  },
                                      child: filter == 'Pets'? ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child:  Image.memory(snapshot.data![index].imageData)
                                      ): Image.memory(snapshot.data![index].imageData),
                                    ),
                                  ),
                                  Text(snapshot.data![index].name, style: TextStyle(fontSize: 10,fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyBlack)),
                                ],
                              ));
                            },
                          )
                        );
                      }
                    },
                  ),
                ))
            ))
      ] : [
            const NotLoggedInWidget()
          ],
        ),
      ),
    );
  }
}