import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

import 'homepage.dart';
import 'TodayScreen.dart';
import 'list_screen.dart';
import 'motivation.dart';
import 'user_profile.dart';
import 'todo_screen.dart';
import 'goals.dart';
import 'shopping_list.dart';

class GoalsScreen1 extends StatefulWidget {
  static const route = "/goals1";

  @override
  _GoalsScreen1State createState() => _GoalsScreen1State();
}

class _GoalsScreen1State extends State<GoalsScreen1> {
  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  String userID = "";
  String title = "";
  String time;
  bool check = false;

  fetchUserInfo() async {
    User getUser = FirebaseAuth.instance.currentUser;
    userID = getUser.uid;
  }

  createGoals() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("profileInfo")
        .doc(userID)
        .collection("user_goals_short")
        .doc(title);

    Map<String, dynamic> goals = {
      "title": title,
      "time": time,
      "check": false,
    };

    documentReference.set(goals).whenComplete(() {
      return null;
    });
  }

  deleteGoals(item) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("profileInfo")
        .doc(userID)
        .collection("user_goals_short")
        .doc(item);

    documentReference.delete().whenComplete(() {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SideMenuState> stateMenu = GlobalKey<SideMenuState>();
    return SideMenu(
      key: stateMenu,
      background: Colors.blue,
      type: SideMenuType.slideNRotate,
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
              child: Column(
                children: [],
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
              onTap: () {
                Navigator.of(context).pushReplacementNamed(Homepage.route);
              },
            ),
          ],
        ),
      ),
      child: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              body(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.cyan,
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(8)),
                    title: Text("Add Goal"),
                    content: TextField(
                      onChanged: (String value) {
                        title = value;
                      },
                    ),
                    actions: <Widget>[
                      DropdownButton<String>(
                        hint: Text("Choose time interval"),
                        icon: Icon(Icons.arrow_drop_down),
                        value: time,
                        onChanged: (String newValue) {
                          setState(() {
                            FocusScope.of(context).requestFocus(FocusNode());
                            time = newValue;
                          });
                        },
                        items: <String>[
                          "Today",
                          "This week",
                          "This month",
                          "This year"
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      FlatButton(
                        onPressed: () {
                          createGoals();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Add",
                          style: TextStyle(color: Colors.black),
                        ),
                        color: Colors.white,
                      ),
                    ],
                  );
                });
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      height: 120,
      padding: EdgeInsets.only(top: 42, bottom: 16, right: 30, left: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "My Goals",
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget body() {
    return Container(
      child: Expanded(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("profileInfo")
                .doc(userID)
                .collection("user_goals_short")
                .snapshots(),
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshots.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot userGoals = snapshots.data.docs[index];

                      return Dismissible(
                          onDismissed: (direction) {
                            deleteGoals(userGoals.data()["title"]);
                          },
                          key: Key(userGoals.data()["title"]),
                          child: Card(
                            elevation: 4,
                            margin: EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusDirectional.circular(8)),
                            child: ListTile(
                              title: Text(userGoals.data()["title"]),
                              leading: IconButton(
                                onPressed: () {
                                  updateCheck(item) {
                                    DocumentReference documentReference =
                                        FirebaseFirestore.instance
                                            .collection("profileInfo")
                                            .doc(userID)
                                            .collection("user_goals_short")
                                            .doc(item);
                                    Map<String, bool> checkStatus = {
                                      "check": !userGoals.data()["check"]
                                    };
                                    documentReference
                                        .update(checkStatus)
                                        .whenComplete(() {
                                      return null;
                                    });
                                  }

                                  updateCheck(userGoals.data()["title"]);
                                },
                                icon: Icon(userGoals.data()["check"] == true
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank),
                              ),
                              subtitle: Row(
                                key: Key(userGoals.data()["time"]),
                                children: <Widget>[
                                  Text(
                                    userGoals.data()["time"],
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    deleteGoals(userGoals["title"]);
                                  }),
                            ),
                          ));
                    });
              } else {
                return Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: CircularProgressIndicator(),
                );
              }
            }),
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
