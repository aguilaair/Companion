import 'dart:io';

import 'package:Companion/utils/open_link.dart';
import 'package:archive/archive.dart';
import 'package:flutter/cupertino.dart';
import 'package:github/github.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart' as provider;
import 'package:version/version.dart';

import '../components/molecules/update_card.dart';
import '../constants.dart';
import 'http_cache.dart';

void downloadRelease(String release) async {
  var directory = await provider.getDownloadsDirectory();
  var fileLocation =
      "${directory.absolute.path}${Platform.pathSeparator}CRel-$release.";
  var url =
      "https://github.com/aguilaair/Companion/releases/download/$release/${Platform.operatingSystem.toLowerCase()}-$release.zip";
  var file = File("${fileLocation}zip");

  if (!await file.exists()) {
    showToast("Downloading...");
    var res = await http.get(url);
    await file.writeAsBytes(res.bodyBytes);
    showToast("Release downloaded! Opening...");
  } else {
    showToast("File already downloaded, opening...");
  }
  openInstaller(file, fileLocation);
}

void openInstaller(File file, String fileLocation) {
  if (Platform.isWindows) {
    installWindows(file, fileLocation);
  } else if (Platform.isMacOS) {
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

void checkForUpdates(BuildContext ctx) async {
  var installedVersion;
  try {
    installedVersion = Version.parse(appVersion);
  } on FormatException catch (_) {
    installedVersion = Version(0, 0, 1);
  }

  var latestRelease = await GitHub(
          auth: Authentication.withToken(
            Hive.box("settings").get("gh_token"),
          ),
          client: CacheHttpClient())
      .repositories
      .getLatestRelease(
        RepositorySlug("aguilaair", "companion"),
      );

  var latestVersion = Version.parse(latestRelease.tagName);

  if (latestVersion > installedVersion) {
    ToastFuture toast;

    void dismisstoast() {
      toast.dismiss(showAnim: true);
    }

    toast = showToastWidget(
      UpdateAvailableCard(() {
        downloadRelease(latestRelease.tagName);
        Future.delayed(const Duration(seconds: 1)).then((_) {
          dismisstoast();
        });
      }, dismisstoast),
      //backgroundColor: Colors.green,
      handleTouch: true,
      position: const ToastPosition(
        align: Alignment(0.95, 0.95),
      ),
      duration: const Duration(seconds: 60),
      //textPadding: const EdgeInsets.all(20),
    );
  }
}
