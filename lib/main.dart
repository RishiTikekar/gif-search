import 'package:flutter/material.dart';
import './gif_body.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'gif_search',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,

        accentColor: Colors.grey,
      ),
      home: Theme(
        data: ThemeData.dark(),
        child: GifBody(),),
    );
  }
}
