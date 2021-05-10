import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';
import 'list_screen.dart';
import 'goals.dart';
import 'motivation.dart';
import 'user_profile.dart';
import 'todo_screen.dart';
import 'shopping_list.dart';
import 'package:do_task/models/auth_service.dart';
import 'package:do_task/widgets/provider_widget.dart';

List<String> quotesList = [
  '"An investment in knowledge pays the best interest." ',
  '"Change is the end result of all true learning." ',
  '“Live as if you were to die tomorrow. Learn as if you were to live forever.” ',
  '“Be the change that you wish to see in the world.”',
  '“Life is what happens when you’re busy making other plans.” ',
  '“The purpose of our lives is to be happy.”',
  '“If you want to live a happy life, tie it to a goal, not to people or things.”',
  '“Not how long, but how well you have lived is the main thing.”',
  '"It always seems impossible until it is done." ',
  '"Ever tried. Ever failed. No matter. Try Again. Fail again Fail better."',
  '"When you reach the end of your rope, tie a knot in it and hang on." ',
  '"Knowing is not enough; we must apply. Willing is not enough; we must do." ',
  '"Problems are not stop signs, they are guidelines." ',
  '"Artists who seek perfection in everything are those who cannot attain it in anything." ',
];

class TodayScreen extends StatefulWidget {
  static const route = "/today";
  _TodayScreenState createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  String userID = "";

  String _currentQuotes;

  void initState() {
    super.initState();
    fetchUserInfo();
    _shuffleQuotes();
  }

  void _shuffleQuotes() {
    String quote;
    if (quotesList.isNotEmpty) {
      quotesList.shuffle();
      quote = quotesList.last;
    }
    setState(() {
      _currentQuotes = quote;
    });
  }

  fetchUserInfo() async {
    User getUser = FirebaseAuth.instance.currentUser;
    userID = getUser.uid;
  }

  Widget build(BuildContext context) {
    final GlobalKey<SideMenuState> stateMenu = GlobalKey<SideMenuState>();
    final GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();

    return SideMenu(
        key: stateMenu,
        background: Color.fromRGBO(23, 106, 198, 1),
        type: SideMenuType.slide,
        menu: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 20,
                  bottom: 20,
                ),
              ),
              BuiltTileWidget(
                title: "Profile",
                iconData: Icons.person,
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(UserProfile.route);
                },
              ),
              BuiltTileWidget(
                title: "Today",
                iconData: Icons.calendar_view_day,
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(TodayScreen.route);
                },
              ),
              BuiltTileWidget(
                title: "Shopping List",
                iconData: Icons.shopping_bag_rounded,
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(ShoppingScreen.route);
                },
              ),
              BuiltTileWidget(
                title: "To do",
                iconData: Icons.done_all,
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(TodoScreen.route);
                },
              ),
              BuiltTileWidget(
                title: "Lists",
                iconData: Icons.list,
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(ListScreen.route);
                },
              ),
              BuiltTileWidget(
                title: "Goals",
                iconData: Icons.auto_awesome,
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(GoalsScreen.route);
                },
              ),
              BuiltTileWidget(
                title: "Get Motivated",
                iconData: Icons.favorite_border,
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(Motivation.route);
                },
              ),
              Divider(
                height: 64,
                thickness: 0.5,
                color: Colors.white.withOpacity(0.3),
                indent: 32,
                endIndent: 32,
              ),
              BuiltTileWidget(
                title: "Logout",
                iconData: Icons.exit_to_app,
                onTap: () async {
                  try {
                    AuthService auth = Provider.of(context).auth;
                    await auth.signOut();
                    Navigator.of(context).pushReplacementNamed(Homepage.route);
                    print("Logged Out!");
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
        child: Scaffold(
            appBar: AppBar(
              title: Text("Today",
                  style: TextStyle(color: Color.fromRGBO(23, 106, 198, 1))),
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.menu),
                color: Color.fromRGBO(23, 106, 198, 1),
                onPressed: () {
                  final _state = stateMenu.currentState;
                  if (_state.isOpened)
                    _state.closeSideMenu();
                  else
                    _state.openSideMenu();
                },
              ),
              actions: [
                IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      final _state = _endSideMenuKey.currentState;
                      if (_state.isOpened)
                        _state.closeSideMenu();
                      else
                        _state.openSideMenu();
                    })
              ],
            ),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("profileInfo")
                  .doc(userID)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      Positioned(
                          top: 10,
                          right: 10,
                          left: 10,
                          child: Container(
                              height: 300,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(23, 106, 198, 1),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 50),
                                  RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                          text: " Hello ",
                                          style: TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 3,
                                            color: Colors.greenAccent[100],
                                          ),
                                          children: [
                                            TextSpan(
                                              text: snapshot.data["name"] + ",",
                                              style: TextStyle(
                                                fontSize: 35,
                                                letterSpacing: 2,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.limeAccent[400],
                                              ),
                                            )
                                          ])),
                                  SizedBox(
                                    height: 9,
                                  ),
                                  Text(
                                    "  Have a nice day!",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 20,
                                      letterSpacing: 1,
                                      color: Colors.lightGreenAccent[100],
                                    ),
                                  ),
                                ],
                              ))),
                      buildBottomHalfContainer(true),
                      Positioned(
                          top: 180,
                          child: Container(
                              height: 380,
                              width: MediaQuery.of(context).size.width - 40,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 15,
                                        spreadRadius: 5),
                                  ]),
                              child: Column(
                                children: [
                                  SizedBox(height: 40),
                                  Container(
                                    height: 200,
                                    width:
                                        MediaQuery.of(context).size.width - 60,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.greenAccent[100],
                                            Color.fromRGBO(23, 106, 198, 1)
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter),
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      primary: false,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 70,
                                        ),
                                        if (_currentQuotes == null)
                                          Text(
                                            "If you can dream it, you can do it.",
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        if (_currentQuotes != null)
                                          Text(
                                            '$_currentQuotes',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 65),
                                  Text("See your tasks",
                                      style: TextStyle(
                                        color: Color.fromRGBO(23, 106, 198, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ))
                                ],
                              ))),
                      buildBottomHalfContainer(false),
                    ],
                  );
                } else {
                  return Align(
                    alignment: FractionalOffset.center,
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )));
  }

  Positioned buildBottomHalfContainer(bool showShadow) {
    return Positioned(
      top: 510,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
            height: 80,
            width: 80,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  if (showShadow)
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      spreadRadius: 1.5,
                      blurRadius: 10,
                    )
                ]),
            child: !showShadow
                ? Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.greenAccent[100],
                              Color.fromRGBO(23, 106, 198, 1)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          )
                        ]),
                    child: IconButton(
                      icon: new Icon(Icons.arrow_forward),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed(TodoScreen.route);
                      },
                    ),
                  )
                : Center()),
      ),
    );
  }
}

class BuiltTileWidget extends StatelessWidget {
  final String title;
  final Function onTap;
  final IconData iconData;

  const BuiltTileWidget({Key key, this.title, this.onTap, this.iconData});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      leading: Icon(
        iconData,
        color: Colors.white,
      ),
      onTap: onTap,
    );
  }
}
