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
  double _zoom = 7;//масштаба
  bool isLocationServiceEnabled = false;



  @override
  void initState() {
    super.initState();
    initPosition();
    tryGeo();
  }

  void initPosition() async {
    _current = (await Geolocator.getLastKnownPosition())!;
    _updateLocation();
    isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();//метод показывающий включена ли служба определения геопозиции
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
    _controller.move(center, _zoom);//_zoom позволит соблюдать масштаб при переопределении геопозиции
  }

  void _zoomPlus() {
    LatLng center = new LatLng(_current.latitude, _current.longitude);
    _zoom += 0.5;
    _controller.move(center, _zoom);
  }

  void _zoomMinus() {
    LatLng center = new LatLng(_current.latitude, _current.longitude);
    _zoom -= 0.5;
    _controller.move(center, _zoom);
  }

  Widget tryGeo() {
    if (isLocationServiceEnabled)
      {
       return Text("Yes",
        textDirection: TextDirection.ltr,       // текст слева направо
        textAlign: TextAlign.center,            // выравнивание по центру
        style: TextStyle(color: Colors.green,   // зеленый цвет текста
        fontSize: 26,                       // высота шрифта 26
        backgroundColor: Colors.black87));
      }     // черный цвет фона текста
    else
       return Text("No");

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
              urlTemplate: URL_SPUTNIK_TEMPLATE,
             //subdomains: ['a', 'b', 'c']
            )
          ],
        ),
        Align(
          child: Padding(
              padding: EdgeInsets.all(25),
              child : /*FloatingActionButton(
                child: Icon(
                  Icons.gps_fixed_sharp,
                  color: Colors.white,
                  semanticLabel: 'Update a GPS location',
                ),
                onPressed: _updateLocation,
              )*/
              Column(children:[
                FloatingActionButton(
                child: Icon(
                  Icons.gps_fixed_sharp,
                  color: Colors.white,
                  semanticLabel: 'Update a GPS location',
                ),
                onPressed: _updateLocation,),

                FloatingActionButton(
                  child: Icon(
                    Icons.add,
                    color: Colors.greenAccent,
                    semanticLabel: 'Zoom plus',
                  ),
                  onPressed: _zoomPlus,),

                FloatingActionButton(
                  child: Icon(
                    Icons.horizontal_rule,
                    color: Colors.white,
                    semanticLabel: 'Zoom minus',
                  ),
                  onPressed: _zoomMinus,),
              ]
              )



          ),
          alignment: Alignment.bottomRight,
        ),


        Align(
            child: tryGeo(),
          alignment:Alignment.center ,
        )


      ],
    );
  }
}