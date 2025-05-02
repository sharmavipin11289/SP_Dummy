import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Pushes a new route onto the stack.
  static Future<T?> navigateTo<T>(String routeName, {Object? arguments}) async{
    return navigatorKey.currentState?.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Replaces the current route with a new route.
  static Future<T?> replaceWith<T, TO>(String routeName, {Object? arguments}) async{
    return navigatorKey.currentState?.pushReplacementNamed<T, TO>(routeName, arguments: arguments);
  }

  /// Pops the current route off the stack.
  static void goBack<T>({T? result}) {
    navigatorKey.currentState?.pop<T>(result);
  }

  /// Pops all routes until the specified route name.
  static void popUntil(String routeName) {
    navigatorKey.currentState?.popUntil((route) => route.settings.name == routeName);
  }

  /// Pushes a new route and removes all previous routes.
  static Future<T?> navigateAndClearStack<T>(String routeName, {Object? arguments}) async{
    return navigatorKey.currentState?.pushNamedAndRemoveUntil<T>(
      routeName,
          (route) => false,
      arguments: arguments,
    );
  }
}
