// Only non-web Flutter apps, command-line scripts, and servers can import and use dart:io, not web apps.
import 'package:flutter/material.dart';
import 'package:gps_tracker/src/features/initialization/logic/app_runner.dart';


void run() async => await AppRunner().initialize();
