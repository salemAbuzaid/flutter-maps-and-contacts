import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Text(
                      station.streetName,
                    ),
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
