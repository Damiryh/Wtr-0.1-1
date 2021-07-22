import 'package:flutter/material.dart';
import 'MyApp.dart';

Future<void> main() async {
  await Hive.initFlutter();
  runApp(new MaterialApp( debugShowCheckedModeBanner: false, home: MyApp()));
}