import 'dart:ui';
import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/GLOBALS.dart';
import 'package:PawfectTasks/db/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Components/Animations.dart';
import '../Components/CustomBox.dart';

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
  late int cPawCoin = 0;
  late int cPetFood = 0;
  
  void setupUpdateListener(){
    DataBase.itemCollection?.child(Globals.user).child('pawCoin').onValue.listen((event) async { 
      if (event.snapshot.value != null){
        final user = await DataBase.itemCollection?.child(Globals.user).get();
        setState(() {
          cPawCoin = user?.child('pawCoin').value as int;
        });
      }
    });
    DataBase.itemCollection?.child(Globals.user).child('petFood').onValue.listen((event) async {
      if (event.snapshot.value != null){
        final user = await DataBase.itemCollection?.child(Globals.user).get();
        setState(() {
          cPetFood = user?.child('petFood').value as int;
        });
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
                  Text('$cPetFood', style: TextStyle(fontSize: 19, fontFamily: Globals.sysFont, color: AppTheme.colors.onsetBlue),),
                  const SizedBox(width: 5,),
                  Image.asset('assets/foodIcon.png', width: 20, height: 20,),
                  const SizedBox(width: 15,),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: IconButton(onPressed: (){
                      //TODO: Payment Gateway
                    }, icon: const Icon(Icons.add),
                      hoverColor: AppTheme.colors.lightOnsetBlue,
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
                  Text('$cPawCoin', style: TextStyle(fontSize: 19, fontFamily: Globals.sysFont, color: AppTheme.colors.onsetBlue),),
                  const SizedBox(width: 5,),
                  Image.asset('assets/pawCoin.png', width: 20, height: 20,),
                ],
              )),
            const SizedBox(height: 5,),
            Expanded(child: Padding(padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                child: FadeInAnimation(delay: 1.5,child: CustomBox(
                  color: AppTheme.colors.friendlyBlack,
                  shadow: Colors.transparent,
                  child: FutureBuilder<List<ImageInfo>>(
                    future: fetchImages(),
                    builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError){
                        return Center(
                          child: CircularProgressIndicator(color: AppTheme.colors.onsetBlue,)
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            'MarketPlace is Empty',
                            style: TextStyle(
                              color: Colors.white,
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
                                        if(kDebugMode) print('Price: ${snapshot.data![index].price}');
                                        if(kDebugMode) print('Value: ${snapshot.data![index].foodValue}');
                                      },
                                      child: Image.memory(snapshot.data![index].imageData),
                                    ),
                                  ),
                                  Text(snapshot.data![index].name, style: TextStyle(fontSize: 10,fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyWhite)),
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
            Image.asset('assets/loginFirst.png', height: 200, width: 200, fit: BoxFit.fill,),
            const SizedBox(height: 20,),
            Center(child: Text('Kindly login first to access this section', style: TextStyle(fontWeight: FontWeight.bold,color: AppTheme.colors.pleasingWhite, fontFamily: Globals.sysFont, fontSize: 14)),),
          ],
        ),
      ),
    );
  }
}