// Copyright 2020 Timo Alts. All rights reserved.
// Timo Alts <timo.alts+flutterclock@gmail.com>
// created: 06.01.2020

library melmo_oldenburg_clock.globals;

import 'package:flutter/material.dart';

String defaultFont = 'Oldenburg';
Map<String, Color> colors = {
  "text": Colors.white,
  "background": Colors.black,
};
double textSize = 80.0;
Map<String, String> semantics = {
  "weather": "The weather condition is",
  "hour": "The current hour is",
  "minute": "The current minute is",
  "location": "The current location is",
  "temperature": "The current temperature is",
};
