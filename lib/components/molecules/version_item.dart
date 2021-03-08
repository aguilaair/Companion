import 'package:Companion/components/atoms/list_tile.dart';
import 'package:Companion/components/atoms/typography.dart';

import 'package:Companion/components/molecules/version_install_button.dart';

import 'package:Companion/dto/version.dto.dart';
import 'package:Companion/providers/selected_info_provider.dart';

import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class VersionItem extends StatelessWidget {
  final VersionDto version;

  VersionItem(this.version)
      : super(key: Key('${version.name}${version.release.channel}'));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: FvmListTile(
        title: TypographySubheading(version.name),
        onTap: () {
          context.read(selectedInfoProvider).selectVersion(version);
        },
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 10),
            VersionInstallButton(version),
          ],
        ),
      ),
    );
  }
}
