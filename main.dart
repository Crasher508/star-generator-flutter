import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

void main() {
  runApp(const StarGeneratorApp());
}

///Graphical overlay for generating svg stars using dart
///
///@Author Jonathan Beyer <https://github.com/Crasher508>
class StarGeneratorApp extends StatelessWidget {
  const StarGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Star Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const StarGeneratorHomePage(),
    );
  }
}

class StarGeneratorHomePage extends StatefulWidget {
  const StarGeneratorHomePage({super.key});

  @override
  State<StarGeneratorHomePage> createState() => _StarGeneratorHomePageState();
}

class _StarGeneratorHomePageState extends State<StarGeneratorHomePage> {
  late double _svgWidth;
  late double _svgHeight;
  int _starZacken = 5;
  double _starScale = 0.5;
  int _starRotation = 180;

  ///Generate star using svg polygon
  ///
  ///@Author Matthias Dohlenburg <https://replit.com/@MatthiasDohlenb>
  ///
  ///@param double x0     x-coordinate of the center
  ///@param double y0     y-coordinate of the center
  ///@param int    zacken count of peaks
  ///@param double inner  distance between low point and center
  ///@param double outer  distance between high point (peak) and center
  ///
  ///@return String
  String stern(double x0, double y0, int zacken, double inner, double outer) {
    //declarations
    String svg =
        '<polygon transform="rotate($_starRotation $x0 $y0)" id="star" points="';
    double winkel = (2 * pi) / zacken;
    List<double> ox = [];
    List<double> oy = [];
    List<double> ix = [];
    List<double> iy = [];
    //generate outer points
    for (int i = 0; i < zacken; i++) {
      ox.add(sin(i * winkel) * outer + x0);
      oy.add(cos(i * winkel) * outer + y0);
    } //generate inner points
    for (int i = 0; i < zacken; i++) {
      ix.add(sin((i + 0.5) * winkel) * inner + x0);
      iy.add(cos((i + 0.5) * winkel) * inner + y0);
    }
    //generate final string
    for (int i = 0; i < zacken; i++) {
      svg +=
          " ${(ox[i]).toInt()},${oy[i].toInt()} ${ix[i].toInt()},${iy[i].toInt()}";
    }
    svg += ' " fill="#ffd700"></polygon>';
    //animation? <animateTransform attributeName="transform" attributeType="XML" type="rotate" from="0 $x0 $y0" to="360 $x0 $y0" dur="10s" repeatCount="indefinite" />
    return svg;
  }

  Widget createSVGView(double width, double height) {
    double x0 = width * 0.5;
    double y0 = height * 0.5;
    double inner = 40 * _starScale;
    double outer = 100 * _starScale;
    String string = stern(x0, y0, _starZacken, inner, outer);
    return SvgPicture.string(
      '<svg id="StarView" data-name="Star" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="$width" height="$height" viewBox="0 0 $width $height">$string</svg>',
      width: width,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    _svgWidth = (MediaQuery.of(context).size.width * 1);
    _svgHeight = (MediaQuery.of(context).size.height * 0.6);
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: createSVGView(_svgWidth, _svgHeight),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Größe des Sterns: ${_starScale.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Slider(
                    value: _starScale,
                    min: 0.5,
                    max: 5,
                    label: _starScale.toString(),
                    onChanged: (double value) {
                      setState(() {
                        _starScale = value;
                      });
                    })
              ]),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Anzahl der Zacken: $_starZacken',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Slider(
                    value: _starZacken.toDouble(),
                    min: 5,
                    max: 40,
                    label: _starZacken.toString(),
                    onChanged: (double value) {
                      setState(() {
                        _starZacken = value.round();
                      });
                    })
              ]),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Drehung des Sterns in Grad: $_starRotation',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Slider(
                    value: _starRotation.toDouble(),
                    min: 0,
                    max: 360,
                    label: _starRotation.toString(),
                    onChanged: (double value) {
                      setState(() {
                        _starRotation = value.round();
                      });
                    })
              ]),
        )
      ],
    ));
  }
}
