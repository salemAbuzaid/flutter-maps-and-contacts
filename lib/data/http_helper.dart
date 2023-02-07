import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:progetto_pilota/data/station.dart';

class HttpHelper {
  final String authority = "10.0.2.2:3000";
  final String path = "gelfs/locations";

  Future<List<Station>> getLocations() async {
    // Uri uri = Uri.https(authority, path);
    // Uri uri = Uri.http(authority, path);
    // http.Response result = await http.get(uri);
    List<Station> stations = [];

    try {
      await dotenv.load(fileName: ".env");
      // log(dotenv.env['LOCATION_URI']!);
      http.Response result = await http.get(
        Uri.parse(dotenv.env['LOCATION_URI']!),
        // Send authorization headers to the backend.
        headers: {
          // HttpHeaders.authorizationHeader: 'SALEM',
          "token": 'SALEM',
        },
      );
      // log(result.body);
      Map<String, dynamic> data = jsonDecode(result.body);
      // log(result.body);
      List<dynamic> locations = data['locations'];
      locations.forEach((location) {
        Station station = Station.fromJson(location);
        stations.add(station);
      });
      // log('stations gotten');
      return stations;
    } catch (err) {
      // throw ('Error: not able to find the stations server ...');
      log('ERROR: ' + err.toString());
    }
    return stations;
  }
}
