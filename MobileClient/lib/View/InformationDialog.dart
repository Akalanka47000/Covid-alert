import 'package:covid_alert/Helpers/Constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InformationDialog extends StatefulWidget {
  @override
  _InformationDialogState createState() => _InformationDialogState();
}

class _InformationDialogState extends State<InformationDialog> {
  buildInfoBody(double size, String imageName, String text,String category) {
    Color color;
    if(category=="Most Common"){
      color=Colors.yellow;
    }else if(category=="Less Common"){
      color=Colors.orange;
    }else{
      color=Colors.red;
    }
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                0,
                0,
                0,
                MediaQuery.of(context).size.height * 0.02,
              ),
              child: Container(
                width: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width * size : MediaQuery.of(context).size.height * 0.2,
                height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width * size : MediaQuery.of(context).size.height * 0.2,
                child: Image(
                  image: AssetImage("assets/images/$imageName.png"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.04, 0, 0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontSize: 19,
                    color:  Constants.theme == "Dark" ?Colors.white:Colors.black,
                  ),
                ),
              ),
            ),
            category!=null?Padding(
              padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, 0),
              child: Text(
                category,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: color,
                  ),
                ),
              ),
            ):Container(),
          ],
        ),
      ),
    );
  }

  buildTab() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Tab(
        child: Icon(
          Icons.circle,

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      backgroundColor:  Constants.theme == "Dark" ?Colors.black:Colors.white.withOpacity(0.95),
      content: DefaultTabController(
        length: 16,
        child: Container(
          height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.5 : MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width * 0.95 : MediaQuery.of(context).size.width * 0.5,
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    buildInfoBody(0.3, "covid2", "Coronavirus disease (COVID-19) is an infectious disease caused by a newly discovered coronavirus",null),
                    buildInfoBody(0.4, "symptoms", "COVID-19 affects different people in different ways",null),
                    buildInfoBody(0.4, "fever2", "Fever","Most Common"),
                    buildInfoBody(0.4, "cough", "Dry Cough","Most Common"),
                    buildInfoBody(0.4, "fatigue", "Fatigue","Most Common"),
                    buildInfoBody(0.4, "aches", "Aches and Pains","Less Common"),
                    buildInfoBody(0.4, "soreThroat", "Sore Throat","Less Common"),
                    buildInfoBody(0.4, "diarrhoea", "Diarrhoea","Less Common"),
                    buildInfoBody(0.4, "conjunctivitis", "Conjunctivitis","Less Common"),
                    buildInfoBody(0.4, "headache", "Headache","Less Common"),
                    buildInfoBody(0.4, "tasteSmell2", "Loss of Taste and Smell","Less Common"),
                    buildInfoBody(0.4, "rash", "Rash","Less Common"),
                    buildInfoBody(0.4, "shortBreath", "Difficulty Breathing","Serious"),
                    buildInfoBody(0.4, "chestPain", "Chest Pain","Serious"),
                    buildInfoBody(0.4, "noSpeech", "Loss of Speech","Serious"),
                    buildInfoBody(0.3, "medicine", "Seek immediate medical attention if you have serious symptoms. Always call before visiting your doctor or health facility",null),
                  ],
                ),
              ),
              Container(
                height: 30,
                child: TabBar(
                  unselectedLabelColor:  Constants.theme == "Dark" ?Colors.white54:Colors.black54,
                  labelColor: Colors.redAccent,
                  indicatorColor: Colors.transparent,
                  isScrollable: true,
                  physics: NeverScrollableScrollPhysics(),
                  tabs: [
                    buildTab(),
                    buildTab(),
                    buildTab(),
                    buildTab(),
                    buildTab(),
                    buildTab(),
                    buildTab(),
                    buildTab(),
                    buildTab(),
                    buildTab(),
                    buildTab(),
                    buildTab(),
                    buildTab(),
                    buildTab(),
                    buildTab(),
                    buildTab(),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.01,
              )
            ],
          ),
        ),
      ),
    );
  }
}
