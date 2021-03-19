import 'dart:io';

import 'package:Companion/utils/open_link.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart' as provider;

void downloadRelease(String release, BuildContext ctx) async {
  var directory = await provider.getDownloadsDirectory();
  var zipLocation =
      "${directory.absolute.path}${Platform.pathSeparator}CRel-$release.zip";
  var url =
      "https://github.com/aguilaair/Companion/releases/download/$release/${Platform.operatingSystem.toLowerCase()}-$release.zip";
  if (!await File(zipLocation).exists()) {
    showToast("Downloading...", context: ctx);
    http.get(url).then((response) {
      File(zipLocation).writeAsBytes(response.bodyBytes);
      showToast("Release downloaded! Please install manually...", context: ctx);
      openLink("file://${zipLocation.replaceAll("\\", "/")}");
    });
  }
}
