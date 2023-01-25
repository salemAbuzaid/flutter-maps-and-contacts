import 'package:flutter/material.dart';
import 'package:progetto_pilota/screens/contact_screen.dart';
import 'package:progetto_pilota/screens/map-screen.dart';
import '../shared/menu_drawer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App Pilota'),
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.home,
              color: Colors.white,
            )),
      ),
      // drawer: MenuDrawer(),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/charging_station.png'),
          fit: BoxFit.cover,
        )),
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: StaggeredGrid.count(
              crossAxisCount: 4,
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 12.0,
              children: [
                StaggeredGridTile.count(
                  crossAxisCellCount: 4,
                  mainAxisCellCount: 2,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => MapScreen())));
                    },
                    child: MyTile(Icons.navigation, "Maps", Colors.lightGreen),
                  ),
                ),
                StaggeredGridTile.count(
                    crossAxisCellCount: 4,
                    mainAxisCellCount: 2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: ((context) => ContactScreen())));
                      },
                      child: MyTile(Icons.contacts, "Contacts",
                          Colors.deepPurple.shade400),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Material MyTile(IconData icon, String heading, Color color) {
    return Material(
      color: Colors.white,
      elevation: 12.0,
      shadowColor: Color.fromARGB(128, 134, 141, 141),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        heading,
                        style: TextStyle(fontSize: 20.0, color: color),
                      ),
                    ),
                  ),
                  // Icon
                  Material(
                    color: color,
                    borderRadius: BorderRadius.circular(20.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 36.0,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
