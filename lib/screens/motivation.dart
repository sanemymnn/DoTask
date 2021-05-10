import 'package:flutter/material.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:do_task/models/auth_service.dart';
import 'package:do_task/widgets/provider_widget.dart';

import 'homepage.dart';
import 'list_screen.dart';
import 'goals.dart';
import 'user_profile.dart';
import 'todo_screen.dart';
import 'shopping_list.dart';
import 'TodayScreen.dart';

List<String> videos = [
  "Meditation Videos",
  "Motivation Videos",
  "Yoga    Videos"
];

List icons = [
  TextButton(
      child: Text(
        "click here",
        style: TextStyle(fontSize: 18, color: Colors.lightGreen[300]),
      ),
      onPressed: () {
        const url =
            'https://www.youtube.com/playlist?list=PL5_hf00_pmLzdc_jPOUSXskEeC4V8OTcN';
        _launchURL(url);
      }),
  TextButton(
      child: Text(
        "click here",
        style: TextStyle(fontSize: 18, color: Colors.lightGreen[300]),
      ),
      onPressed: () {
        const url =
            'https://www.youtube.com/playlist?list=PL5_hf00_pmLxzmUHQF4Fmv8RFGhpuUW8u';
        _launchURL(url);
      }),
  TextButton(
      child: Text(
        "click here",
        style: TextStyle(fontSize: 18, color: Colors.lightGreen[300]),
      ),
      onPressed: () {
        const url =
            'https://www.youtube.com/playlist?list=PL5_hf00_pmLwNJX43fadF3MjNNmU12h7Z';
        _launchURL(url);
      }),
];

_launchURL(String url) {
  launch(url);
}

class Motivation extends StatefulWidget {
  static const route = "/motivation";
  @override
  _Motivation createState() => _Motivation();
}

class _Motivation extends State<Motivation> {
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
              child: Column(),
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
          title: Text("Get Motivated",
              style: TextStyle(
                color: Color.fromRGBO(23, 106, 198, 1),
                fontWeight: FontWeight.w700,
              )),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.menu),
            color: Color.fromRGBO(23, 106, 198, 1),
            onPressed: () {
              final _state = stateMenu.currentState;
              _state.openSideMenu();
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.greenAccent[100],
                    Color.fromRGBO(23, 106, 198, 0.8)
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.3, 0.7])),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: <Widget>[],
                  ),
                ),
                Container(
                  height: 450,
                  padding: const EdgeInsets.only(left: 32),
                  child: Swiper(
                    itemCount: 3,
                    itemWidth: MediaQuery.of(context).size.width - 2 * 64,
                    layout: SwiperLayout.STACK,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                SizedBox(height: 80),
                                Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(height: 90),
                                        Text(
                                          videos[index],
                                          style: TextStyle(
                                            fontFamily: 'Avenir',
                                            fontSize: 22,
                                            color: Colors.lightGreen[300],
                                            fontWeight: FontWeight.w900,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        TextButton(
                                          child: icons[index],
                                          onPressed: () {},
                                        ),
                                        SizedBox(height: 32),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "",
                                              style: TextStyle(
                                                fontFamily: 'Avenir',
                                                fontSize: 18,
                                                color: Colors.lightGreen[600],
                                                fontWeight: FontWeight.w700,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
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
