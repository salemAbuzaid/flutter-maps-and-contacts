import 'package:flutter/material.dart';
import 'package:progetto_pilota/shared/menu_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: (AppBar(
/*         leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ), */
        title: Text('Contacts'),
      )),
      body: ListView(
        children: getChildren(),
      ),
    );
  }

  List<Widget> getChildren() {
    Map phoneNumbers = {"Neogy hotline": "800 832 855"};
    List<Widget> tiles = [];
    phoneNumbers.forEach((name, number) {
      tiles.add(ListTile(
        // key: UniqueKey(),
        title: Text(name),
        subtitle: Text(number),
        trailing: IconButton(
          onPressed: (() {
            _makePhoneCall(number);
          }),
          icon: Icon(Icons.call, size: 30,),
        ),
      ));
    });

    return tiles;
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}



