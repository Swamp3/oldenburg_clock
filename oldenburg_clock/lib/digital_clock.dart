// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Modified by Timo Alts <timo.alts+flutterclock@gmail.com> 06.01.2020

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'globals.dart' as globals;

/// A basic digital clock.
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
    var iconSize = globals.textSize * .6;
    switch (condition) {
      case 'cloudy':
        _weatherIcon = Icon(
          Icons.wb_cloudy,
          color: Colors.lightBlue,
          size: iconSize,
          semanticLabel: "${globals.semantics['weather']} $_condition",
        );
        break;
      case 'foggy':
        _weatherIcon = Icon(
          Icons.texture,
          color: Colors.lightBlue,
          size: iconSize,
          semanticLabel: "${globals.semantics['weather']} $_condition",
        );
        break;
      case 'rainy':
        _weatherIcon = Icon(
          Icons.grain,
          color: Colors.blue,
          size: iconSize,
          semanticLabel: "${globals.semantics['weather']} $_condition",
        );
        break;
      case 'snowy':
        _weatherIcon = Icon(
          Icons.ac_unit,
          color: Colors.grey,
          size: iconSize,
          semanticLabel: "${globals.semantics['weather']} $_condition",
        );
        break;
      case 'sunny':
        _weatherIcon = Icon(
          Icons.wb_sunny,
          color: Colors.yellow,
          size: iconSize,
          semanticLabel: "${globals.semantics['weather']} $_condition",
        );
        break;
      case 'thunderstorm':
        _weatherIcon = Icon(
          Icons.flash_on,
          color: Colors.yellow,
          size: iconSize,
          semanticLabel: "${globals.semantics['weather']} $_condition",
        );
        break;
      case 'windy':
        _weatherIcon = Icon(
          Icons.toys,
          color: Colors.blue,
          size: iconSize,
          semanticLabel: "${globals.semantics['weather']} $_condition",
        );
        break;
      default:
        _weatherIcon = Icon(
          Icons.help_outline,
          color: Colors.red,
          size: iconSize,
          semanticLabel: "${globals.semantics['weather']} $_condition",
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
    globals.colors["text"] = Colors.black;
    globals.colors["background"] = Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).platformBrightness == Brightness.light) {
      setLightTheme();
    }

    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    globals.textSize = MediaQuery.of(context).size.width / 5;
    final defaultStyle = TextStyle(
      color: globals.colors['text'],
      fontFamily: globals.defaultFont,
      fontSize: globals.textSize,
    );
    final smallTextStyle = defaultStyle.apply(fontSizeFactor: .15);

    final timeRow = Container(
        child: Row(children: [
      Expanded(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Center(
            child: Text(
              hour[0],
              semanticsLabel: "${globals.semantics['hour']} $hour",
            ),
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
            child: Text(
              minute[0],
              semanticsLabel: "${globals.semantics['minute']} $minute",
            ),
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
          style: smallTextStyle,
          child: Center(
              child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              _location,
              semanticsLabel: "${globals.semantics['location']} $_location",
            ),
          )),
        ),
      ),
      Expanded(
        child: DefaultTextStyle(
          style: smallTextStyle,
          child: Center(
            child: _weatherIcon,
          ),
        ),
      ),
      Expanded(
        child: DefaultTextStyle(
          style: smallTextStyle,
          child: Center(
            child: Text(
              _temperature,
              semanticsLabel:
                  "${globals.semantics['temperature']} $_temperature",
            ),
          ),
        ),
      ),
    ]));

    return Container(
      color: globals.colors['background'],
      child: Center(
          child: Column(children: [
        Expanded(flex: 3, child: timeRow),
        Expanded(flex: 2, child: weatherRow),
      ])),
    );
  }
}
