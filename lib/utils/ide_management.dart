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
    open: openInAndroidStudio,
  ),
  "intellij": Ide(
    icon: Icons.code_rounded,
    identifier: "intellij",
    name: "IntelliJ Idea",
    open: openInIntelliJ,
  ),
  "none": Ide(
    icon: Icons.browser_not_supported_rounded,
    identifier: "none",
    name: "None",
    open: (_) {},
  ),
};

// IntelliJ Opening Logic

void openInIntelliJ(String path) {
  if (Platform.isWindows) {
    _openIJWindows(path);
  } else if (Platform.isLinux) {
    _openIJLinux(path);
  } else if (Platform.isMacOS) {
    _openIJMacOS(path);
  }
}

void _openIJMacOS(String path) {
  var intelliJ = File("/Applications/Intellij IDEA.app/Contents/MacOS/idea");
  var intelliJToolbox = File("/Library/Application Support/JetBrains/"
      "Toolbox/apps/Intellij IDEA.app/Contents/MacOS/idea");

  if (intelliJ.existsSync()) {
    _processRunIJ(intelliJ.absolute.path, path);
  } else if (intelliJToolbox.existsSync()) {
    _processRunIJ(intelliJToolbox.absolute.path, path);
  } else {
    showToast("Could not locate an InetlliJ IDEA installation");
  }
}

void _openIJWindows(String path) {
  var intelliJDir = Directory("C:\\Program Files\\JetBrains");
  print(intelliJDir.listSync());

  try {
    var dir = File(
        "${intelliJDir.listSync().firstWhere((element) => element.absolute.path.contains("IntelliJ IDEA")).absolute.path}\\bin\\idea64.exe");
    _processRunIJ(dir.absolute.path, path);
    // ignore: avoid_catching_errors
  } on StateError {
    showToast("Could not locate an InetlliJ IDEA installation");
  }
}

void _openIJLinux(String path) {
  var androidStudioSh = File("/opt/IdeaIU/bin/idea.sh");
  var androidStudioShLocal = File("/usr/local/IdeaIU/bin/idea.sh");
  var androidStudioShBin = File("/usr/bin/IdeaIU/bin/idea.sh");
  if (androidStudioSh.existsSync()) {
    _processRunIJ(androidStudioSh.absolute.path, path);
  } else if (androidStudioShLocal.existsSync()) {
    _processRunIJ(androidStudioShLocal.absolute.path, path);
  } else if (androidStudioShBin.existsSync()) {
    _processRunIJ(androidStudioShBin.absolute.path, path);
  } else {
    showToast("Could not locate an InetlliJ IDEA installation");
  }
}

void _processRunIJ(String asPath, String path) {
  Process.run(asPath, [path]).then(
    (value) {
      if (value.exitCode != 0) {
        showToast("An error ocurred when opening InetlliJ IDEA");
      }
    },
  ).onError((error, stackTrace) {
    showToast("An error ocurred when opening InetlliJ IDEA");
  });
}

// Android Studio Opening Logic

void openInAndroidStudio(String path) {
  if (Platform.isWindows) {
    _openASWindows(path);
  } else if (Platform.isLinux) {
    _openASLinux(path);
  } else if (Platform.isMacOS) {
    _openASMacOS(path);
  }
}

void _openASMacOS(String path) {
  var androidStudio =
      File("/Applications/Android Studio.app/Contents/MacOS/studio");

  if (androidStudio.existsSync()) {
    _processRunAS(androidStudio.absolute.path, path);
  } else {
    showToast("Could not locate an Android Studio installation");
  }
}

void _openASWindows(String path) {
  var androidStudioExe =
      File("C:\\Program Files\\Android\\Android Studio\\bin\\studio64.exe");
  if (androidStudioExe.existsSync()) {
    _processRunAS(androidStudioExe.absolute.path, path);
  } else {
    showToast("Could not locate an Android Studio installation");
  }
}

void _openASLinux(String path) {
  var androidStudioSh = File("/opt/android-studio/bin/studio.sh");
  var androidStudioShLocal = File("/usr/local/android-studio/bin/studio.sh");
  var androidStudioShBin = File("/usr/bin/android-studio/bin/studio.sh");
  if (androidStudioSh.existsSync()) {
    _processRunAS(androidStudioSh.absolute.path, path);
  } else if (androidStudioShLocal.existsSync()) {
    _processRunAS(androidStudioShLocal.absolute.path, path);
  } else if (androidStudioShBin.existsSync()) {
    _processRunAS(androidStudioShBin.absolute.path, path);
  } else {
    showToast("Could not locate an Android Studio installation");
  }
}

void _processRunAS(String asPath, String path) {
  Process.run(asPath, [path]).then(
    (value) {
      if (value.exitCode != 0) {
        showToast("An error ocurred when opening Android Studio");
      }
    },
  ).onError((error, stackTrace) {
    showToast("An error ocurred when opening Android Studio");
  });
}

// VSCode opening Logic

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
