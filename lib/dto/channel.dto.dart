import 'package:Companion/dto/version.dto.dart';

import 'package:flutter/material.dart';
import 'package:fvm/fvm.dart';

class ChannelDto extends VersionDto {
  /// Latest version of the channel
  Release currentRelease;
  final String sdkVersion;

  ChannelDto({
    @required String name,
    @required bool isInstalled,
    @required Release release,
    @required needSetup,
    @required this.sdkVersion,
    @required this.currentRelease,
  }) : super(
          name: name,
          release: release,
          isInstalled: isInstalled,
          needSetup: needSetup,
          isChannel: true,
        );
}
