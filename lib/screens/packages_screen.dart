import 'package:Companion/components/atoms/list_tile.dart';
import 'package:Companion/components/atoms/loading_indicator.dart';
import 'package:Companion/components/atoms/screen.dart';
import 'package:Companion/components/atoms/typography.dart';
import 'package:Companion/components/molecules/github_info_display.dart';
import 'package:Companion/components/molecules/package_score_display.dart';

import 'package:Companion/providers/project_dependencies.provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:Companion/utils/github_parse.dart';

import 'package:Companion/utils/open_link.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PackagesScreen extends HookWidget {
  const PackagesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final packages = useProvider(projectDependenciesProvider);

    return packages.when(
      data: (data) {
        return FvmScreen(
          title: 'Your Most Popular Packages',
          child: Scrollbar(
            child: ListView.builder(
              // separatorBuilder: (_, __) => const Divider(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final pkg = data[index];
                final position = ++index;
                return Container(
                  child: Column(
                    children: [
                      FvmListTile(
                        leading: CircleAvatar(
                          //backgroundColor: Colors.black26,
                          child: Text(position.toString()),
                        ),
                        title: Text(pkg.package.name),
                        subtitle: Text(
                          pkg.package.description,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        trailing: PackageScoreDisplay(score: pkg.score),
                      ),
                      const Divider(thickness: 0.5),
                      Row(
                        children: [
                          GithubInfoDisplay(
                            key: Key(pkg.package.name),
                            repoSlug: getRepoSlugFromPubspec(
                                pkg.package.latestPubspec),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TypographyCaption(pkg.package.version),
                                    const SizedBox(width: 10),
                                    const Text('·'),
                                    const SizedBox(width: 10),
                                    Tooltip(
                                      message: "Details",
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.info_outline_rounded,
                                        ),
                                        iconSize: 20,
                                        splashRadius: 20,
                                        color: Theme.of(context).accentColor,
                                        onPressed: () async {
                                          await openLink(pkg.package.url);
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text('·'),
                                    const SizedBox(width: 10),
                                    Tooltip(
                                      message: "Changelog",
                                      child: IconButton(
                                        icon: const Icon(
                                          MdiIcons.textBox,
                                        ),
                                        iconSize: 20,
                                        splashRadius: 20,
                                        color: Theme.of(context).accentColor,
                                        onPressed: () async {
                                          await openLink(
                                              pkg.package.changelogUrl);
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text('·'),
                                    const SizedBox(width: 10),
                                    Tooltip(
                                      message: "Website",
                                      child: IconButton(
                                        icon: const Icon(
                                          MdiIcons.earth,
                                        ),
                                        iconSize: 20,
                                        splashRadius: 20,
                                        color: Theme.of(context).accentColor,
                                        onPressed: () async {
                                          await openLink(pkg
                                              .package.latestPubspec.homepage);
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const Divider()
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
      loading: () => const LoadingIndicator(),
      error: (_, __) => Container(
        child: const Text("There was an issue loading Packages"),
      ),
    );
  }
}
