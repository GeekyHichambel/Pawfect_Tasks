import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart' as flutter_animate;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../Components/AppTheme.dart';
import '../../GLOBALS.dart';
import 'FirstPage.dart';
import 'SecondPage.dart';
import 'ThirdPage.dart';

class Tasks{

  static Future<void> addTasks(BuildContext context) async{
    final pageController = PageController(keepPage: true);
    int currentPage = 0;
    TextEditingController Tcontroller = TextEditingController();
    TextEditingController Dcontroller = TextEditingController();

    List<PageStorageKey> pageKeys = [
      const PageStorageKey('FirstPage'),
      const PageStorageKey('SecondPage'),
      const PageStorageKey('ThirdPage'),
    ];

    List<Widget> Pages = [
      PageStorage(key: pageKeys[0],bucket: PageStorageBucket(),child: SingleChildScrollView(child: FirstPage(Tcontroller: Tcontroller, Dcontroller: Dcontroller),),),
      PageStorage(key: pageKeys[1],bucket: PageStorageBucket(), child: const SingleChildScrollView(child: SecondPage()),),
      PageStorage(key: pageKeys[2],bucket: PageStorageBucket(), child: const SingleChildScrollView(child: ThirdPage(),),),
    ];

    void goToPage(int pageIndex) {
      pageController.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

    await precacheImage(const AssetImage('assets/cardBack.png'), context);
    await showDialog(context: context, builder: (context){
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Container(
                    decoration: BoxDecoration(
                        color: AppTheme.colors.friendlyWhite,
                        image: const DecorationImage(image: AssetImage('assets/cardBack.png'), fit: BoxFit.cover, filterQuality: FilterQuality.medium, opacity: 0.5)
                    ),
                    child: Padding( padding: const EdgeInsets.all(16.0), child:Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:  [
                                  IconButton(onPressed: (){
                                    if (currentPage == 0){
                                      return;
                                    }
                                    goToPage(currentPage - 1);
                                    setState((){
                                      currentPage = currentPage - 1;
                                    });
                                  }, icon: const Icon(Icons.arrow_back_ios_new_rounded,size: 25,), color: currentPage == 0? AppTheme.colors.onsetBlue.withOpacity(0.3) : AppTheme.colors.onsetBlue, ),
                                  Expanded(child: Text('Create A New Task',textAlign: TextAlign.center, style: TextStyle(color: AppTheme.colors.friendlyBlack, fontSize: 18, fontWeight: FontWeight.w700, fontFamily: Globals.sysFont),),),
                                  currentPage == Pages.length - 1? GestureDetector(
                                    onTap: (){

                                    },
                                    child: Text('Done', style: TextStyle(color: AppTheme.colors.onsetBlue, fontSize: 15.5, fontWeight: FontWeight.bold,  fontFamily: Globals.sysFont),),
                                  ): IconButton(onPressed: (){
                                    goToPage(currentPage + 1);
                                    setState((){
                                      currentPage = currentPage + 1;
                                    });
                                  }, icon: const Icon(Icons.arrow_forward_ios_rounded,size: 25,), color: AppTheme.colors.onsetBlue, ),
                                ]),
                            const SizedBox(height: 10,),
                            Expanded(child:Scaffold(backgroundColor: Colors.transparent, resizeToAvoidBottomInset: true, body: PageView(
                              controller: pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: Pages,
                            ),)),
                          ],),
                        Positioned(
                            bottom: 0,
                            child: Column(
                                children:[
                                  SmoothPageIndicator(controller: pageController, count: Pages.length, effect: ScrollingDotsEffect(
                                    activeDotColor: AppTheme.colors.onsetBlue,
                                    dotColor: AppTheme.colors.blissCream,
                                  ),),
                                  const SizedBox(height: 20,),
                                  ElevatedButton(
                              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyBlack)),
                              onPressed: () {
                                Tcontroller.clear();
                                Dcontroller.clear();
                                Navigator.of(context).pop();
                              }, child: Icon(CupertinoIcons.multiply, color: AppTheme.colors.friendlyWhite,),
                            ),
                                ])
                        ,)
                      ],
                    ),)
                ).animate(
                    effects: [
                      flutter_animate.SlideEffect(
                        duration: 250.ms,
                        curve: Curves.linear,
                        begin: Offset.fromDirection(4.7),
                      )
                    ]));
          }
      );
    });
  }
}




