import 'package:covid_alert/Controllers/covidDataController.dart';
import 'package:covid_alert/Controllers/userController.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:covid_alert/Helpers/CacheService.dart';
import 'package:covid_alert/Helpers/Constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:covid_alert/Models/CustomWidgetModels/MenuItemModel.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

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
              MenuItems(icon: Constants.notificationStatus?Icons.notifications_off:Icons.notifications, itemName: Constants.notificationStatus?"Disable Notifications":"Enable Notifications", color: Colors.blue),
              MenuItems(icon: Icons.logout, itemName: "Logout", color: Colors.blue),
            ];
            return Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height * 0.12 * (menuItems.length)
                  : MediaQuery.of(context).size.height * 0.32 * (menuItems.length),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                gradient: new LinearGradient(
                  colors: [Colors.black.withOpacity(0.95), Colors.black],
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
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white10,
                            spreadRadius: 3,
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
                            } else if(menuItem=="Disable Notifications" || menuItem=="Enable Notifications"){
                              progress.show();
                              String updateMessage = await setNotificationStatus(Constants.serverUrl,!Constants.notificationStatus,Constants.userID);
                              progress.dismiss();
                              Navigator.of(context).pop();
                              if (updateMessage == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.redAccent,
                                    content:Text(
                                        menuItem=="Disable Notifications"?"Notifications disabled":"Notifications enabled"
                                    ),
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
                              Constants.notificationStatus=!Constants.notificationStatus;
                            }else{
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
                                    color: Colors.white10,
                                    spreadRadius: 3,
                                    blurRadius: 2,
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
                                color: Colors.white,
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
    myFuture = getCovidStats(Constants.covidServerUrl, "Sri Lanka");
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
  buildDefaultCard(String text,IconData icon){
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height*0.15,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.35 : MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.7),
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
                    color: Colors.white,
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
                          color: Colors.white,
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

  buildCard(Color color, IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.025),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withOpacity(0.6),
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

  buildCovidStatBody(var latestDetails, AsyncSnapshot snapshot){
    return Column(
      children: [
        buildCard(Colors.blue, Icons.local_hospital, "Total Cases", snapshot.data[snapshot.data.length - 2]["Confirmed"].toString()),
        buildCard(Colors.redAccent, Icons.new_releases, "Active Cases", snapshot.data[snapshot.data.length - 2]["Active"].toString()),
        buildCard(Colors.yellow, Icons.today, "Daily Cases", (snapshot.data[snapshot.data.length - 2]["Confirmed"] - snapshot.data[snapshot.data.length - 3]["Confirmed"]).toString()),
        buildCard(Colors.greenAccent, Icons.sentiment_satisfied_outlined, "Recovered", snapshot.data[snapshot.data.length - 2]["Recovered"].toString()),
        buildCard(Colors.blueGrey, Icons.sentiment_dissatisfied_outlined, "Deaths", snapshot.data[snapshot.data.length - 2]["Deaths"].toString()),
      ],
    );
  }

  getSearchResults(String pattern, dynamic countryList) {
    print("Searching");
    List<dynamic> searchResults = List();
    for (dynamic country in countryList) {
      if (country["Country"].toUpperCase() == pattern.toUpperCase() ||(pattern.length>=3 && country["Country"].toUpperCase().toString().contains(pattern.toUpperCase()) )) {
        searchResults.add(country);
      }
    }
    return searchResults;
  }

bool refresh=true;
Future<List<dynamic>>getRefreshedData()async{
    if(refresh==true){
      print("a");
      var data=await getCovidStats(Constants.covidServerUrl, selectedCountry);
      refresh=false;
      print("b");
      countryDataCache=data;
      return data;
    }else{
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
              length: 2,
              child: Scaffold(
                key: _scaffoldKey,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(60.0),
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 6.0,
                        offset: Offset(0, 2),
                      ),
                    ]),
                    child: AppBar(
                      elevation: 3,
                      backgroundColor: Colors.black,
                      shadowColor: Colors.black,
                      automaticallyImplyLeading: false,
                      title: Padding(
                        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.15, 0, 0, 0),
                        child: Center(
                          child: Text(
                            "Statistics",
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      actions: [
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
                                  color: Colors.redAccent,
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
                      colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.darken),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: TabBarView(
                    children: [
                  FutureBuilder<List<dynamic>>(
                  future: myFuture,
                    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                      if (snapshot.hasData) {
                        var latestDetails = snapshot.data.last;
                        return Container(
                          color: Colors.transparent,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.25,
                                    height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.2 : MediaQuery.of(context).size.height * 0.4,
                                    child: Image(
                                      image: AssetImage("assets/images/SL.png"),
                                    ),
                                  ),
                                ),
                                buildCovidStatBody(latestDetails, snapshot),
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
                                        //controller: _searchController,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              print("Search clicked");
                                            },
                                            child: Icon(
                                              Icons.search,
                                              color: Colors.black54,
                                              size: 23,
                                            ),
                                          ),
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
                                          height: MediaQuery.of(context).size.height*0.07,
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
                                          refresh=true;
                                        });
                                      },
                                      noItemsFoundBuilder: (value) {
                                        return Container(
                                          color: Colors.black,
                                          height: MediaQuery.of(context).size.height*0.07,
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
                                      ?buildDefaultCard("Search a country to view it's status",Icons.search)
                                      : FutureBuilder<List<dynamic>>(
                                    future: getRefreshedData(),
                                    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                                      if (snapshot.hasData && snapshot.connectionState!=ConnectionState.waiting) {
                                        if(snapshot.data.isNotEmpty){
                                          var latestDetails = snapshot.data.last;
                                          return Container(
                                            color: Colors.transparent,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:  EdgeInsets.symmetric(vertical:MediaQuery.of(context).size.height * 0.01),
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
                                                  buildCovidStatBody(latestDetails, snapshot),
                                                ],
                                              ),
                                            ),
                                          );
                                        }else{
                                          return buildDefaultCard("This country has no updated statistics yet",Icons.hourglass_empty);
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
                                           height: MediaQuery.of(context).size.height*0.7,
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
                      // Container(
                      //   color: Colors.transparent,
                      // ),
                    ],
                  ),
                ),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      offset: Offset(0, -1),
                    ),
                  ]),
                  child: BottomAppBar(
                    elevation: 0,
                    color: Colors.black,
                    child: TabBar(
                      unselectedLabelColor: Colors.white54,
                      labelColor: Colors.white,
                      //indicatorColor: Colors.white,
                      indicatorColor: Colors.redAccent,
                      tabs: [
                        buildTab(Icons.home),
                        buildTab(Icons.search),
                        // buildTab(Icons.calendar_today),
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
