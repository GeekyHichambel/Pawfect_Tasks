import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import '../../Components/AppTheme.dart';
import '../../GLOBALS.dart';

class ThirdPage extends StatefulWidget{
  const ThirdPage({
    super.key,
  });

  @override
  ThirdPageState createState()=> ThirdPageState();
}

class ThirdPageState extends State<ThirdPage> with AutomaticKeepAliveClientMixin{
  static DateTime selectedDate = DateTime.now();
  DateTime minimumDate = DateTime.now();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context){
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 25, bottom: 25),
          child:  RichText(
              text: TextSpan(
                  text: '*', style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.w700),
                  children: [
                    TextSpan(text: 'Date', style: TextStyle(color: AppTheme.colors.friendlyBlack, fontFamily: Globals.sysFont, fontSize: 18, fontWeight: FontWeight.w700),),
                  ])),
        ),
        const SizedBox(height: 5,),
        SizedBox(
          height: 250,
          child: ScrollDatePicker(
            minimumDate: minimumDate,
            maximumDate: minimumDate.add(const Duration(days: 7)),
            selectedDate: selectedDate,
            onDateTimeChanged: (DateTime value) {
              setState(() {
                selectedDate = value;
              });
            },
            options: DatePickerOptions(backgroundColor: Colors.white.withOpacity(0.0)),
          ),
        ),
      ],
    );
  }
}