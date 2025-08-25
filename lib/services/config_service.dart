import 'dart:convert';

import 'package:easy_bot/services/storage/file_service.dart';

class ConfigService {
  ConfigService(this.file);
  final String file;

  int get guildId => _getGuildId();
  String get guildName => _getGuildName();
  List<Map<String, dynamic>> get roles => _getRoles();
  List<Map<String, dynamic>> get users => _getUsers();
  List<Map<String, dynamic>> get channels => _getChannels();

  Map<String, dynamic> _loadData() {
    return jsonDecode(FileService.readAsString(file));
  }

  static dynamic parse(dynamic parse) {
    if (parse is Map<String, dynamic>) {
      return parseMap(parse);
    }
    if (parse is List) {
      return parseList(parse);
    }
  }

  static String parseText(dynamic parse) {
    return parse as String;
  }

  static int parseInt(dynamic parse) {
    return int.parse(parse);
  }

  static Map<String, dynamic> parseMap(Map<String, dynamic> parse) {
    parse.forEach((key, value) {
      if (value is String) {
        parse[key] = (parseText(value));
      }

      if (value is int) {
        parse[key] = (parseInt(value));
      }

      if (value is Map) {
        parse[key] = (parseMap(value as Map<String, dynamic>));
      }

      if (value is List) {
        parse[key] = (parseList(value));
      }
    });

    return parse;
  }

  static List parseList(dynamic parse) {
    List parses = [];
    for (var item in parse) {
      if (item is String) {
        parses.add(parseText(item));
      }

      if (item is int) {
        parses.add(parseInt(item));
      }

      if (item is List) {
        parses.add(parseList(item));
      }

      if (item is Map) {
        parses.add(parseMap(item as Map<String, dynamic>));
      }
    }

    return parses;
  }

  int _getGuildId() {
    final data = _loadData();
    return int.tryParse(data['app']['guild_id']) ?? 0;
  }

  String _getGuildName() {
    final data = _loadData();
    return data['app']['guild_name'] ?? 'Unknown';
  }

  List<Map<String, String>> _getRoles() {
    final data = _loadData();
    return (data['app']['guild_entities']['roles'] as List)
        .map((e) => Map<String, String>.from(e as Map))
        .toList();
  }

  List<Map<String, String>> _getUsers() {
    final data = _loadData();
    return (data['app']['guild_entities']['users'] as List)
        .map((e) => Map<String, String>.from(e as Map))
        .toList();
  }

  List<Map<String, String>> _getChannels() {
    final data = _loadData();
    return (data['app']['guild_entities']['channels'] as List)
        .map((e) => Map<String, String>.from(e as Map))
        .toList();
  }
}
