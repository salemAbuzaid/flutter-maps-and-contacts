import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progetto_pilota/data/port.dart';
import 'package:progetto_pilota/data/station.dart';
import 'package:progetto_pilota/screens/login.dart';
import 'package:progetto_pilota/shared/info_window.dart';
import 'package:progetto_pilota/shared/menu_drawer.dart';
import 'package:progetto_pilota/data/http_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapcontroller;

  LatLng _center = LatLng(45.068607, 7.676959);

  late Location _location;

  MapType _mapType = MapType.normal;

  late StreamSubscription _locationSubscription;

  Map<String, Marker> _markers = Map();

  BitmapDescriptor locationIcon = BitmapDescriptor.defaultMarker;

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  final TextEditingController txtMinPower = TextEditingController();

  final TextEditingController txtMaxPower = TextEditingController();

  List<Station> stations = [];
  List<Station> filteredStations = [];

// Creates a custom location icon
  void addCustomIcon() {
    getBytesFromAsset("assets/location1.png", 120).then((markerLocationIcon) {
      setState(() {
        locationIcon = BitmapDescriptor.fromBytes(markerLocationIcon);
      });
    });
  }

  setStationsMarkers() {
    // await getStations();
    addCustomIcon();
    String description = '';

    for (var station in filteredStations) {
      description = "Access Restriction: ${station.accessRestriction}\n Ports:";
      MarkerId id = MarkerId(station.id);
      _markers[station.id] = Marker(
        markerId: id,
        position: LatLng(station.lat, station.lng),
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            getInfoWindow(context, station),
            LatLng(station.lat, station.lng),
          );
        },
      );
    }
  }

// gets stations from the backend server
  Future getStations() async {
    HttpHelper httpHelper = HttpHelper();
    stations = await httpHelper.getLocations();
  }

// transforms the image to list of bytes to be used as an icon
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void updateUserLocation() {
    _location.getLocation().then((value) {
      setState(() {
        _center = LatLng(value.latitude!, value.longitude!);

        MarkerId id = MarkerId("MyLocation");
        _markers["MyLocation"] = Marker(
          markerId: id,
          position: /* LatLng(lat, lng) */ _center,
          icon: locationIcon,
        );
      });
      mapcontroller?.animateCamera(CameraUpdate.newLatLng(_center));
    });
  }

  @override
  void initState() {
    super.initState();
    _location = Location();

    addCustomIcon();
    // getStations();
    // setStationsMarkers();
    updateUserLocation();
    // _customInfoWindowController = CustomInfoWindowController();
    // mapcontroller?.animateCamera(CameraUpdate.newLatLng(_center));

    bool serviceEnabled /* = await _location.serviceEnabled() */;
    _location.serviceEnabled().then((value) {
      serviceEnabled = value;
      if (!serviceEnabled) {
        // serviceEnabled = await _location.requestService();
        _location.requestService().then((value) => serviceEnabled = value);
        if (!serviceEnabled) {
          return;
        }
      }
    });

    PermissionStatus permissionGranted /* = await _location.hasPermission() */;
    _location.hasPermission().then((value) {
      permissionGranted = value;
      if (permissionGranted == PermissionStatus.denied) {
        // permissionGranted = await _location.requestPermission();
        _location
            .requestPermission()
            .then((value) => permissionGranted = value);
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
    });

    _locationSubscription =
        _location.onLocationChanged.listen((LocationData currentLocation) {
/*       double lat = currentLocation.latitude ?? 45.068607;
      double lng = currentLocation.latitude ?? 7.676959;
      log("onLocationChanged " + lat.toString() + " " + lng.toString()); */
      // mapcontroller?.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
      // updateUserLocation();
      setState(() {
        MarkerId id = MarkerId("MyLocation");
        _markers["MyLocation"] = Marker(
            markerId: id,
            position: /* LatLng(lat, lng) */ _center,
            icon: locationIcon);
        // mapcontroller?.animateCamera(CameraUpdate.newLatLng(_center));

        // setStationsMarkers();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: (AppBar(
          centerTitle: false,
/*         leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ), */
          title: Text('Map'),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName('/'),
                  );
                },
                icon: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 40,
                ))
          ],
        )),
        drawer: MenuDrawer(),
        body: Stack(
          children: [
            Container(
              child: GoogleMap(
                mapType: _mapType,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 15.0,
                ),
                markers: Set<Marker>.of(_markers.values),
                onCameraMove: ((position) {
                  if (_customInfoWindowController.onCameraMove != null)
                  _customInfoWindowController.onCameraMove!();
                }),
                onTap: ((position) {
                  _customInfoWindowController.hideInfoWindow!();
                }),
              ),
            ),
            CustomInfoWindow(
              controller: _customInfoWindowController,
              height: 150,
              width: 200,
              offset: 50,
            ),
            Container(
              padding: EdgeInsets.only(top: 20, right: 12),
              alignment: Alignment.topRight,
              child: Column(
                children: [
                  _buildMapTypeLayer(),
                  _buildFilter(context),
                ],
              ),
            )
          ],
        ));
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapcontroller = controller;
    _customInfoWindowController.googleMapController = controller;
    await getStations();
    filteredStations = List<Station>.from(stations);
    setStationsMarkers();
    updateUserLocation();
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    mapcontroller?.dispose();
    _customInfoWindowController.dispose();
    stations.clear();
    _markers.clear();
    super.dispose();
  }

  Widget _buildMapTypeLayer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: PopupMenuButton(
        icon: Icon(
          Icons.layers,
          size: 30.0,
        ),
        color: Colors.white,
        initialValue: _mapType,
        onSelected: (type) {
          setState(() {
            _mapType = type as MapType;
          });
        },
        itemBuilder: (context) => <PopupMenuEntry<MapType>>[
          const PopupMenuItem<MapType>(
            value: MapType.normal,
            child: Text('Normal'),
          ),
          const PopupMenuItem<MapType>(
            value: MapType.satellite,
            child: Text('Satellite'),
          ),
          const PopupMenuItem<MapType>(
            value: MapType.terrain,
            child: Text('Terrain'),
          ),
          const PopupMenuItem<MapType>(
            value: MapType.none,
            child: Text('None'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            // border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          child: IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
/*               showDialog(
                  context: context,
                  builder: (context) => _buildPopupDialog(context)); */
              _buildPopupDialog(context);
            },
          )),
    );
  }

  Future<dynamic> _buildPopupDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Filter Stations'),
            content: SingleChildScrollView(
              child: Column(
                children: [
/*                   GestureDetector(
                    onTap: () {
                      filteredStations = stations;
                      setState(() {});
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.close),
                          Text("Filter")
                        ],
                      ),
                    ),
                  ), */
                  TextField(
                    controller: txtMinPower,
                    decoration: InputDecoration(hintText: "Min Power In KW"),
                  ),
                  TextField(
                    controller: txtMaxPower,
                    decoration: InputDecoration(hintText: "Max Power In KW"),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              filteredStations.length != stations.length
                  ? TextButton(
                      // style: ButtonStyle(),
                      onPressed: () {
                        filteredStations = stations;
                        setStationsMarkers();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Remove Filter',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : SizedBox(width: 0, height: 0),
              TextButton(
                // style: ButtonStyle(),
                onPressed: savePreferences,
                child: Text('Save'),
              ),
            ],
          );
        });
  }

  savePreferences() {
    double minPower = double.tryParse(txtMinPower.text) ?? 0;
    double maxpower = double.tryParse(txtMaxPower.text) ?? 0;
    if (txtMinPower.text == '' || txtMaxPower.text == '') {
      return;
    }
    filteredStations.clear();
    for (var station in stations) {
      for (var port in station.ports) {
        if (port.power >= minPower && port.power <= maxpower) {
          filteredStations.add(station);
        }
        break;
      }
    }
    _markers.clear();
    updateUserLocation();
    setStationsMarkers();
    // log(filteredStations.length.toString());

/*     log(_markers.length.toString());
    txtMinPower.text = '';
    txtMaxPower.text = ''; */
    Navigator.pop(context);
  }
}
