import 'package:easy_bot/utils/easy_message_builder.dart';
import 'package:easy_bot/utils/env.dart';
import 'package:easy_bot/controllers/npx_commands_controller.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

class EasyBot {
  late final NyxxGateway bot;
  final controller = NpxCommandsController();

  final commands = CommandsPlugin(
    prefix: null,
    options: CommandsOptions(logErrors: true, type: CommandType.slashOnly),
  );

  void _setCommands() {
    commands.addCommand(
      ChatCommand(
        'ping',
        'Verifica a disponibilidade do Bot',
        id('ping', (ChatContext ctx) async {
          // ctx.respond(MessageBuilder(content: 'Pong!'));

          final guildId = Snowflake.parse(int.parse(Env.get('GUILD_ID')));
          final guild = await bot.guilds.fetch(guildId);

          // final channelId = Snowflake.parse(1401599830509228164);
          // final channel =
          //     await bot.channels.fetch(channelId) as GuildTextChannel;

          final role = guild.roleList.firstWhere(
            (role) => role.name == 'Patrão',
          );

          var message = BotMessageBuilder(
            header: MessageHeader(
              mentions: MessageMentions(
                mentions: [
                  Mention(mentionType: MentionType.role, id: role.id),
                  Mention(
                    mentionType: MentionType.user,
                    id: Snowflake(183608698545897472),
                  ),
                ],
              ),
              title: MessageContent([
                MessageContentPart('# '),
                MessageContentPart(
                  'Atenção! Nova mensagem teste',
                  isBold: true,
                ),
              ]),
            ),
            content: MessageContent([
              MessageContentPart('Teste', isBold: true),
            ]),
          );
          print(message.build());
          ctx.respond(MessageBuilder(content: message.build()));
        }),
      ),
    );

    commands.addCommand(
      ChatCommand(
        'start_monitoring',
        'Inicia o monitoramento das chamadas perdidas',
        (ChatContext ctx) async {
          final guildId = Snowflake.parse(int.parse(Env.get('GUILD_ID')));
          final guild = await bot.guilds.fetch(guildId);

          final channelId = Snowflake.parse(1401599830509228164);
          final channel =
              await bot.channels.fetch(channelId) as GuildTextChannel;

          final role = guild.roleList.firstWhere(
            (role) => role.name == 'Patrão',
          );

          controller.startMonitoring(role, channel);

          ctx.respond(MessageBuilder(content: 'Monitoramento ativo'));
        },
      ),
    );

    commands.addCommand(
      ChatCommand(
        'test_message',
        'Lista as chamadas perdidas em determinado período',
        (ChatContext ctx) async {},
      ),
    );

    commands.addCommand(
      ChatCommand(
        'stop_monitoring',
        'Para o monitoramento de chamadas perdidas',
        (ChatContext ctx) async {
          controller.stopMonitoring();
          ctx.respond(MessageBuilder(content: 'Monitoramento inativo'));
        },
      ),
    );
  }

  Future<void> start() async {
    bot = await Nyxx.connectGateway(
      Env.get('DISCORD_KEY'),
      GatewayIntents.messageContent,
      options: GatewayClientOptions(plugins: [cliIntegration, commands]),
    );

    _setCommands();
    // await client.users.fetchCurrentUser();
  }
}
