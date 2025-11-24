import 'package:flutter/material.dart';

class NavItem{
  final String title;
  final Widget route;
  final IconData icon;

  NavItem({
    required this.title,
    required this.route,
    required this.icon,
  });
}