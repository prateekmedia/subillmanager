import 'package:get_storage/get_storage.dart';

resetData() {
  GetStorage().writeIfNull("thememode", 0);
  GetStorage().writeIfNull("demo", true);
}
