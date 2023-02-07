import 'package:progetto_pilota/data/port.dart';

class Station {
  String id = '';
  double lat = 0.0;
  double lng = 0.0;
  String streetName = '';
  String accessRestriction = '';
  List<Port> ports = List.empty();

  Station(this.id, this.lat, this.lng, this.ports);

  Station.fromJson(Map<String, dynamic> locationMap) {
    id = locationMap['id'];
    lat = double.parse(locationMap['coordinates']['latitude']);
    lng = double.parse(locationMap['coordinates']['longitude']);
    streetName = locationMap['address']['street_name'];
    accessRestriction = locationMap['access_restriction'];
  }
}
