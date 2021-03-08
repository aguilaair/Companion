import 'package:Companion/providers/project_dependencies.provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:Companion/utils/open_link.dart';
import 'package:github/github.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GithubInfoDisplay extends HookWidget {
  final RepositorySlug repoSlug;
  const GithubInfoDisplay({
    this.repoSlug,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var repo = useProvider(getGithubRepositoryProvider(repoSlug));

    return repo.when(data: (data) {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: Should these do something?
            TextButton.icon(
              onPressed: () async {
                await openLink('${data.htmlUrl}/stargazers');
              },
              style: const ButtonStyle(
                alignment: Alignment.centerLeft,
              ),
              icon: const Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Icon(Icons.star, size: 15),
              ),
              label: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Text(data.stargazersCount.toString()),
              ),
            ),
            const SizedBox(width: 10),
            TextButton.icon(
              onPressed: () async {
                await openLink('${data.htmlUrl}/issues');
              },
              style: const ButtonStyle(
                alignment: Alignment.centerLeft,
              ),
              icon: const Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Icon(MdiIcons.alertCircleOutline, size: 15),
              ),
              label: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Text(data.openIssuesCount.toString()),
              ),
            ),
            const SizedBox(width: 10),
            TextButton.icon(
              onPressed: () async {
                await openLink('${data.htmlUrl}/issues');
              },
              style: const ButtonStyle(
                alignment: Alignment.centerLeft,
              ),
              icon: const Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Icon(MdiIcons.sourceFork, size: 15),
              ),
              label: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Text(data.forksCount.toString()),
              ),
            ),
          ],
        ),
      );
    }, loading: () {
      return const Expanded(child: LinearProgressIndicator());
    }, error: (_, __) {
      return Container();
    });
  }
}
