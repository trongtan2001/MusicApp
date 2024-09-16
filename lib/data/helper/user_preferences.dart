import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class UserPreferences {
  static const String _keyUser = 'user';

  static Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toMap());
    await prefs.setString(_keyUser, userJson);
  }

  static Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_keyUser);
    if(userString != null) {
      final userMap = jsonDecode(userString) as Map<String, dynamic>;
      return User.fromMap(userMap);
    }
    return null;
  }
}