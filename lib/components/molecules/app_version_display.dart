import 'package:Companion/constants.dart';
import 'package:Companion/utils/http_cache.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:hive/hive.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionInfo extends StatefulWidget {
  const AppVersionInfo({Key key}) : super(key: key);

  @override
  _AppVersionInfoState createState() => _AppVersionInfoState();
}

class _AppVersionInfoState extends State<AppVersionInfo> {
  PackageInfo packageInfo;
  String latestversion;
  String installedVersion;

  @override
  Widget build(BuildContext context) {
    if (latestversion == null) updateGithubLatestVersion();
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Installed Version:"),
                  Text("Latest Version:"),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "$appVersion",
                  ),
                  Text("${latestversion ?? "Unknown"}")
                ],
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          OutlinedButton(
            onPressed: () => updateGithubLatestVersion,
            child: const Text("Refresh"),
          ),
        ],
      ),
    );
  }

  void updateGithubLatestVersion() {
    GitHub(
            auth: Authentication.withToken(
              Hive.box("settings").get("gh_token"),
            ),
            client: CacheHttpClient())
        .repositories
        .getLatestRelease(
          RepositorySlug("aguilaair", "companion"),
        )
        .then(
      (value) {
        setState(() {
          latestversion = value.tagName;
        });
      },
    ).catchError((e) {
      showToast(
        "Error getting latest GitHub release",
        position: ToastPosition.bottom,
      );
    });
  }
}
