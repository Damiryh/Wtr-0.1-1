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
    _controller.move(center, 14);//контроллер отображает на экране указанную точку, 14 - это зум
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





  /*
  есть кэш на устройстве, есть данные на сервере

  -1. создать класс "область": геолокация, [точки поилки]

  0. если кэш не пуст, то вычислить расстояние между текущей геолокацией и всеми хранящимися в кеше. если пуст, то шаг 3
  1. если расстояние не превышает, то не грузить
  2. если расстояния превышает, то грузить с сервера
  3. отправить по апи геолокацию на сервер, получить массив точек
  4. создать экземпляр класса Область, добавить в него геолокацию, полученный массив точек
  5. сохранить в кэш

  нахождение ближайших 4х в области .......(цикл - расширять пока не найдутся 4 точки)
  6. проверка входят ли точки в окружность:
  6.1 ....

   */
  class MyApp  {
  @override
  MyAppState createState() => new MyAppState();
  }

}