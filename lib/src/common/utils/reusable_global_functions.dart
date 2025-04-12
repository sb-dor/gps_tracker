import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final class ReusableGlobalFunctions {
  static ReusableGlobalFunctions? _instance;

  static ReusableGlobalFunctions get instance => _instance ??= ReusableGlobalFunctions._();

  ReusableGlobalFunctions._();

  bool get isDesktop =>
      defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.windows;

  bool get isMacOsOriOS => switch (defaultTargetPlatform) {
    TargetPlatform.iOS => true,
    TargetPlatform.macOS => true,
    _ => false,
  };

  void showSnackBar({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
