import 'package:fvm_app/components/atoms/typography.dart';
import 'package:fvm_app/components/molecules/version_install_button.dart';
import 'package:fvm_app/dto/channel.dto.dart';
import 'package:fvm_app/providers/selected_info_provider.dart';

import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:fvm_app/utils/layout_size.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChannelShowcase extends StatelessWidget {
  final ChannelDto channel;
  const ChannelShowcase(this.channel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            left: BorderSide(color: Theme.of(context).dividerColor),
            bottom: BorderSide(color: Theme.of(context).dividerColor),
            // TODO: quite a hacky way to achieve this
            right: channel.name == "dev"
                ? BorderSide(color: Theme.of(context).dividerColor)
                : BorderSide.none),
      ),
      child: OutlinedButton(
        onPressed: () {
          context.read(selectedInfoProvider).selectVersion(channel);
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith(
            (states) => const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          side: MaterialStateProperty.resolveWith((states) => BorderSide.none),
        ),
        child: LayoutBuilder(builder: (context, layout) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TypographyTitle(channel.name),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 70),
                      child: TypographySubheading(channel.release.version),
                    ),
                    const SizedBox(height: 5),
                    TypographyCaption(
                      DateTimeFormat.relative(
                        channel.release.releaseDate,
                        appendIfAfter: 'ago',
                      ),
                    ),
                  ],
                ),
                LayoutSize.isSmall ? Container() : const Spacer(),
                LayoutSize.isSmall
                    ? Container()
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          VersionInstallButton(channel),
                        ],
                      )
              ],
            ),
          );
        }),
      ),
    );
  }
}
