import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/utils/isar_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isar = await openAppIsar();
  runApp(
    ProviderScope(
      overrides: [
        appIsarProvider.overrideWithValue(isar),
      ],
      child: const ProductivityHubApp(),
    ),
  );
}

