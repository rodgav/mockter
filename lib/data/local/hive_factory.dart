import 'package:hive_flutter/hive_flutter.dart';

class HiveFactory {
  Future<void> initHive() async {
    await Hive.initFlutter();
    //Hive.deleteBoxFromDisk('mockTerBox');
  }
}
