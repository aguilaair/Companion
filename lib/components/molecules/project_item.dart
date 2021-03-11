import 'dart:io';

import 'package:Companion/components/atoms/list_tile.dart';
import 'package:Companion/components/atoms/typography.dart';
import 'package:Companion/components/molecules/project_version_select.dart';

import 'package:Companion/providers/installed_versions.provider.dart';
import 'package:Companion/utils/open_link.dart';
import 'package:Companion/utils/open_vscode.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fvm/fvm.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:oktoast/oktoast.dart';

class ProjectItem extends HookWidget {
  final FlutterProject project;
  const ProjectItem(this.project, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final installedVersions = useProvider(installedVersionsProvider);

    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Center(
        child: FvmListTile(
          leading: const Icon(MdiIcons.alphaPBox),
          title: TypographySubheading(project.name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  openInVSCode(project.projectDir.absolute.path);
                },
                icon: const Icon(MdiIcons.microsoftVisualStudioCode),
                label: const Text(
                  "Open",
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              ProjectVersionSelect(
                project: project,
                versions: installedVersions,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
