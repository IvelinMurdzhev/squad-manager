import 'package:flutter/material.dart';

import 'app.dart';
import 'data/services/firebase_bootstrap.dart';
import 'routing/auth_state.dart';
import 'ui/core/startup_failure_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await initializeFirebase();
  } on Object catch (error, stackTrace) {
    // Log the type only: the message could carry configuration details.
    debugPrint('Firebase bootstrap failed: ${error.runtimeType}');
    debugPrintStack(stackTrace: stackTrace, maxFrames: 5);
    runApp(const StartupFailureApp());
    return;
  }
  runApp(SquadManagerApp(authState: StubAuthState()));
}
