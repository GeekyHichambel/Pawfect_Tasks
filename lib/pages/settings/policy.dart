import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Policy extends StatefulWidget{
  const Policy({Key? key}) : super(key: key);
  @override
  PolicyState createState() => PolicyState();
}

class PolicyState extends State<Policy>{
  @override
  Widget build(BuildContext context){
    return const SafeArea(child: Scaffold());
  }
}