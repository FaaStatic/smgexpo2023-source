import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static final StorageUtil sharedPref = StorageUtil._internal();
  static SharedPreferences? control;

  factory StorageUtil() {
    return sharedPref;
  }

  StorageUtil._internal();

  static Future<void> init() async {
    control = await SharedPreferences.getInstance();
  }

  static Future<String?> getAsString(String key) async {
    if (control != null) {
      return control?.getString(key);
    } else {
      await init();
      return control?.getString(key);
    }
  }

  static Future<bool?> getAsBool(String key) async {
    if (control != null) {
      return control?.getBool(key);
    } else {
      await init();
      return control?.getBool(key);
    }
  }

  static Future<int?> getAsInt(String key) async {
    if (control != null) {
      return control?.getInt(key);
    } else {
      await init();
      return control?.getInt(key);
    }
  }

  static Future<void> storeAsInt(String key, int value) async {
    if (control != null) {
      await control?.setInt(key, value);
    } else {
      await init();
      await control?.setInt(key, value);
    }
  }

  static Future<void> storeAsBool(String key, bool value) async {
    if (control != null) {
      await control?.setBool(key, value);
    } else {
      await init();
      await control?.setBool(key, value);
    }
  }

  static Future<void> storeAsString(String key, String value) async {
    if (control != null) {
      await control?.setString(key, value);
    } else {
      await init();
      await control?.setString(key, value);
    }
  }

  static Future<bool> clearAll() async {
    if (control != null) {
      await control?.clear();
      return true;
    } else {
      await init();

      await control?.clear();
      return true;
    }
  }

  static Future<Map<String, dynamic>> getAsMap(String key) async {
    if (control != null) {
      var value = control?.getString(key);
      Map<String, dynamic> temp = <String, dynamic>{
        "data": "kosong",
      };
      if (value == null) {
        return jsonDecode(jsonEncode(temp));
      } else {
        return jsonDecode(value);
      }
    } else {
      await init();
      var value = control?.getString(key);
      Map<String, dynamic> temp = <String, dynamic>{
        "data": "kosong",
      };
      if (value == null) {
        return jsonDecode(jsonEncode(temp));
      } else {
        return jsonDecode(value);
      }
    }
  }

  static Future<List<String>?> getAsList(String key) async {
    if (control != null) {
      return control?.getStringList(key);
    } else {
      await init();
      return control?.getStringList(key);
    }
  }

  static Future<void> storeAsList(String key, List<String> value) async {
    if (control != null) {
      await control?.setStringList(key, value);
    } else {
      await init();
      await control?.setStringList(key, value);
    }
  }
}
