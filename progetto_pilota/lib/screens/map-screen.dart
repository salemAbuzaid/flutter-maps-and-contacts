import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progetto_pilota/data/station.dart';
import 'package:progetto_pilota/shared/info_window.dart';
import 'package:progetto_pilota/shared/menu_drawer.dart';
import 'package:progetto_pilota/data/http_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:clippy_flutter/clippy_flutter.dart';

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

  late CustomInfoWindowController _customInfoWindowController;

  List<Station> stations = [];

// Creates a custom location icon
  void addCustomIcon() {
    getBytesFromAsset("assets/location1.png", 150).then((markerLocationIcon) {
      setState(() {
        locationIcon = BitmapDescriptor.fromBytes(markerLocationIcon);
      });
    });
    /*  BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/location.png")
        .then(
      (icon) {
        setState(() {
          locationIcon = icon;
        });
      },
    ); */
  }

  void setStationsMarkers() {
    for (var station in stations) {
      MarkerId id = MarkerId(station.id);
      _markers[station.id] = Marker(
        markerId: id,
        position: LatLng(station.lat, station.lng),
        infoWindow: InfoWindow(
          title: station.streetName,
          snippet: 'this is a new start!!',
          onTap: () {
            AlertDialog(
              title: Text('this is a trial'),
            );
          },
        ),
/*         onTap: () {
           log(_customInfoWindowController.addInfoWindow.toString());
          log(_customInfoWindowController.toString());

          _customInfoWindowController.addInfoWindow!(
            getInfoWindow(context),
            LatLng(station.lat, station.lng),
          ); 
        }, */
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
      });
      mapcontroller?.animateCamera(CameraUpdate.newLatLng(_center));
    });
  }

  @override
  void initState() {
    super.initState();
    _location = Location();

    addCustomIcon();
    getStations();
    setStationsMarkers();
    updateUserLocation();
    _customInfoWindowController = CustomInfoWindowController();
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
        setStationsMarkers();
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
                onPressed: () {},
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
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, right: 12),
              alignment: Alignment.topRight,
              child: Column(
                children: [
/*                   FloatingActionButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.layers_sharp,
                      size: 30.0,
                    ),
                    backgroundColor: Colors.white,
                  ), */
                  Container(
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
                  ),
                  Padding(
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
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    _buildPopupDialog(context));
                          },
                        )),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapcontroller = controller;
    updateUserLocation();
  }

  @override
  void dispose() {
    _locationSubscription.cancel();
    mapcontroller?.dispose();
    _customInfoWindowController.dispose();
    stations.clear();
    _markers.clear();
    _markers.forEach((key, value) {
      log('here see the remaining markers...');
      log(key.toString() + " " + value.toString());
    });
    super.dispose();
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Stations'),
      content: Row(
        children: [
          Column(),
          Column(),
        ],
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
        )
      ],
    );
  }
}
