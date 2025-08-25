import 'package:easy_bot/config/app_config.dart';
import 'package:easy_bot/utils/env.dart';
import 'package:easy_bot/utils/errors.dart';
import 'package:easy_bot/utils/guild_entity.dart' as ge;
import 'package:easy_bot/utils/message.dart' as message;
import 'package:easy_bot/utils/task.dart';
import 'package:nyxx/nyxx.dart';

class NyxxService {
  NyxxService._internal();
  static NyxxService? _instance;
  static Future<NyxxService> get instance async => _instance ??= await _init();

  static late NyxxGateway _client;

  static Future<NyxxService> _init() async {
    _client = await Nyxx.connectGateway(
      Env.get('DISCORD_TOKEN'),
      GatewayIntents.allUnprivileged | GatewayIntents.messageContent,
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

      // if (ctx.message.content.startsWith('!test')) {
      //   final task = Task.fromMap();

      //   task.start();
      // }
    });

    _client.onMessageReactionAdd.listen((ctx) async {
      final botUser = await _client.users.fetchCurrentUser();
      if (ctx.messageAuthor == botUser) {
        ctx.message.delete();
      }
    });

    _client.onMessageComponentInteraction.listen((event) async {
      if (event.interaction.data.customId == 'primary_button') {
        event.interaction.message!.delete();
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
    message.Message message, {
    bool confirmation = false,
  }) async {
    if (message.receiver is ge.TextChannel) {
      final channel = await _fetchTextChannelByName(message.receiver.name);
      if (channel == null) {
        throw AppException('Unknown channel');
      }

      List<MessageComponentBuilder<MessageComponent>>? button;

      if (confirmation) {
        button = [
          ActionRowBuilder(
            components: [
              ButtonBuilder(
                style: ButtonStyle.primary,
                label: 'OK',
                customId: 'primary_button',
              ),
            ],
          ),
        ];
      }
      channel.sendMessage(
        MessageBuilder(content: message.content, components: button),
      );
    }
  }
}
