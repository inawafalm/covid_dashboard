//import 'dart:html'

import 'package:covid_dashboard/Widgets/info_card.dart';
import 'package:covid_dashboard/Widgets/line_chart.dart';
import 'package:covid_dashboard/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

// Widget



class HomeScreen extends StatefulWidget{
  @override
  _HomeScreen createState() => _HomeScreen();
}


//State of the widget
class _HomeScreen extends State<HomeScreen>
{

  int totalDeaths;
  int confirmedCases;
  int totalRecovered;
  int newCases;


  bool umSelected = true;
  bool flSelected = false;
  bool usSelected = false;
  final db = FirebaseFirestore.instance;
  Map data;
  final String _collection = 'collectionName';

  @override
  Widget build(BuildContext context) {

  String valueChoose = "University of Miami";
  List listItem = ["University of Miami","Florida","US"];
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('COVID-19');

  void _onPressed() async {

    CollectionReference collectionReference = FirebaseFirestore.instance.collection('COVID-19');

    collectionReference.snapshots().listen((snapshot) {
      setState(() {

        if (umSelected == true) {
          totalDeaths = snapshot.docs[0]['Deaths'];
          confirmedCases = snapshot.docs[0]['Infected'];
          totalRecovered = snapshot.docs[0]['Recovered'];
          newCases = snapshot.docs[0]['newCases'];
        } else if (flSelected == true) {
          totalDeaths = snapshot.docs[1]['Deaths'];
          confirmedCases = snapshot.docs[1]['Infected'];
          totalRecovered = snapshot.docs[1]['Recovered'];
          newCases = snapshot.docs[1]['newCases'];
        } else if (usSelected == true) {
          totalDeaths = snapshot.docs[2]['Deaths'];
          confirmedCases = snapshot.docs[2]['Infected'];
          totalRecovered = snapshot.docs[2]['Recovered'];
          newCases = snapshot.docs[2]['newCases'];
        }
        print("Fetching");
      });

    });

  }




  return Scaffold(
    appBar: buildAppBar(),

     body: StreamBuilder<Object>(
       stream: FirebaseFirestore.instance.collection("COVID-19").snapshots(),
       builder: (context, snapshot) {
         if (!snapshot.hasData) return Text("Loading data....");
         return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children:<Widget> [

             Container(
               decoration: BoxDecoration(
                   color: kPrimaryColor.withOpacity(.05)),
         child: Row(
             children: <Widget>[
             SvgPicture.asset("assets/icons/maps-and-flags.svg"),
         SizedBox(width: 20),
         Expanded(

           child: Padding(
             padding: const EdgeInsets.all(10.0),

             child: Container(
               child:  Row(
                 mainAxisAlignment: MainAxisAlignment.center,

                 children: <Widget>[
                   // ignore: deprecated_member_use
                   RaisedButton(
                     child: Text("UM"),
                     onPressed: () => {
                       setState((){
                         _onPressed();
                         //newCases = snapshot.data['infected'];
                         // totalRecovered = 1047;
                         // confirmedCases = 1211;
                         // totalDeaths = 0;
                         umSelected = true;
                         flSelected = false;
                         usSelected = false;
                         print("Hi");

                       }
                       ),
                     },
                     shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
                     textColor: Colors.black,
                     color: umSelected ? Colors.lightGreen : Colors.white,
                   ),
                   SizedBox(width: 5),
                   // ignore: deprecated_member_use
                   RaisedButton(
                     child: Text("FL"),
                     onPressed: () => {
                       setState((){
                         _onPressed();
                         umSelected = false;
                         flSelected = true;
                         usSelected = false;
                       }
                       ),
                     },
                     shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
                     textColor: Colors.black,
                     color: flSelected ? Colors.lightGreen : Colors.white,
                   ),
                   SizedBox(width: 5),
                   // ignore: deprecated_member_use
                   RaisedButton(
                     child: Text("US"),
                     onPressed: () => {
                       setState((){
                         _onPressed();
                         umSelected = false;
                         flSelected = false;
                         usSelected = true;
                       }

                       ),
                     },
                     shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
                     textColor: Colors.black,
                       color: usSelected ? Colors.lightGreen : Colors.white,
                   ),
                 ],
               ),
             ),
           ),
         ),
         ],
   ),
  ),
             Container(
               padding:EdgeInsets.only(left:20,top:20,right:20,bottom:20),
               width: double.infinity,
               decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(.05),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50))),
               child:Wrap(
                 runSpacing: 20,
                 spacing: 20,
                 children: <Widget>[
                   InfoCard(
                       title:"Confrimed Cases",
                       iconColor:Colors.red,
                        effectedNum: confirmedCases,
                        ),
                   InfoCard(
                     title:"Total Deaths",
                     iconColor:Colors.blueGrey,
                     effectedNum: totalDeaths,
                   ),
                   InfoCard(
                     title:"Total Recovered",
                     iconColor:Colors.lightGreen,
                     effectedNum: totalRecovered,
                   ),
                   InfoCard(
                     title:"New Cases",
                     iconColor:Color(0xD8E167),
                     effectedNum: newCases,
                   ),
                 ],
               ),
             ),
             SizedBox(height: 20,),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     "Prevention",
                     style: Theme.of(context)
                         .textTheme
                         .title
                         .copyWith(fontWeight: FontWeight.bold),
                   ),
                   SizedBox(height: 20,),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget>[
                       PreventionCard(
                           svgSrc: "assets/010-washing hands.svg",
                           title:"Wash Hands"
                       ),
                       PreventionCard(
                           svgSrc: "assets/038-medical mask.svg",
                           title:"Mask Up"
                       ),
                       PreventionCard(
                           svgSrc: "assets/027-spray.svg",
                           title:"Disinfect"
                       )
                     ],
                   ),
                 ],
               ),
             )
           ]
         );
       }
     ),

   );


  }


AppBar buildAppBar() {
  return AppBar(
      backgroundColor: kPrimaryColor.withOpacity(.03),
      elevation: 0,
      leading: IconButton(
          icon: SvgPicture.asset("assets/menu.svg"),
          onPressed: (){}
          ),
      actions: <Widget>[
        IconButton(icon: SvgPicture.asset("assets/search.svg"),
            onPressed: (){}
            )
      ],
  );
}
}


class PreventionCard extends StatelessWidget {
  final String svgSrc;
  final String title;
  const PreventionCard({
    Key key, this.svgSrc, this.title,
  }) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SvgPicture.asset(
          svgSrc,
          height: 50,
          width: 50,
        ),
        Text(
          title,
          style: Theme
              .of(context)
              .textTheme
              .body2
              .copyWith(color: Colors.lightGreen),
        )
      ],
    );
  }
}