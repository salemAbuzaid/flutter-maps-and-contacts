import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:clippy_flutter/clippy_flutter.dart';

Widget getInfoWindow(BuildContext context) {
  return Column(
    children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 30,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  "I am here",
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.white,
                      ),
                )
              ],
            ),
          ),
        ),
      ),
      Triangle.isosceles(
        edge: Edge.BOTTOM,
        child: Container(
          color: Colors.blue,
          width: 20.0,
          height: 10.0,
        ),
      ),
    ],
  );
}
