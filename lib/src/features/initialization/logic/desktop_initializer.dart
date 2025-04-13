import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

const desktopMinSize = Size(600, 600);

class DesktopInitializer {
  Future<void> run() async {
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
}
