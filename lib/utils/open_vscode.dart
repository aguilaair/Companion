import 'dart:io';

import 'package:oktoast/oktoast.dart';

import 'open_link.dart';

void openInVSCode(String path) {
  Process.run("code", [path], runInShell: true).onError(
    (_, __) async {
      showToast("There was an error opening VSCode,"
          " make sure that it is added to"
          " PATH. Opening via URL...");
      openLink("vscode://file/$path");
      return null;
    },
  );
}
