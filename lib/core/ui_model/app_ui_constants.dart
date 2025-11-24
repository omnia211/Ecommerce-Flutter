import 'package:flutter/material.dart';
import 'package:ecommerce/core/ui_model/nav_item.dart';


class AppUiConstants {
  AppUiConstants._();

  static List<NavItem> items = [
    NavItem(title: 'Home', icon: Icons.home, route: Container()),
    NavItem(title: 'Search', icon: Icons.search, route: Container()),

  ];
}
