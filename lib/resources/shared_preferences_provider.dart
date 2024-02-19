import 'dart:convert';

import 'package:retro/music_models/account/linked_account_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'resources.dart';

class SharedPreferencesProvider implements PreferencesProvider {
  static const String _key = 'SharedPReferencesProviderKey';

  @override
  void dispose() {}

  @override
  Future<LinkedAccountModel> fetchPreferences() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String value = sharedPreferences.getString(_key)!;
    return LinkedAccountModel.fromJson(jsonDecode(value));
  }

  @override
  Future<void> savePreferences(LinkedAccountModel linkedAccountModel) async {
    final String value = jsonEncode(linkedAccountModel);
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString(_key, value);
  }
}