import 'package:get_storage/get_storage.dart';

class ServiceStorage {
  static final _box = GetStorage('projeto');

  static bool existUser() {
    if (_box.read('auth') != null) {
      return true;
    }
    return false;
  }

  static String getToken() {
    if (existUser()) {
      return _box.read('auth')['access_token'];
    }
    return "";
  }

  static void clearBox() {
    final box = GetStorage('projeto');
    if (existUser()) {
      box.remove('auth');
      box.remove('projeto');
      box.erase();
      print(box.read('auth'));
      print(box.read('projeto'));
    }
  }

  static int getUserId() {
    if (existUser()) {
      return _box.read('auth')['user']['id'];
    }
    return 0;
  }

  static int getUserType() {
    if (existUser()) {
      return _box.read('auth')['user']['usertype_id'];
    }
    return 0;
  }

  static String getUserName() {
    if (existUser()) {
      return _box.read('auth')['user']['name'];
    }
    return "";
  }
}
