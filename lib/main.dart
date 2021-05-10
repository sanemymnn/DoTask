import 'package:flutter/material.dart';
import 'screens/homepage.dart';

import 'screens/TodayScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/user_profile.dart';
import 'screens/todo_screen.dart';
import 'screens/books_screen.dart';
import 'screens/list_screen.dart';
import 'screens/movies_screen.dart';
import 'screens/others_screen.dart';
import 'screens/motivation.dart';
import 'screens/goals.dart';
import 'screens/body.dart';
import 'screens/shopping_list.dart';
import 'screens/sign_up_view.dart';
import 'widgets/provider_widget.dart';
import 'models/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeController(),
        routes: <String, WidgetBuilder>{
          Homepage.route: (ctx) => Homepage(),
          Body.route: (ctx) => Body(),
          TodayScreen.route: (ctx) => TodayScreen(),
          UserProfile.route: (ctx) => UserProfile(),
          TodoScreen.route: (ctx) => TodoScreen(),
          BooksScreen.route: (ctx) => BooksScreen(),
          MoviesScreen.route: (ctx) => MoviesScreen(),
          ListScreen.route: (ctx) => ListScreen(),
          OthersScreen.route: (ctx) => OthersScreen(),
          GoalsScreen.route: (ctx) => GoalsScreen(),
          Motivation.route: (ctx) => Motivation(),
          ShoppingScreen.route: (ctx) => ShoppingScreen(),
          '/signUp': (BuildContext context) =>
              SignUpView(authFormType: AuthFormType.signUp),
          '/signIn': (BuildContext context) =>
              SignUpView(authFormType: AuthFormType.signIn),
        },
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? TodayScreen() : Homepage();
        }
        return CircularProgressIndicator();
      },
    );
  }
}
