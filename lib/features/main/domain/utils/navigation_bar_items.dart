import 'package:flutter/material.dart';

enum NavigationBarItems {
  profiles(icon: Icons.account_box),
  inbox(icon: Icons.chat_outlined),
  ;

  const NavigationBarItems({required this.icon});
  final dynamic icon;

  String get label {
    return switch (this) {
      profiles => "Profiles",
      inbox => "Inbox",
    };
  }
}
