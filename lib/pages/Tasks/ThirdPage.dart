import 'package:flutter/material.dart';

class ThirdPage extends StatefulWidget{
  const ThirdPage({
    super.key,
  });

  @override
  ThirdPageState createState()=> ThirdPageState();
}

class ThirdPageState extends State<ThirdPage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context){
    super.build(context);
    return const  Column();
  }
}