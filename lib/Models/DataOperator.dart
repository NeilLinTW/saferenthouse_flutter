import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
//參考 https://docs.flutter.dev/cookbook/persistence/key-value

class DataOperator {

  static Future<SharedPreferences> get _instance async => _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences?> init() async {
    _prefsInstance = await _instance;
    // _prefsInstance?.clear();
    return _prefsInstance;
  }

  static void clear() async {
    _prefsInstance = await _instance;
    _prefsInstance?.clear();
  }

  static String readData(String key) {
    return _prefsInstance?.getString(key) ?? "";
  }

  static Future<bool> saveData(String key, String value) async {
    // var prefs = await _instance;
    return _prefsInstance?.setString(key, value) ?? Future.value(false);
  }

// static SharedPreferences? sp;
  //
  //
  // static Future init() async {
  //   sp = await SharedPreferences.getInstance();
  //   sp?.clear();
  // }
  //
  // static Future saveData(String key , String val) async {
  //   // await sp?.setString(key, val);
  //   await sp?.setString(key, val);
  //
  // }
  //
  // static Future<String> readData(String key) async {
  //   if(sp == null){
  //     return '';
  //   }
  //   return sp?.getString(key) ?? '';
  // }

}