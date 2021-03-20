import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class UpdateAvailableCard extends StatelessWidget {
  const UpdateAvailableCard(
    this.updateGithubLatestVersion,
    this.toastDismiss, {
    Key key,
  }) : super(key: key);

  final Function updateGithubLatestVersion;
  final Function toastDismiss;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.update_rounded),
            const SizedBox(
              width: 15,
            ),
            const Text(
              "There is an update available!"
              " Click here to install it now.",
            ),
            const SizedBox(
              width: 15,
            ),
            OutlinedButton(
              onPressed: toastDismiss,
              child: const Text("Install Now"),
            ),
            const SizedBox(
              width: 15,
            ),
            TextButton(
              onPressed: toastDismiss,
              child: const Text("Later"),
            )
          ],
        ),
      ),
    );
  }
}
