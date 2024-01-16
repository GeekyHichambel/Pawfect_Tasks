import 'package:flutter/material.dart';
import 'package:hit_me_up/Components/AppTheme.dart';
import 'package:hit_me_up/Components/CustomBox.dart';

class ProfilePane extends StatefulWidget{
  const ProfilePane({Key? key}) : super(key: key);
  @override
  _ProfilePaneState createState() => _ProfilePaneState();
}

class _ProfilePaneState extends State<ProfilePane>{
  bool imageUp = false;


  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.colors.gloryBlack,
      body: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 0.0),
                child: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 30.0,
                  color: AppTheme.colors.blissCream,)),
              ),
              Expanded(child:
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 30.0,),
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                            color: AppTheme.colors.complimentaryBlack,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(
                              color: AppTheme.colors.blissCream,
                              offset: const Offset(0, 0),
                              blurRadius: 30.0,
                            ),
                            ]
                        ),
                        child: Center(
                          child: imageUp? null :
                          Text('F',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Onset',
                              fontSize: 80,
                              color: AppTheme.colors.blissCream,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),),
                    const SizedBox(height: 10.0,),
                    Padding(padding: const EdgeInsetsDirectional.all(16.0),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          CustomBox(color: AppTheme.colors.complimentaryBlack,
                              shadow: Colors.transparent,
                              height: 60,
                              child: const Row(
                                children: [

                                ],
                              )),
                          const SizedBox(height: 16.0),
                          CustomBox(color: AppTheme.colors.complimentaryBlack,
                              shadow: Colors.transparent,
                              height: 60,
                              child: const Row(
                                children: [

                                ],
                              )),
                          const SizedBox(height: 16.0),
                          CustomBox(color: AppTheme.colors.complimentaryBlack,
                              shadow: Colors.transparent,
                              height: 60,
                              child: const Row(
                                children: [

                                ],
                              )),
                          const SizedBox(height: 16.0),
                          CustomBox(color: AppTheme.colors.complimentaryBlack,
                              shadow: Colors.transparent,
                              height: 60,
                              child: const Row(
                                children: [

                                ],
                              )),
                          const SizedBox(height: 16.0),
                          CustomBox(color: AppTheme.colors.complimentaryBlack,
                              shadow: Colors.transparent,
                              height: 60,
                              child: const Row(
                                children: [

                                ],
                              )),
                          const SizedBox(height: 16.0),
                          CustomBox(color: AppTheme.colors.complimentaryBlack,
                              shadow: Colors.transparent,
                              height: 60,
                              child: const Row(
                                children: [

                                ],
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ),
            ],
          ),
        ),
    );
  }
}