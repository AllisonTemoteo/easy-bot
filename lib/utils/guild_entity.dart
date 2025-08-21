import 'package:easy_bot/utils/errors.dart';

sealed class GuildEntity {
  GuildEntity({required this.id, required this.name});
  final int id;
  final String name;

  String get mentionFormat;

  Map<String, Object> toMap() {
    return {'id': id, 'name': name};
  }

  factory GuildEntity.fromMap(Map<String, Object?> map) {
    switch (map['type'] as String) {
      case 'text_channel':
        return TextChannel.fromMap(map);
      case 'role':
        return Role.fromMap(map);
      case 'user':
        return User.fromMap(map);
      default:
        throw AppException('Unknown GuildEntity type ${map['type']}');
    }
  }
}

class TextChannel extends GuildEntity {
  TextChannel({required super.id, required super.name});

  @override
  String get mentionFormat => '<#$id>';

  factory TextChannel.fromMap(Map<String, Object?> map) {
    return TextChannel(
      id: int.parse(map['id'] as String),
      name: map['name'] as String,
    );
  }
}

class Role extends GuildEntity {
  Role({required super.id, required super.name});

  @override
  String get mentionFormat => '<@&$id>';

  factory Role.fromMap(Map<String, Object?> map) {
    return Role(
      id: int.parse(map['id'] as String),
      name: map['name'] as String,
    );
  }
}

class User extends GuildEntity {
  User({required super.id, required super.name, this.agentCode = '0000'});
  final String agentCode;

  @override
  String get mentionFormat => '<@$id>';

  @override
  Map<String, Object> toMap() {
    return {'agent_code': agentCode, ...super.toMap()};
  }

  factory User.fromMap(Map<String, Object?> map) {
    return User(
      id: int.parse(map['id'] as String),
      name: map['name'] as String,
      agentCode: map['agent_code'] as String? ?? '0000',
    );
  }
}
