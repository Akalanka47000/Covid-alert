import 'dart:ui';

import 'package:covid_alert/Controllers/covidDataController.dart';
import 'package:covid_alert/Controllers/userController.dart';
import 'package:covid_alert/View/InformationDialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:covid_alert/Helpers/CacheService.dart';
import 'package:covid_alert/Helpers/Constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:covid_alert/Models/CustomWidgetModels/MenuItemModel.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
  HomeScreen();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  AnimationController _settingsButtonRotationController;
  Future myFuture;
  Future countryFuture;
  String selectedCountry = null;
  var progress;
  var countryDataCache;
  var formatter;


//callback to update the state of the screen
  void setStateCallback() {
    setState(() {});
  }


  List<MenuItems> menuItems;
  showMenuItems() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            //Menu item list which is displayed when settings button is clicked
            menuItems = [
              MenuItems(
                  icon: Constants.notificationStatus ? Icons.notifications_off : Icons.notifications,
                  itemName: Constants.notificationStatus ? "Disable Notifications" : "Enable Notifications",
                  color: Colors.blue),
              MenuItems(icon: Icons.color_lens, itemName: "Change Theme [${Constants.theme}]", color: Colors.blue),
              MenuItems(icon: Icons.logout, itemName: "Logout", color: Colors.blue),
            ];
            return Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait ? 270 : MediaQuery.of(context).size.height * 0.32 * (menuItems.length),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                gradient: new LinearGradient(
                  colors:  Constants.theme == "Dark" ? [Colors.black.withOpacity(0.95), Colors.black]:[Colors.black.withOpacity(0), Colors.black.withOpacity(0.2)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Constants.theme == "Dark" ?Colors.white:Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color:  Constants.theme == "Dark" ?Colors.white10:Colors.black26,
                            spreadRadius: Constants.theme == "Dark" ?3:1,
                            blurRadius: 2,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListView.builder(
                    itemCount: menuItems.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            String menuItem = menuItems[index].itemName;
                            if (menuItem == "Logout") {
                              await CacheService.saveLoggedInStatus(false);
                              await FirebaseMessaging.instance.deleteToken();
                              Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => LoginScreen()));
                            } else if (menuItem == "Disable Notifications" || menuItem == "Enable Notifications") {
                              progress.show();
                              String updateMessage = await setNotificationStatus(Constants.serverUrl, !Constants.notificationStatus, Constants.userID);
                              progress.dismiss();
                              Navigator.of(context).pop();
                              if (updateMessage == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.redAccent,
                                    content: Text(menuItem == "Disable Notifications" ? "Notifications disabled" : "Notifications enabled"),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.redAccent,
                                    content: Text(updateMessage),
                                  ),
                                );
                              }
                              Constants.notificationStatus = !Constants.notificationStatus;
                            } else if (menuItem == "Change Theme [${Constants.theme}]") {
                              if (Constants.theme == "Dark") {
                                Constants.theme = "Light";
                                CacheService.setTheme("Light");
                              } else {
                                Constants.theme = "Dark";
                                CacheService.setTheme("Dark");
                              }
                              setState(() {
                                print("Theme Changed");
                              });
                              setStateCallback();
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: menuItems[index].color.shade100,
                                boxShadow: [
                                  BoxShadow(
                                    color: Constants.theme == "Dark" ?Colors.white10:Colors.black.withOpacity(0.15),
                                    spreadRadius: Constants.theme == "Dark" ?3:1,
                                    blurRadius: Constants.theme == "Dark" ?2:5,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width * 0.1 : MediaQuery.of(context).size.width * 0.05,
                              width: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width * 0.1 : MediaQuery.of(context).size.width * 0.05,
                              child: Icon(
                                menuItems[index].icon,
                                size: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width * 0.06 : MediaQuery.of(context).size.width * 0.035,
                                color: Colors.black,
                              ),
                            ),
                            title: Text(
                              menuItems[index].itemName,
                              style: TextStyle(
                                color: Constants.theme == "Dark" ?Colors.white:Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          });
        });
  }

  buildTab(IconData icon) {
    return Tab(
      child: Icon(
        icon,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formatter = NumberFormat('###,000');
    myFuture = getCovidStatsHPB();
    countryFuture = getCountries(Constants.covidServerUrl);
    _settingsButtonRotationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _settingsButtonRotationController.dispose();
  }

  buildDefaultCard(String text, IconData icon) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.15,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.35 : MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color:  Constants.theme == "Dark" ?Colors.blue.withOpacity(0.7):Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(color: Colors.blue.withAlpha(100), offset: Offset(1, 4), blurRadius: 8, spreadRadius: 2),
                ],
                //gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xfffbb448), Color(0xfff7892b)])
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width * 0.3 : MediaQuery.of(context).size.height * 0.3,
                    color:  Constants.theme == "Dark" ?Colors.white:Colors.black.withOpacity(0.7),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.06, 10, MediaQuery.of(context).size.width * 0.06, 0),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          height: 1.5,
                          fontSize: 15,
                          color:  Constants.theme == "Dark" ?Colors.white:Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
buildContactCard(IconData icon, String name, String contact){
    return Padding(
      padding:   Constants.theme == "Dark" ?EdgeInsets.all(20.0):EdgeInsets.all(18),
      child: Container(
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color:  Constants.theme == "Dark" ?Colors.transparent:Colors.white.withOpacity(0.85),
          boxShadow: [
            BoxShadow(
              color:  Constants.theme == "Dark" ?Colors.transparent:Colors.black.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 1,
              offset: Offset(1,2)

            )
          ]
        ),
        child: Padding(
          padding:   Constants.theme == "Dark" ?EdgeInsets.zero:EdgeInsets.all(8.0),
          child: Column(
            children:[
              Icon(
                icon,
                color:  Constants.theme == "Dark" ?Colors.white:Colors.black,
                size: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  name,
                  style: TextStyle(
                    color:  Constants.theme == "Dark" ?Colors.white:Colors.black,
                    fontSize: 18
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  var number='tel:$contact';
                  if (await canLaunch(number)) {
                  await launch(number);
                  } else {
                  print('Could not launch $number');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    contact,
                    style: TextStyle(
                      color: Colors.redAccent,
                        fontSize: 18
                    ),
                  ),
                ),
              ),
            ]
          ),
        ),
      ),
    );
}
  buildCard(Color color, IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.025),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:  Constants.theme == "Dark" ?color.withOpacity(0.6):color.withOpacity(0.75),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(color: color.withAlpha(100), offset: Offset(1, 4), blurRadius: 8, spreadRadius: 2),
          ],
          //gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xfffbb448), Color(0xfff7892b)])
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Row(
            children: [
              Container(
                // color: Colors.pink,
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  children: [
                    Icon(
                      icon,
                      color: Colors.black,
                      size: 35,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Text(
                      title,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontSize: 23,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildCovidStatBody(String tab, AsyncSnapshot snapshot) {
    return Column(
      children: [
        buildCard(
          Colors.blue,
          Icons.local_hospital,
          "Total Cases",
          tab == "firstTab"
              ? (Constants.localStats ? formatter.format(snapshot.data["data"]["local_total_cases"]).toString() : formatter.format(snapshot.data["data"]["global_total_cases"]).toString())
              : formatter.format(snapshot.data[snapshot.data.length - 2]["Confirmed"]).toString(),
        ),
        buildCard(
          Colors.redAccent,
          Icons.new_releases,
          "Active Cases",
          tab == "firstTab"
              ? (Constants.localStats
                  ? formatter.format(snapshot.data["data"]["local_active_cases"]).toString()
                  : formatter.format((snapshot.data["data"]["global_total_cases"] - (snapshot.data["data"]["global_recovered"] + snapshot.data["data"]["global_deaths"]))).toString())
              : formatter.format(snapshot.data[snapshot.data.length - 2]["Active"]).toString(),
        ),
        buildCard(
          Colors.yellow,
          Icons.today,
          "Daily Cases",
          tab == "firstTab"
              ? (Constants.localStats ? snapshot.data["data"]["local_new_cases"]==0?"0":formatter.format(snapshot.data["data"]["local_new_cases"]).toString() : formatter.format(snapshot.data["data"]["global_new_cases"]).toString())
              : formatter.format((snapshot.data[snapshot.data.length - 2]["Confirmed"] - snapshot.data[snapshot.data.length - 3]["Confirmed"])).toString(),
        ),
        buildCard(
          Colors.greenAccent,
          Icons.sentiment_satisfied_outlined,
          "Recovered",
          tab == "firstTab"
              ? (Constants.localStats ? formatter.format(snapshot.data["data"]["local_recovered"]).toString() : formatter.format(snapshot.data["data"]["global_recovered"]).toString())
              : formatter.format(snapshot.data[snapshot.data.length - 2]["Recovered"]).toString(),
        ),
        buildCard(
          Colors.blueGrey,
          Icons.sentiment_dissatisfied_outlined,
          "Deaths",
          tab == "firstTab"
              ? (Constants.localStats ? formatter.format(snapshot.data["data"]["local_deaths"]).toString() : formatter.format(snapshot.data["data"]["global_deaths"]).toString())
              : formatter.format(snapshot.data[snapshot.data.length - 2]["Deaths"]).toString(),
        ),
      ],
    );
  }

  getSearchResults(String pattern, dynamic countryList) {
    print("Searching");
    List<dynamic> searchResults = List();
    for (dynamic country in countryList) {
      if (country["Country"].toUpperCase() == pattern.toUpperCase() || (pattern.length >= 3 && country["Country"].toUpperCase().toString().contains(pattern.toUpperCase()))) {
        searchResults.add(country);
      }
    }
    return searchResults;
  }

  bool refresh = true;
  Future<List<dynamic>> getRefreshedData() async {
    if (refresh == true) {
      var data = await getCovidStats(Constants.covidServerUrl, selectedCountry);
      refresh = false;
      countryDataCache = data;
      return data;
    } else {
      return countryDataCache;
    }
  }

  Future<bool> onBackPressed() {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: ProgressHUD(
        child: Builder(
          builder: (context) {
            progress = ProgressHUD.of(context);
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                key: _scaffoldKey,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(60.0),
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Constants.theme == "Dark" ?Colors.black:Colors.black45,
                        blurRadius:  Constants.theme == "Dark" ?6.0:10,
                        offset: Offset(0, 2),
                      ),
                    ]),
                    child: AppBar(
                      elevation: 3,
                      backgroundColor: Constants.theme == "Dark" ?Colors.black:Colors.white,
                      shadowColor: Colors.black,
                      automaticallyImplyLeading: false,
                      title: Padding(
                        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.25, 0, 0, 0),
                        child: Center(
                          child: Text(
                            "Statistics",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: 22,
                                color: Constants.theme == "Dark" ?Colors.white:Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        GestureDetector(
                          onTap: (){
                            return showDialog(
                                context: context,
                                builder: (BuildContext context2) {
                                  return StatefulBuilder(
                                    builder: (context3, setState) {
                                      return InformationDialog();
                                    },
                                  );
                                });

                          },
                          child: Icon(
                            Icons.coronavirus,
                            size: 28,
                            color: Constants.theme == "Dark" ?Colors.redAccent:Colors.black,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: GestureDetector(
                              onTap: () {
                                _settingsButtonRotationController.forward();
                                Future.delayed(Duration(milliseconds: 1000), () {
                                  _settingsButtonRotationController.reset();
                                });
                                showMenuItems();
                              },
                              child: RotationTransition(
                                turns: Tween(begin: 0.0, end: 1.0).animate(_settingsButtonRotationController),
                                child: Icon(
                                  Icons.settings,
                                  size: 28,
                                  color:Constants.theme == "Dark" ? Colors.redAccent:Colors.black,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/BG3.jpg"),
                      colorFilter: Constants.theme == "Dark" ?new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.darken):new ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.hardLight),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: TabBarView(
                    children: [
                      //Tab1 - local stats
                      FutureBuilder<dynamic>(
                        future: myFuture,
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              color: Colors.transparent,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, 0),
                                      child: Transform.scale(
                                        scale: 1.2,
                                        child: Switch(
                                          onChanged: (bool) {
                                            setState(() {
                                              Constants.localStats = !Constants.localStats;
                                            });
                                          },
                                          value: !Constants.localStats,
                                          activeColor:  Constants.theme == "Dark" ?Colors.blue:Colors.white,
                                          activeTrackColor: Colors.green,
                                          inactiveThumbColor: Colors.redAccent,
                                          inactiveTrackColor:  Constants.theme == "Dark" ?Colors.orange:Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.35,
                                        height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.2 : MediaQuery.of(context).size.height * 0.4,
                                        child: Image(
                                          image: Constants.localStats ? AssetImage("assets/images/SL.png") : AssetImage("assets/images/globe.png"),
                                        ),
                                      ),
                                    ),
                                    buildCovidStatBody("firstTab", snapshot),
                                  ],
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                            );
                          }
                        },
                      ),

                      //Tab 2 - Search
                      FutureBuilder<List<dynamic>>(
                        future: countryFuture,
                        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                          if (snapshot.hasData) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.05, 20, MediaQuery.of(context).size.width * 0.05, 20),
                                    child: TypeAheadField(
                                      textFieldConfiguration: TextFieldConfiguration(

                                        obscureText: false,
                                        decoration: InputDecoration(
                                          hintText: "Enter Country Name",
                                          hintStyle: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white70,
                                            ),
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.fromLTRB(20, 15, 15, 15),
                                          enabledBorder: new OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                              color: Colors.black12,
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: new OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(5),
                                            borderSide: BorderSide(
                                              color: Colors.redAccent.withOpacity(0.5),
                                              width: 1,
                                            ),
                                          ),
                                          fillColor: Colors.black87,
                                          filled: true,
                                        ),
                                        style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) async {
                                        return getSearchResults(pattern, snapshot.data);
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return Container(
                                          height: MediaQuery.of(context).size.height * 0.07,
                                          child: ListTile(
                                            tileColor: Colors.black,
                                            leading: Icon(
                                              Icons.location_on,
                                              size: MediaQuery.of(context).size.width * 0.07,
                                              color: Colors.redAccent,
                                            ),
                                            title: Text(
                                              suggestion["Country"],
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            // subtitle: Text(suggestion.category),
                                            // trailing: Text("Rs. ${(suggestion.cost).toString()}"),
                                          ),
                                        );
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        setState(() {
                                          selectedCountry = suggestion["Country"];
                                          refresh = true;
                                        });
                                      },
                                      noItemsFoundBuilder: (value) {
                                        return Container(
                                          color: Colors.black,
                                          height: MediaQuery.of(context).size.height * 0.07,
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                                              child: Text(
                                                "No Items Found!",
                                                style: GoogleFonts.montserrat(
                                                  textStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  selectedCountry == null
                                      ? buildDefaultCard("Search a country to view it's status", Icons.search)
                                      : FutureBuilder<List<dynamic>>(
                                          future: getRefreshedData(),
                                          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                                            if (snapshot.hasData && snapshot.connectionState != ConnectionState.waiting) {
                                              if (snapshot.data.isNotEmpty) {
                                                return Container(
                                                  color: Colors.transparent,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
                                                          child: Text(
                                                            selectedCountry,
                                                            style: GoogleFonts.montserrat(
                                                              textStyle: TextStyle(
                                                                height: 1.5,
                                                                fontSize: 25,
                                                                color: Colors.redAccent,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        buildCovidStatBody("searchTab", snapshot),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return buildDefaultCard("This country has no updated statistics yet", Icons.hourglass_empty);
                                              }
                                            } else if (snapshot.hasError) {
                                              print(snapshot.error);
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                                ),
                                              );
                                            } else {
                                              return Container(
                                                height: MediaQuery.of(context).size.height * 0.7,
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                            );
                          } else {
                            return Container(
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height*0.6,
                            child: NotificationListener<OverscrollIndicatorNotification>(
                              onNotification: (overScroll) {

                                overScroll.disallowGlow();

                                return;

                              },
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    buildContactCard(Icons.phone, "Suwasariya Hotline", "1999"),
                                    buildContactCard(Icons.phone, "Suwasariya Ambulance Service", "1990"),
                                    buildContactCard(Icons.phone, "Epidemiology Unit", "011 269 5112"),
                                    buildContactCard(Icons.phone, "Quarantine Unit", "011 211 2705"),
                                    buildContactCard(Icons.phone, "Disaster Management Unit", "011 307 1073"),
                                    buildContactCard(Icons.phone, "Health Promotion Bureau", "0112 696 606"),
                                    buildContactCard(Icons.phone, "Coronavirus Advice", "1390"),
                                    buildContactCard(Icons.phone, "Police Emergency Hotline", "119"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Constants.theme == "Dark" ?Colors.black:Colors.white,
                      blurRadius: 6.0,
                      offset: Offset(0, -1),
                    ),
                  ]),
                  child: BottomAppBar(
                    elevation: 0,
                    color: Constants.theme == "Dark" ?Colors.black:Colors.white,
                    child: TabBar(
                      unselectedLabelColor: Constants.theme == "Dark" ?Colors.white54:Colors.black45,
                      labelColor: Constants.theme == "Dark" ?Colors.white:Colors.black,
                      //indicatorColor: Colors.white,
                      indicatorColor:Constants.theme == "Dark" ? Colors.redAccent:Colors.black,
                      tabs: [
                        buildTab(Icons.home),
                        buildTab(Icons.search),
                        buildTab(Icons.phone),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
