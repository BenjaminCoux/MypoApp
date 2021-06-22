import 'package:flutter/material.dart';
import 'package:mypo/menu_item.dart';

class MenuItems {
  static const List<MenuItem> items = [
    itemSettings,
    itemRemove,
  ];
  static const itemSettings = MenuItem(
    text: 'Modifier',
    icon: Icons.settings,
  );
  static const itemRemove = MenuItem(
    text: 'Supprimer',
    icon: Icons.delete_rounded,
  );
}
