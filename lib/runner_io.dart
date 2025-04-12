// Only non-web Flutter apps, command-line scripts, and servers can import and use dart:io, not web apps.
import 'package:flutter/material.dart';
import 'package:gps_tracker/src/common/utils/reusable_global_functions.dart';
import 'package:gps_tracker/src/features/initialization/logic/app_runner.dart';
import 'package:window_manager/window_manager.dart';

const desktopMinSize = Size(600, 600);

void run() async {
  if (ReusableGlobalFunctions.instance.isDesktop) {
    await windowManager.ensureInitialized();
    final WindowOptions windowOptions = WindowOptions(
      size: desktopMinSize,
      minimumSize: desktopMinSize,
      center: true,
      backgroundColor: Colors.transparent,
      // skipTaskbar: false,
      // titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  await AppRunner().initialize();
}