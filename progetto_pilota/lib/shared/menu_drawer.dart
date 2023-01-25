import 'package:flutter/material.dart';
import 'package:progetto_pilota/screens/contact_screen.dart';
import 'package:progetto_pilota/screens/intro_screen.dart';
import 'package:progetto_pilota/screens/map-screen.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  List<Widget> buildMenuItems(BuildContext context) {
    final List<String> menuTiles = ['Home', 'Map', 'Contacts'];

    List<Widget> menuItems = [];
    menuItems.add(DrawerHeader(
      decoration: BoxDecoration(color: Colors.lightGreen),
      child: Text(
        'Navigato To',
        style: TextStyle(color: Colors.white, fontSize: 28),
      ),
    ));

    menuTiles.forEach((String element) {
      Widget screen = Container();
      menuItems.add(ListTile(
        title: Text(
          element,
          style: TextStyle(fontSize: 18),
        ),
        onTap: () {
          switch (element) {
            case 'Home':
              screen = IntroScreen();
              break;
            case 'Map':
              screen = MapScreen();
              break;
            case "Contacts":
              screen = ContactScreen();
              break;
          }
          Navigator.of(context).pop();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (((context) => screen))));
        },
      ));
    });

    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: buildMenuItems(context),
      ),
    );
  }
}
