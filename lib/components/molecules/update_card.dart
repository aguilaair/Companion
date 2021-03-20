import 'package:flutter/material.dart';

class UpdateAvailableCard extends StatelessWidget {
  const UpdateAvailableCard(
    this.updateGithubLatestVersion, {
    Key key,
  }) : super(key: key);

  final Function updateGithubLatestVersion;

  @override
  Widget build(BuildContext context) {
    return Card(
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
              "\nClick here to install it.",
            ),
            const SizedBox(
              width: 15,
            ),
            OutlinedButton(
              onPressed: updateGithubLatestVersion,
              child: const Text("Install Now"),
            )
          ],
        ),
      ),
    );
  }
}
