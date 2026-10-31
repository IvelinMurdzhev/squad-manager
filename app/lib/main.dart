import 'package:flutter/material.dart';

import 'app.dart';
import 'routing/auth_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SquadManagerApp(authState: StubAuthState()));
}
