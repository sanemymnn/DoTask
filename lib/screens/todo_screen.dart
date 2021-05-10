import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:url_launcher/url_launcher.dart';

import 'homepage.dart';
import 'TodayScreen.dart';
import 'list_screen.dart';
import 'goals.dart';
import 'motivation.dart';
import 'user_profile.dart';
import 'shopping_list.dart';

class TodoScreen extends StatefulWidget {
  static const route = "/todolist";

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  String title;
  String userID = "";
  bool check = false;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  fetchUserInfo() async {
    User getUser = FirebaseAuth.instance.currentUser;
    userID = getUser.uid;
  }

  create() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("profileInfo")
        .doc(userID)
        .collection("user_todo")
        .doc(title);

    Map<String, dynamic> list = {
      "title": title,
      "check": false,
    };
    documentReference.set(list).whenComplete(() {
      return null;
    });
  }

  delete(item) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("profileInfo")
        .doc(userID)
        .collection("user_todo")
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
              indent: 20,
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
        appBar: AppBar(
          title: Text(
            "To do List",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.menu),
            color: Colors.blue,
            onPressed: () {
              final _state = stateMenu.currentState;
              _state.openSideMenu();
            },
          ),
          elevation: 0,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              _body(),
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
                        borderRadius: BorderRadius.circular(8)),
                    title: Text("Add Todo"),
                    content: TextField(
                      onChanged: (String value) {
                        title = value;
                      },
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          create();

                          Navigator.of(context).pop();
                        },
                        child: Text("Add"),
                        color: Colors.black,
                      )
                    ],
                  );
                });
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      child: Expanded(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("profileInfo")
                .doc(userID)
                .collection("user_todo")
                .snapshots(),
            builder: (context, snapshots) {
              if (snapshots.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshots.data.docs.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot =
                          snapshots.data.docs[index];

                      return Dismissible(
                        onDismissed: (direction) {
                          delete(documentSnapshot.data()["title"]);
                        },
                        key: Key(documentSnapshot.data()["title"]),
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            title: Text(documentSnapshot.data()["title"]),
                            leading: IconButton(
                              onPressed: () {
                                updateCheck(item) {
                                  DocumentReference documentReference =
                                      FirebaseFirestore.instance
                                          .collection("profileInfo")
                                          .doc(userID)
                                          .collection("user_todo")
                                          .doc(item);
                                  Map<String, bool> checkStatus = {
                                    "check": !documentSnapshot.data()["check"]
                                  };
                                  documentReference
                                      .update(checkStatus)
                                      .whenComplete(() {
                                    return null;
                                  });
                                }

                                updateCheck(documentSnapshot.data()["title"]);
                              },
                              icon: Icon(
                                documentSnapshot.data()["check"] == true
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: Colors.cyan,
                              ),
                            ),
                            trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  delete(documentSnapshot.data()["title"]);
                                }),
                          ),
                        ),
                      );
                    });
              } else {
                return Align(
                  alignment: FractionalOffset.center,
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
