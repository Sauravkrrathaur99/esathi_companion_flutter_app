// app_lifecycle_observer.dart

import 'package:flutter/widgets.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      // App moved to background
      print("App in android background");
    } else if (state == AppLifecycleState.resumed) {
      // App moved to foreground
      print("App in android foreground");
    } else if (state == AppLifecycleState.inactive) {
      // App is inactive (can occur when transitioning)
      print("App android inactive");
    } else if (state == AppLifecycleState.detached) {
      // App is detached (not visible)
      print("App android detached");
    }
  }
}

