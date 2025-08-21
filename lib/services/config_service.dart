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
  List<Map<String, dynamic>> get messages => _getMessages();

  Map<String, dynamic> _loadData() {
    return jsonDecode(FileService.readAsString(file));
  }

  int _getGuildId() {
    final data = _loadData();
    return int.tryParse(data['guild_id']) ?? 0;
  }

  String _getGuildName() {
    final data = _loadData();
    return data['guild_name'] ?? 'Unknown';
  }

  List<Map<String, dynamic>> _getRoles() {
    final data = _loadData();
    return (data['roles'] as List)
        .map((e) => Map<String, String>.from(e as Map))
        .toList();
  }

  List<Map<String, dynamic>> _getUsers() {
    final data = _loadData();
    return (data['users'] as List)
        .map((e) => Map<String, String>.from(e as Map))
        .toList();
  }

  List<Map<String, dynamic>> _getChannels() {
    final data = _loadData();
    return (data['channels'] as List)
        .map((e) => Map<String, String>.from(e as Map))
        .toList();
  }

  List<Map<String, dynamic>> _getMessages() {
    final data = _loadData();
    return (data['messages'] as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }
}
