import 'dart:io';

import 'package:hive/hive.dart';

void initHive() async {
  Hive.init(Directory.current.path);
  await Hive.openBox("settings");
}
