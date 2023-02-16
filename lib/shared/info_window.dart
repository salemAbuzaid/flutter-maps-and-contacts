import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:progetto_pilota/data/port.dart';
import 'package:progetto_pilota/data/station.dart';

Widget getInfoWindow(BuildContext context, Station station) {
  return Column(
    children: [
      Expanded(
        flex: 5,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 4,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Street name: ${station.streetName}",
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 7.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Access restriction: ${station.accessRestriction}",
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 7.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Available ports: ${station.availablePorts()}/ ${station.ports.length}",
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6.0, top: 7.0),
                        child: Icon(
                          Icons.circle,
                          size: 17,
                          color: _getColor(
                              station.availablePorts(), station.ports.length),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 7.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Charging power: ${_getPowerList(station.ports)}",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Triangle.isosceles(
        edge: Edge.BOTTOM,
        child: Container(
          color: Colors.white,
          width: 20.0,
          height: 10.0,
        ),
      ),
    ],
  );
}

_getPowerList(List<Port> ports) {
  List<String> powerList = [];
  ports.forEach((port) {
    if (!powerList.contains("${port.power.toString()} KW")) {
      powerList.add("${port.power.toString()} KW");
    }
  });
  return powerList;
}

Color _getColor(int availablePorts, int portsLength) {
  if (availablePorts == portsLength) {
    return Colors.green;
  } else if (availablePorts > 0 && availablePorts < portsLength) {
    return Colors.orange;
  }
  return Colors.red;
}
