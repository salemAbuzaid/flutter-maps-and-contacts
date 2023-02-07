import 'dart:developer';

import 'package:progetto_pilota/data/port.dart';

class Station {
  String id = '';
  double lat = 0.0;
  double lng = 0.0;
  String streetName = '';
  String accessRestriction = '';
  List<Port> ports = [];

  Station(this.id, this.lat, this.lng, this.ports);

  Station.fromJson(Map<String, dynamic> locationMap) {
    id = locationMap['id'];
    lat = double.parse(locationMap['coordinates']['latitude']);
    lng = double.parse(locationMap['coordinates']['longitude']);
    streetName = locationMap['address']['street_name'];
    accessRestriction = locationMap['access_restriction'];
    extractPorts(locationMap['stations'][0]['ports']);
  }

  void extractPorts(List<dynamic> portsJson) {
    for (Map<String, dynamic> port in portsJson) {
      ports.add(Port.fromJson(port));
    }
  }

  int availablePorts() {
    int availablePorts = 0;
    for (Port port in ports) {
      if (port.status == "AVAILABLE") {
        availablePorts++;
      }
    }
    return availablePorts;
  }
}
