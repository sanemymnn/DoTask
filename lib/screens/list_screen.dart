import 'books_screen.dart';
import 'movies_screen.dart';
import 'others_screen.dart';
import 'package:flutter/material.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'homepage.dart';
import 'TodayScreen.dart';
import 'goals.dart';
import 'motivation.dart';
import 'user_profile.dart';
import 'todo_screen.dart';
import 'shopping_list.dart';

class ListScreen extends StatefulWidget {
  static const route = "/ListScreen";

  @override
  _ListStuffState createState() => _ListStuffState();
}

class _ListStuffState extends State<ListScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
          body: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 130,
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  color: Colors.cyan,
                  onPressed: () {
                    final _state = stateMenu.currentState;
                    _state.openSideMenu();
                  },
                ),
                elevation: 0,
                bottom: TabBar(
                  controller: controller,
                  unselectedLabelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.green[200], Colors.blue]),
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blue,
                  ),
                  tabs: [
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("MOVIES"),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("BOOKS"),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("OTHER"),
                      ),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                controller: controller,
                children: <Widget>[
                  MoviesScreen(),
                  BooksScreen(),
                  OthersScreen(),
                ],
              ),
            ),
          ),
        ));
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
