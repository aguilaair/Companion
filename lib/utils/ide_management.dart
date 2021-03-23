import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:oktoast/oktoast.dart';

import 'open_link.dart';

class Ide {
  String name;
  String identifier;
  IconData icon;
  Function open;

  Ide({
    this.icon,
    this.identifier,
    this.name,
    this.open,
  });

  void launch(String path) {
    open(path);
  }
}

Map<String, Ide> ideMap = {
  "vsCode": Ide(
    icon: MdiIcons.microsoftVisualStudioCode,
    identifier: "vsCode",
    name: "Visual Studio Code",
    open: openInVSCode,
  ),
  "studio": Ide(
    icon: MdiIcons.androidStudio,
    identifier: "studio",
    name: "Android Studio",
    open: (_) {},
  ),
  "intellij": Ide(
    icon: Icons.code_rounded,
    identifier: "intellij",
    name: "IntelliJ Idea",
    open: (_) {},
  ),
  "none": Ide(
    icon: Icons.browser_not_supported_rounded,
    identifier: "none",
    name: "None",
    open: (_) {},
  ),
};

void openInVSCode(String path) {
  if (Platform.isWindows) {
    _openVSCodeWindows(path);
  } else if (Platform.isMacOS) {
    _openVSCodeMacOS(path);
  } else {
    vsCodemultiplatformFallback(path);
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

void vsCodemultiplatformFallback(String path) {
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
