import 'package:do_task/models/auth_service.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  final AuthService auth;

  Provider({Key key, Widget child, this.auth}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider of(BuildContext context) =>
      // ignore: deprecated_member_use
      (context.dependOnInheritedWidgetOfExactType<Provider>() as Provider);
}
