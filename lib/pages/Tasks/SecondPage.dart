import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget{
  const SecondPage({
  super.key,
  });

  @override
  SecondPageState createState()=> SecondPageState();
}

class SecondPageState extends State<SecondPage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context){
    super.build(context);
    return const Column();
  }
}