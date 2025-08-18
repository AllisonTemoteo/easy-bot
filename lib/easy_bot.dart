import 'dart:async';
import 'package:easy_bot/config/bot_config.dart';
import 'package:easy_bot/utils/env.dart';
import 'package:nyxx/nyxx.dart';

class EasyBot {
  EasyBot._internal();
  static EasyBot? _instance;
  static Future<EasyBot> get instance async =>
      _instance ??= await _initInstance();

  static late final NyxxGateway _client;
  NyxxGateway get client => _client;

  static late final BotConfig _botConfig;

  static Future<EasyBot> _initInstance() async {
    if (_instance != null) {
      return _instance!;
    }

    _instance = EasyBot._internal();

    _client = await Nyxx.connectGateway(
      Env.get('DISCORD_TOKEN'),
      GatewayIntents.allUnprivileged,
      options: GatewayClientOptions(plugins: [logging, cliIntegration]),
    );

    _client.onReady.listen((event) async {
      print('Setting bot configs');

      _botConfig = BotConfig.instance;

      print('Bot ready');

      final task = _botConfig.getTaskByName('monitoreMissedCalls');
      task.execPeriodic(Duration(seconds: 30));
    });

    _client.onMessageCreate.listen((event) async {
      final botUser = await _client.users.fetchCurrentUser();
      final latency = _client.httpHandler.latency;
      final formattedLatency =
          (latency.inMicroseconds / Duration.microsecondsPerMillisecond)
              .toStringAsFixed(3);

      if (event.mentions.contains(botUser)) {
        event.message.channel.sendMessage(
          MessageBuilder(
            content: '# Hi, there',
            embeds: [
              EmbedBuilder(
                color: DiscordColor.fromRgb(0, 255, 0),
                title: 'EasyBot',
                fields: [
                  EmbedFieldBuilder(
                    name: 'Latency',
                    value: formattedLatency,
                    isInline: true,
                  ),
                  EmbedFieldBuilder(
                    name: 'Version',
                    value: '0.0.3p',
                    isInline: true,
                  ),
                ],
              ),
            ],
          ),
        );
      }
    });

    _client.onMessageReactionAdd.listen((ctx) async {
      final botUser = await _client.users.fetchCurrentUser();
      if (ctx.messageAuthor == botUser) {
        ctx.message.delete();
      }
    });

    return _instance!;
  }
}
