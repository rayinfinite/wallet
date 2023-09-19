import 'package:shared_preferences/shared_preferences.dart';

Future<void> setData<T>(String key, T value) async {
  final prefs = await SharedPreferences.getInstance();
  switch (T) {
    case String:
      await prefs.setString(key, value as String);
      break;
    case bool:
      await prefs.setBool(key, value as bool);
      break;
    case int:
      await prefs.setInt(key, value as int);
      break;
    case double:
      await prefs.setDouble(key, value as double);
      break;
    default:
      throw Exception('Unsupported data type');
  }
}

Future<T?> getData<T>(String key) async {
  final prefs = await SharedPreferences.getInstance();
  switch (T) {
    case String:
      return prefs.getString(key) as T?;
    case bool:
      return prefs.getBool(key) as T?;
    case int:
      return prefs.getInt(key) as T?;
    case double:
      return prefs.getDouble(key) as T?;
    default:
      throw Exception('Unsupported data type');
  }
}