import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalSave<T> {
  late final String name;
  final T Function(dynamic json)? fromJson;
  final Object Function(T data)? toJson;

  LocalSave({required String name, this.fromJson, this.toJson}) {
    this.name = "${name.toLowerCase()}_local_save";
  }

  Future<void> save(T data) async {
    SharedPreferences local = await SharedPreferences.getInstance();
    var object = toJson != null ? toJson!(data) : data;

    await local.setString(name, jsonEncode(object));
  }

  Future<T?> load() async {
    SharedPreferences local = await SharedPreferences.getInstance();
    String? text = local.getString(name);

    if (text == null) return null;

    dynamic json = jsonDecode(text);

    return fromJson != null ? fromJson!(json) : json;
  }
}


