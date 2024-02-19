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

  ImageInfo(this.name, this.imageData);
}

class MarketPlace extends StatefulWidget{
  const MarketPlace({Key? key}) : super(key: key);
  @override
  MarketPlaceState createState() => MarketPlaceState();
}

class MarketPlaceState extends State<MarketPlace>{
  late int cPawCoin = 0;
  
  void setupUpdateListener(){
    DataBase.itemCollection?.child(Globals.user).child('pawCoin').onValue.listen((event) async { 
      if (event.snapshot.value != null){
        final user = await DataBase.itemCollection?.child(Globals.user).get();
        setState(() {
          cPawCoin = user?.child('pawCoin').value as int;
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
          final RegExp regExp = RegExp(r'^[0-9]\[(.+)\]\.png$');
          final Match? match = regExp.firstMatch(imageName);
          if (match != null && match.groupCount == 1) {
            final String displayName = match.group(1)!;
            final Uint8List? imageData = await ref.getData();
            if (imageData != null) {
              imageList.add(ImageInfo(displayName,imageData));
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
      body: Padding(padding: const EdgeInsets.only(top: 0, bottom: 20, left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: Globals.LoggedIN? [
            Text('⏺ Market Place ⏺', style: TextStyle(backgroundColor: AppTheme.colors.blissCream, fontFamily: Globals.sysFont, color: AppTheme.colors.onsetBlue, fontSize: 22, fontWeight: FontWeight.bold, fontFeatures: const [
              FontFeature.caseSensitiveForms()
            ]),),
              const SizedBox(height: 20,),
              FadeInAnimation(delay: 1, child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset('assets/pawCoin.png', width: 20, height: 20,),
                  const SizedBox(width: 5,),
                  Text('$cPawCoin', style: TextStyle(fontSize: 19, fontFamily: Globals.sysFont),),
                ],
              )),
            const SizedBox(height: 5,),
            Expanded(child: Padding(padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                child: FadeInAnimation(delay: 1.5,child: CustomBox(
                  color: AppTheme.colors.complimentaryBlack,
                  shadow: AppTheme.colors.blissCream,
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
                              final double delay = ((index/3) + 1).floorToDouble();
                              if(kDebugMode) print(delay);
                              return FadeInAnimation(delay: delay, child: Column(
                                children: [
                                  Expanded(
                                    child: Image.memory(snapshot.data![index].imageData),
                                  ),
                                  Text(snapshot.data![index].name, style: TextStyle(fontSize: 10,fontFamily: Globals.sysFont)),
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