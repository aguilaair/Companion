import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void initHive() async {
  final docPath = await getApplicationDocumentsDirectory();
  Hive.init(docPath.path);
  await Hive.openBox("settings");
}
