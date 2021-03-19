import 'dart:io';

import 'package:oktoast/oktoast.dart';

import 'open_link.dart';

void openInVSCode(String path) {
  if (Platform.isWindows) {
    _openVSCodeWindows(path);
  } else if (Platform.isMacOS) {
    _openVSCodeMacOS(path);
  } else {
    multiplatformFallback(path);
  }
}

void _openVSCodeViaUrl(String path) {
  showToast("There was an error opening VSCode,"
      " make sure that it is installed. Opening via URL...");
  openLink("vscode://file/$path");
}

void _openVSCodeWindows(String path) {
  var pathInfo = Platform.environment["PATH"];
  var vsCode = pathInfo.split(";").firstWhere(
        (element) => element.contains("VS Code"),
      );
  Process.run("$vsCode\\code.cmd", [path]).then(
    (value) {
      if (value.exitCode != 0) {
        _openVSCodeViaUrl(path);
      }
    },
  ).onError((error, stackTrace) {
    _openVSCodeViaUrl(path);
  });
}

void _openVSCodeMacOS(String path) async {
  const pathNormal =
      "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/";
  const pathInsider =
      "/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/";
  if (await Directory(pathNormal).exists()) {
    Process.run("./code", [path], workingDirectory: pathNormal).then(
      (value) {
        if (value.exitCode != 0) {
          _openVSCodeViaUrl(path);
        }
      },
    ).onError((error, stackTrace) {
      _openVSCodeViaUrl(path);
    });
  } else if (await Directory(pathInsider).exists()) {
    Process.run("./code", [path], workingDirectory: pathInsider).then(
      (value) {
        if (value.exitCode != 0) {
          _openVSCodeViaUrl(path);
        }
      },
    ).onError((error, stackTrace) {
      _openVSCodeViaUrl(path);
    });
  } else {
    _openVSCodeViaUrl(path);
  }
}

void multiplatformFallback(String path) {
  Process.run("code", [path], runInShell: true).then(
    (value) {
      if (value.exitCode != 0) {
        _openVSCodeViaUrl(path);
      }
    },
  ).onError((error, stackTrace) {
    _openVSCodeViaUrl(path);
  });
}
