import 'dart:io';

import 'package:Companion/utils/open_link.dart';
import 'package:archive/archive.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart' as provider;

void downloadRelease(String release, BuildContext ctx) async {
  var directory = await provider.getDownloadsDirectory();
  var fileLocation =
      "${directory.absolute.path}${Platform.pathSeparator}CRel-$release.";
  var url =
      "https://github.com/aguilaair/Companion/releases/download/$release/${Platform.operatingSystem.toLowerCase()}-$release.zip";
  var file = File("${fileLocation}zip");

  if (!await file.exists()) {
    showToast("Downloading...", context: ctx);
    http.get(url).then((response) {
      file.writeAsBytes(response.bodyBytes);
      showToast("Release downloaded!", context: ctx);
    });
  } else {
    showToast("File already downloaded, opening", context: ctx);
  }

  if (Platform.isWindows) {
    installWindows(file, fileLocation);
  }
  if (Platform.isMacOS) {
    installMacOS(file, fileLocation);
  } else {
    openLink("file://${fileLocation.replaceAll("\\", "/")}zip");
  }
}

void installWindows(File file, String path) async {
  var decompressed = ZipDecoder().decodeBytes(file.readAsBytesSync());
  var msix =
      decompressed.files.firstWhere((element) => element.name.contains("msix"));
  await File("${path}msix").writeAsBytes(msix.content);
  openLink("file://${path.replaceAll("\\", "/")}msix");
}

void installMacOS(File file, String path) async {
  var decompressed = ZipDecoder().decodeBytes(file.readAsBytesSync());
  var dmg =
      decompressed.files.firstWhere((element) => element.name.contains("dmg"));
  await File("${path}dmg").writeAsBytes(dmg.content);
  openLink("file://${path.replaceAll("\\", "/")}dmg");
}
