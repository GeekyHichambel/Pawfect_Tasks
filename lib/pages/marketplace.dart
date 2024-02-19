import 'package:PawfectTasks/Components/CustomBox.dart';
import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/GLOBALS.dart';
import 'package:PawfectTasks/db/database.dart';
import 'package:flutter/material.dart';
import '../Components/Animations.dart';

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
      body: Padding(padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: Globals.LoggedIN? [
              FadeInAnimation(delay: 1, child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset('assets/pawCoin.png', width: 25, height: 25,),
                  const SizedBox(width: 10,),
                  Text('$cPawCoin', style: TextStyle(fontSize: 24, fontFamily: Globals.sysFont),),
                ],
              )),
            const SizedBox(height: 16,),
            Expanded(child: Padding(padding: const EdgeInsets.all(16.0),
                child: FadeInAnimation(delay: 1.5,child: CustomBox(
                  color: AppTheme.colors.complimentaryBlack,
                  shadow: AppTheme.colors.blissCream,
                  child: const Center(
                    child: Text('Items will be added soon.', style: TextStyle(color: Colors.white),),),
                ),)
            )
            ),
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