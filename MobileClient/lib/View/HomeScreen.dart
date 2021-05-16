import 'package:covid_alert/Controllers/covidDataController.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:covid_alert/Helpers/CacheService.dart';
import 'package:covid_alert/Helpers/Constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  String selectedSetting;

  List<MenuItems> menuItems;
  showMenuItems(var progress) {
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
              //MenuItems(icon: Icons.color_lens, itemName: "Change Theme", color: Colors.blue),
              MenuItems(icon: Icons.logout, itemName: "Logout", color: Colors.blue),
            ];
            return Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height * 0.15 * (menuItems.length)
                  : MediaQuery.of(context).size.height * 0.32 * (menuItems.length),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                gradient: new LinearGradient(
                  colors: [Colors.redAccent.withOpacity(0.9), Colors.redAccent],
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
    myFuture=getCovidStats(Constants.covidServerUrl,"Sri Lanka");
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
buildCard(Color color, IconData icon, String title, String value){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05,vertical:MediaQuery.of(context).size.height * 0.025 ),
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: color.withAlpha(100), offset: Offset(2, 4), blurRadius: 8, spreadRadius: 2),
        ],
        //gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xfffbb448), Color(0xfff7892b)])
      ),
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width * 0.05 ),
        child: Row(
          children: [
            Container(
              // color: Colors.pink,
              width: MediaQuery.of(context).size.width*0.3,
              child: Column(
                children: [
                  Icon(
                    icon,
                    color: Colors.black,
                    size:  35,
                  ),
                  SizedBox(
                      height:MediaQuery.of(context).size.height*0.01
                  ),
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
            ),
            Spacer(),
            Text(
              value,
              style: TextStyle(fontSize: 23, color: Colors.black),
            ),
          ],
        ),
      ),
    ),
  );
}
  Future<bool> onBackPressed() {}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: myFuture,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          var latestDetails=snapshot.data.last;
          return WillPopScope(
            onWillPop: onBackPressed,
            child: ProgressHUD(
              child: Builder(
                builder: (context) {
                  final progress = ProgressHUD.of(context);
                  return DefaultTabController(
                    length: 1,
                    child: Scaffold(
                      key: _scaffoldKey,
                      appBar: AppBar(
                        elevation: 7,
                        backgroundColor: Colors.redAccent,
                        automaticallyImplyLeading: false,
                        title: Padding(
                          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.15, 0, 0, 0),
                          child: Center(
                            child: Text(
                              "Statistics",
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontSize: 20,
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
                                  showMenuItems(progress);
                                },
                                child: RotationTransition(
                                  turns: Tween(begin: 0.0, end: 1.0).animate(_settingsButtonRotationController),
                                  child: Icon(
                                    Icons.settings,
                                    size: 28,
                                  ),
                                ),
                              )),
                        ],
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
                            Container(
                              // decoration: BoxDecoration(
                              //   gradient: LinearGradient(
                              //     begin: Alignment.topCenter,
                              //     end: Alignment.bottomCenter,
                              //     colors: [Colors.black, Colors.black.withOpacity(0.98)],
                              //   ),
                              // ),
                              color:Colors.transparent,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height:MediaQuery.of(context).size.height*0.03
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.02),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width*0.25,
                                        height: MediaQuery.of(context).size.height*0.2,
                                        child: Image(
                                          image: AssetImage("assets/images/SL.png"),
                                        ),
                                      ),
                                    ),
                                    buildCard(Colors.blue, Icons.local_hospital, "Total Cases", latestDetails["Confirmed"].toString()),
                                    buildCard(Colors.red, Icons.new_releases, "Active Cases", latestDetails["Active"].toString()),
                                    //buildCard(Colors.yellow, Icons.today, "Daily Cases", "3,000"),
                                    buildCard(Colors.greenAccent, Icons.sentiment_satisfied_outlined, "Recovered", latestDetails["Recovered"].toString()),
                                    buildCard(Colors.blueGrey, Icons.sentiment_dissatisfied_outlined, "Deaths", latestDetails["Deaths"].toString()),
                                  ],
                                ),
                              ),
                            ),
                            // Container(
                            //   color: Colors.transparent,
                            // ),
                            // Container(
                            //   color: Colors.transparent,
                            // ),
                          ],
                        ),
                      ),
                      bottomNavigationBar: BottomAppBar(
                        elevation: 0,
                        color: Colors.redAccent,
                        child: TabBar(
                          unselectedLabelColor: Colors.black87,
                          labelColor: Colors.white,
                          //indicatorColor: Colors.white,
                          indicatorColor: Colors.redAccent,
                          tabs: [
                            buildTab(Icons.home),
                            // buildTab(Icons.search),
                            // buildTab(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Center(
            child: Text("An error has occurred, please restart the application"),
          );
        } else {
          return Center(
            child: SpinKitWanderingCubes(
              color: Colors.redAccent,
              size: MediaQuery.of(context).size.width * 0.25,
            ),
          );
        }
      },
    );

  }
}
