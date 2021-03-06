import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> initHive() async {
  final docPath = await getApplicationSupportDirectory();
  try {
    Hive.init("${docPath.path}/flutter_companion");
    await Hive.openBox("settings");
  } on FileSystemException catch (e) {
    print("Oh no, there are multiple instances trying to load settings");
    throw "Error loading database $e";
  }
}
