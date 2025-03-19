import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);
    if (value != null) {
      try {
        return json.decode(value);
      } catch (e) {
        return value;
      }
    } else {
      return null;
    }
  }

  save(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is Map) {
      prefs.setString(key, json.encode(value));
      return true;
    } else if (value is String) {
      prefs.setString(key, value.toString());
      return true;
    } else {
      return false;
    }
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    bool stringExists = prefs.containsKey(key);
    if (stringExists) {
      prefs.remove(key);
      return true;
    } else {
      return false;
    }
  }
}
