import 'dart:io';

import 'package:Companion/app_shell.dart';

import 'package:Companion/theme.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Companion/utils/get_theme_mode.dart';
import 'package:Companion/utils/init_hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:oktoast/oktoast.dart';
import 'package:window_size/window_size.dart';

void main() async {
  await initHive().onError((error, stackTrace) => exit(0));
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Companion');
    setWindowMinSize(const Size(700, 500));
    setWindowMaxSize(Size.infinite);
  }
  runApp(ProviderScope(child: FvmApp()));
}

class FvmApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: ValueListenableBuilder(
        valueListenable: Hive.box('settings').listenable(),
        builder: (context, value, child) => MaterialApp(
          title: 'Companion',
          debugShowCheckedModeBanner: false,
          theme: lightTheme(),
          darkTheme: darkTheme(),
          themeMode: getThemeMode(
            value.get("brightness", defaultValue: "system"),
          ),
          home: const AppShell(),
        ),
      ),
    );
  }
}
