import 'dart:io';
import 'package:Companion/providers/projects_provider.dart';
import 'package:Companion/utils/dependencies.dart';
import 'package:Companion/utils/http_cache.dart';
import 'package:github/github.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pub_api_client/pub_api_client.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:hive/hive.dart';

final getGithubRepositoryProvider =
    FutureProvider.family<Repository, RepositorySlug>((ref, repoSlug) async {
  final github = GitHub(
    auth: Authentication.withToken(Hive.box("settings").get("gh_token")),
    client: CacheHttpClient(),
  );
  if (repoSlug == null) {
    throw 'Not valid Github Slug';
  }
  return await github.repositories.getRepository(repoSlug);
});

// ignore: top_level_function_literal_block
final projectDependenciesProvider = FutureProvider((ref) async {
  final projects = ref.watch(projectsProvider.state);
  final packages = <String, int>{};

  for (var project in projects.list) {
    final pubspecPath = '${project.projectDir.absolute.path}\\pubspec.yaml';
    final pubspec = Pubspec.parse(File(pubspecPath).readAsStringSync());
    final deps = pubspec.dependencies;
    final devDeps = pubspec.devDependencies;
    final allDeps = {...deps, ...devDeps};

    // Loop through all dependencies
    // ignore: avoid_function_literals_in_foreach_calls
    allDeps.forEach((str, dep) {
      var isHosted = dep.toString().contains("HostedDependency");
      // ignore: invalid_use_of_protected_member
      if (isHosted != null && !isGooglePubPackage(str)) {
        packages.update(str, (val) => ++val, ifAbsent: () => 1);
      }
    });
  }
  final pkgs = await fetchAllDependencies(packages);
  pkgs..sort((a, b) => a.compareTo(b));
  // Reverse order
  return pkgs.reversed.toList();
});
