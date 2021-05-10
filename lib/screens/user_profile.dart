import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'homepage.dart';
import 'todo_screen.dart';
import 'shopping_list.dart';
import 'list_screen.dart';
import 'goals.dart';
import 'motivation.dart';
import 'TodayScreen.dart';

class UserProfile extends StatefulWidget {
  static const route = "/profile";

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  List userProfilesList = [];
  String userID = "";

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchDatabaseList();
  }

  fetchUserInfo() async {
    User getUser = FirebaseAuth.instance.currentUser;
    userID = getUser.uid;
  }

  fetchDatabaseList() async {
    dynamic resultant = await Database().getUsersList();

    if (resultant == null) {
      print("unable to retrieve");
    } else {
      setState(() {
        userProfilesList = resultant;
      });
    }
  }

  updateData(String name, String surname, String email, String userID) async {
    await Database().updateUserList(name, surname, email, userID);
    fetchDatabaseList();
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
          appBar: AppBar(
            title: Text("Profile", style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.menu),
              color: Colors.blue,
              onPressed: () {
                final _state = stateMenu.currentState;
                _state.openSideMenu();
              },
            ),
            actions: [
              RaisedButton(
                onPressed: () {
                  openDialogueBox(context);
                },
                color: Colors.white,
                child: Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("profileInfo")
                .doc(userID)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Align(
                  alignment: FractionalOffset.center,
                  child: CircularProgressIndicator(),
                );

              return Column(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Image(image: AssetImage("assets/background.jpg")),
                      Positioned(
                          child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage("assets/profileimage.png"),
                      )),
                    ],
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text(
                        snapshot.data["name"] + " " + snapshot.data["surname"],
                        style: TextStyle(
                          fontSize: 25,
                        )),
                  ),
                  ListTile(
                    title: Text(snapshot.data["email"].toString()),
                    leading: Icon(Icons.mail),
                  ),
                ],
              );
            },
          ),
        ));
  }

  openDialogueBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit profile"),
            content: Container(
              height: 150,
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: "Name"),
                  ),
                  TextField(
                    controller: _surnameController,
                    decoration: InputDecoration(hintText: "Surname"),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "Email"),
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  submitAction(context);
                  Navigator.pop(context);
                },
                child: Text("Submit"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              )
            ],
          );
        });
  }

  submitAction(BuildContext context) {
    updateData(_nameController.text, _surnameController.text,
        _emailController.text, userID);
    _nameController.clear();
    _surnameController.clear();
    _emailController.clear();
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
