import 'package:nyxx/nyxx.dart';

abstract class GuildEntity {
  GuildEntity({required this.id, required this.name});
  final Snowflake id;
  final String name;

  GuildEntity fromMap(Map<String, Object> map);
  Map<String, Object> toMap();
}

class _GuildEntity extends GuildEntity {
  _GuildEntity({required super.id, required super.name});

  @override
  GuildEntity fromMap(Map<String, Object> map) {
    final Snowflake id = Snowflake.parse(map['id'] as String);
    return GuildRole(id: id, name: map['name'] as String);
  }

  @override
  Map<String, Object> toMap() {
    return {'id': id.toString(), 'name': name};
  }
}

class GuildTextChannel extends _GuildEntity {
  GuildTextChannel({required super.id, required super.name});
}

class GuildRole extends _GuildEntity {
  GuildRole({required super.id, required super.name});
}

class GuildUser extends _GuildEntity {
  GuildUser({required super.id, required super.name, required this.agentCode});
  final String agentCode;

  @override
  GuildUser fromMap(Map<String, Object> map) {
    final Snowflake id = Snowflake.parse(map['id'] as String);
    return GuildUser(
      id: id,
      name: map['name'] as String,
      agentCode: map['agent_code'] as String,
    );
  }

  @override
  Map<String, Object> toMap() {
    return {'agent_code': agentCode, ...super.toMap()};
  }
}
