import 'package:Companion/constants.dart';
import 'package:Companion/utils/manage_updates.dart';
import 'package:Companion/utils/http_cache.dart';
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:hive/hive.dart';
import 'package:oktoast/oktoast.dart';
import 'package:version/version.dart';
import 'update_card.dart';

class AppVersionInfo extends StatefulWidget {
  const AppVersionInfo({Key key}) : super(key: key);

  @override
  _AppVersionInfoState createState() => _AppVersionInfoState();
}

class _AppVersionInfoState extends State<AppVersionInfo> {
  Version latestversion;
  Version installedVersion;
  bool isNewerAvailable = false;

  @override
  Widget build(BuildContext context) {
    if (latestversion == null) updateGithubLatestVersion();
    if (installedVersion == null) {
      try {
        installedVersion = Version.parse(appVersion);
      } on FormatException catch (_) {
        installedVersion = Version(0, 0, 1);
      }
    }
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
                  Text(
                    "$installedVersion",
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
            onPressed: updateGithubLatestVersion,
            child: Text(
              isNewerAvailable ? "Download" : "Refresh",
            ),
          ),
        ],
      ),
    );
  }

  void updateGithubLatestVersion() {
    if (isNewerAvailable) {
      downloadRelease(latestversion.toString(), context);
    } else {
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
            latestversion = Version.parse(value.tagName);
            isNewerAvailable = (latestversion > installedVersion);
            if (isNewerAvailable) {
              showToastWidget(
                UpdateAvailableCard(updateGithubLatestVersion),
                //backgroundColor: Colors.green,
                handleTouch: true,
                position: ToastPosition.bottom,
                duration: const Duration(seconds: 10),
                //textPadding: const EdgeInsets.all(20),
              );
            }
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
}
