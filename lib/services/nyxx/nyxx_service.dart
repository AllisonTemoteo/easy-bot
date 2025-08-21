import 'package:easy_bot/config/app_config.dart';
import 'package:easy_bot/utils/env.dart';
import 'package:easy_bot/utils/errors.dart';
import 'package:easy_bot/utils/guild_entity.dart' as channel show TextChannel;
import 'package:easy_bot/utils/message.dart' as message;
import 'package:nyxx/nyxx.dart';

class NyxxService {
  NyxxService._internal();
  static NyxxService? _instance;
  static Future<NyxxService> get instance async => _instance ??= await _init();

  static late NyxxGateway _client;

  static Future<NyxxService> _init() async {
    _client = await Nyxx.connectGateway(
      Env.get('DISCORD_TOKEN'),
      GatewayIntents.allUnprivileged,
      options: GatewayClientOptions(plugins: [logging, cliIntegration]),
    );

    _client.onReady.listen((event) async {
      final appConfig = await AppConfig.instance;
      print('Bot running in [${appConfig.guildName}(${appConfig.guildId})]');
    });

    _client.onMessageCreate.listen((ctx) async {
      final user = await _client.users.fetchCurrentUser();
      if (ctx.message.mentions.contains(user)) {
        ctx.message.channel.sendMessage(MessageBuilder(content: 'Oi'));
      }
    });

    _client.onMessageReactionAdd.listen((ctx) async {
      final botUser = await _client.users.fetchCurrentUser();
      if (ctx.messageAuthor == botUser) {
        ctx.message.delete();
      }
    });

    return NyxxService._internal();
  }

  Future<TextChannel?> _fetchTextChannelByName(String name) async {
    final appConfig = await AppConfig.instance;
    final channel = appConfig.getChannelByName(name);

    return await _client.channels.fetch(Snowflake(channel.id)) as TextChannel;
  }

  Future sendMessage(
    message.Message message,
    channel.TextChannel target,
  ) async {
    final channel = await _fetchTextChannelByName(target.name);
    if (channel == null) {
      throw AppException('Unkown channel');
    }

    channel.sendMessage(MessageBuilder(content: message.content));
  }
}
