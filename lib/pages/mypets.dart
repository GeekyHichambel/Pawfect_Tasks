import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gif/gif.dart';
import 'package:hit_me_up/Components/AppTheme.dart';
import 'package:hit_me_up/Components/CustomBox.dart';

class MyPet extends StatefulWidget{
  const MyPet({Key? key}) : super(key: key);
  @override
  _MyPetState createState() => _MyPetState();
}

class _MyPetState extends State<MyPet> with SingleTickerProviderStateMixin{
  late GifController controller;

  @override
  void initState(){
    super.initState();
    controller = GifController(vsync: this);
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 30,vertical: 20),
        child: Center(
            child: CustomBox(
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
            )
        ),
      )
    );
  }
}