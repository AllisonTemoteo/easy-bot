import 'package:easy_bot/config/bot_config.dart';
import 'package:easy_bot/services/config_service.dart';
import 'package:easy_bot/utils/env.dart';
import 'package:easy_bot/utils/guild_entity.dart';

class AppConfig {
  AppConfig._internal({
    required this.guildId,
    required this.guildName,
    required this.channels,
    required this.roles,
    required this.users,
  });

  static AppConfig? _instance;
  static Future<AppConfig> get instance async => _instance ??= await _init();

  static BotConfig? _botConfig;
  BotConfig get bot => _botConfig!;

  final int guildId;
  final String guildName;
  final List<Role> roles;
  final List<User> users;
  final List<TextChannel> channels;

  static Future<AppConfig> _init() async {
    final env = Env.get('ENV', defaultValue: 'dev');

    final configs = ConfigService('config.$env.json');

    var guildId = configs.guildId;
    var guildName = configs.guildName;

    final roles = configs
        .roles //
        .map(Role.fromMap)
        .toList();

    final channels = configs
        .channels //
        .map(TextChannel.fromMap)
        .toList();

    final users = configs
        .users //
        .map(User.fromMap)
        .toList();

    final appConfig = AppConfig._internal(
      guildId: guildId,
      guildName: guildName,
      roles: roles,
      users: users,
      channels: channels,
    );

    _botConfig = BotConfig.instance;

    return appConfig;
  }

  User getUserByName(String name) =>
      users.firstWhere((user) => user.name == name);

  Role getRoleByName(String name) =>
      roles.firstWhere((role) => role.name == name);

  TextChannel getChannelByName(String name) =>
      channels.firstWhere((channel) => channel.name == name);
}
