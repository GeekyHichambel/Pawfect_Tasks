import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/GLOBALS.dart';
import 'package:PawfectTasks/db/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Components/Animations.dart';
import '../Components/CustomBox.dart';
import '../Components/NotLoggedIn.dart';

class ImageInfo {
  final String name;
  final Uint8List imageData;
  final int price;
  final int foodValue;

  ImageInfo(this.name, this.imageData, this.price, this.foodValue);
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
      final ListResult? result = await DataBase.marketStorage?.listAll();
      List<ImageInfo> imageList = [];
      if (result != null){
        for (final Reference ref in result.items){
          final String imageName = ref.name;
          final RegExp regExp = RegExp(r'^[0-9]\[(.*?)\]\[(\d+)\]\[(\d+)\]\.png$');
           final Match? match = regExp.firstMatch(imageName);
          if (match != null) {
            final String displayName = match.group(1)!;
            final int price = int.parse(match.group(2)!);
            final int foodValue = int.parse(match.group(3)!);
            final Uint8List? imageData = await ref.getData();
            if (imageData != null) {
              imageList.add(ImageInfo(displayName,imageData,price,foodValue));
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
                        children: [
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
                          buyFood(context, foodValue, price).then((_){
                          loading.value = false;
                          Navigator.of(context).pop();
                          });
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
                      //TODO: Payment Gateway
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
                            physics: const AlwaysScrollableScrollPhysics(),
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
                                   openDialog(context, snapshot.data![index].name, snapshot.data![index].price, snapshot.data![index].foodValue);
                                  },
                                      child: Image.memory(snapshot.data![index].imageData),
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