import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

// Источники картографических данных
const URL_SPUTNIK_TEMPLATE = "http://tiles.maps.sputnik.ru/{z}/{x}/{y}.png";
const URL_OSM_TEMPLATE = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";



class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  MapController _controller = MapController();
  late Position _current;

  @override
  void initState() {
    super.initState();
    initPosition();
  }

  void initPosition() async {
    _current = (await Geolocator.getLastKnownPosition())!;
    _updateLocation();
  }

  Future<void> _updateCurrent() async {
    await Geolocator.getCurrentPosition().then((Position position){
      _current = position;
    }).catchError((e) {
      print(e);
    });
  }

  void _updateLocation() {
    _updateCurrent();
    LatLng center = new LatLng(_current.latitude, _current.longitude);
    _controller.move(center, 14);
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: [
        FlutterMap(
          options: MapOptions(
              center: LatLng(59.939095, 30.315868),
              zoom: 13.0,
              minZoom: 1,
              maxZoom: 17
          ),
          mapController: _controller,
          layers: [
            TileLayerOptions(
              urlTemplate: URL_OSM_TEMPLATE,
              subdomains: ['a', 'b', 'c']
            )
          ],
        ),
        Align(
          child: Padding(
              padding: EdgeInsets.all(25),
              child : FloatingActionButton(
                child: Icon(
                  Icons.gps_fixed_sharp,
                  color: Colors.white,
                  semanticLabel: 'Update a GPS location',
                ),
                onPressed: _updateLocation,
              )
          ),
          alignment: Alignment.bottomRight,
        )
      ],
    );
  }
}