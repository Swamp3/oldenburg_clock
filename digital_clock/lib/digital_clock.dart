// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'globals.dart' as globals;

enum _Element {
  background,
  text,
  shadow,
}

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
};

final _lightTheme = {
  _Element.background: Colors.white,
  _Element.text: Colors.black,
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  var _temperature = '';
  var _condition = '';
  var _location = '';
  var _weatherIcon;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateWeatcherContitionIcon(String condition) {
    // define common icon style variables
    var iconSize = 50.0;
    var iconColor = Colors.white;
    switch (condition) {
      case 'cloudy':
        _weatherIcon = Icon(
          Icons.wb_cloudy,
          color: iconColor,
          size: iconSize,
          semanticLabel: 'weather condition is $_condition',
        );
        break;
      case 'foggy':
        _weatherIcon = Icon(
          Icons.texture,
          color: iconColor,
          size: iconSize,
          semanticLabel: 'weather condition is $_condition',
        );
        break;
      case 'rainy':
        _weatherIcon = Icon(
          Icons.grain,
          color: iconColor,
          size: iconSize,
          semanticLabel: 'weather condition is $_condition',
        );
        break;
      case 'snowy':
        _weatherIcon = Icon(
          Icons.ac_unit,
          color: iconColor,
          size: iconSize,
          semanticLabel: 'weather condition is $_condition',
        );
        break;
      case 'sunny':
        _weatherIcon = Icon(
          Icons.wb_sunny,
          color: iconColor,
          size: iconSize,
          semanticLabel: 'weather condition is $_condition',
        );
        break;
      case 'thunderstorm':
        _weatherIcon = Icon(
          Icons.flash_on,
          color: iconColor,
          size: iconSize,
          semanticLabel: 'weather condition is $_condition',
        );
        break;
      case 'windy':
        _weatherIcon = Icon(
          Icons.toys,
          color: iconColor,
          size: iconSize,
          semanticLabel: 'weather condition is $_condition',
        );
        break;
      default:
        _weatherIcon = Icon(
          Icons.help_outline,
          color: iconColor,
          size: iconSize,
          semanticLabel: 'weather condition is unknown',
        );
    }
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
      _temperature = widget.model.temperatureString;
      _condition = widget.model.weatherString;
      _location = widget.model.location;
      _updateWeatcherContitionIcon(_condition);
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  void setLightTheme() {
    globals.colors["text"] = Colors.white;
    globals.colors["background"] = Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final colors = MediaQuery.of(context).platformBrightness == Brightness.light
        ? setLightTheme()
        : setLightTheme();

    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 6;
    final secondFontSize = fontSize / 5;
    final defaultStyle = TextStyle(
      color: globals.colors["text"],
      fontFamily: 'Oldenburg',
      fontSize: fontSize,
    );
    final secondTextStyle = TextStyle(
      color: globals.colors["text"],
      fontFamily: 'Oldenburg',
      fontSize: secondFontSize,
    );

    final timeRow = Container(
        child: Row(children: [
      Expanded(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Center(
            child: Text(hour[0]),
          ),
        ),
      ),
      Expanded(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Center(
            child: Text(hour[1]),
          ),
        ),
      ),
      Expanded(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Center(
            child: Text(':'),
          ),
        ),
      ),
      Expanded(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Center(
            child: Text(minute[0]),
          ),
        ),
      ),
      Expanded(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Center(
            child: Text(minute[1]),
          ),
        ),
      ),
    ]));

    final weatherRow = Container(
        child: Row(children: [
      Expanded(
        flex: 2,
        child: DefaultTextStyle(
          style: secondTextStyle,
          child: Center(
              child: Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Text(_location),
          )),
        ),
      ),

      Expanded(
        child: DefaultTextStyle(
          style: secondTextStyle,
          child: Center(
              child: Container(
            child: _weatherIcon,
          )),
        ),
      ),
      Expanded(
        child: DefaultTextStyle(
          style: secondTextStyle,
          child: Center(
              child: Container(
            child: Text(_temperature),
          )),
        ),
      ),
      // Container(
      //   child: DefaultTextStyle(
      //       style: secondTextStyle,
      //       child: Container(
      //           alignment: Alignment.topRight, child: Text(second))),
      // ),
    ]));

    return Container(
      color: globals.colors["background"],
      child: Center(
          child: Column(children: [
        Expanded(flex: 3, child: timeRow),
        Expanded(flex: 2, child: weatherRow),
      ])),
    );
  }
}
