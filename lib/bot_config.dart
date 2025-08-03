import 'package:dotenv/dotenv.dart';
import 'package:easy_bot/npx/controllers/npx_commands_controller.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commands/nyxx_commands.dart';

class EasyBot {
  late final NyxxGateway bot;
  final commands = CommandsPlugin(
    prefix: mentionOr((_) => '!'),
    options: CommandsOptions(logErrors: true),
  );

  void _setCommands() {
    commands.addCommand(
      ChatCommand(
        'ping',
        'Checks if the bot is online',
        id('ping', (ChatContext context) async {
          final gatewayLatency = context.client.gateway.latency.inMilliseconds;
          final restLatency = context.client.httpHandler.latency.inMilliseconds;

          final embed = EmbedBuilder(
            fields: [
              EmbedFieldBuilder(
                name: 'Gateway latency',
                value: '${gatewayLatency}ms',
                isInline: true,
              ),
              EmbedFieldBuilder(
                name: 'REST latency',
                value: '${restLatency}ms',
                isInline: true,
              ),
            ],
          );

          // Get round-trip time
          final response = await context.respond(
            MessageBuilder(embeds: [embed]),
          );

          await response.edit(MessageUpdateBuilder(embeds: [embed]));
        }),
      ),
    );

    commands.addCommand(
      ChatCommand('help', "Get help with commands", (ChatContext ctx) async {
        await ctx.respond(
          MessageBuilder(content: '```Use / ou ! para os comandos```'),
        );
      }),
    );

    commands.addCommand(
      ChatCommand(
        'start',
        'Inicia o monitoramento das chamadas perdidas',
        (ChatContext ctx) {},
      ),
    );

    commands.addCommand(
      ChatCommand('missed', 'Lista as chamadas perdidas em determinado período', (
        ChatContext ctx,
      ) async {
        final channelId = Snowflake.parse(1401599830509228164);
        final channel = await bot.channels.fetch(channelId) as GuildTextChannel;
        final role = ctx.guild!.roleList.firstWhere(
          (role) => role.name == 'Patrão',
        );

        ctx.respond(MessageBuilder(content: 'Monitoramento ativo'));

        final response = await NpxCommandsController().startMonitoring();

        if (response != null) {
          String responseTxt = '<@&${role.id}>\n';
          for (int i = 0; i < response.length; i++) {
            responseTxt +=
                '```${response[i].callDateTime}\t${response[i].callerNumber}\n```';
          }

          channel.sendMessage(MessageBuilder(content: responseTxt));

          return;
        }

        await Future.delayed(Duration(seconds: 2));
      }),
    );

    commands.addCommand(
      ChatCommand('stop', 'Para o monitoramento de chamadas perdidas', (
        ChatContext ctx,
      ) async {
        ctx.respond(MessageBuilder(content: 'Monitoramento inativo'));
      }),
    );
  }

  void start() async {
    final env = DotEnv(includePlatformEnvironment: true)..load();

    bot = await Nyxx.connectGateway(
      env['DISCORD_KEY']!,
      GatewayIntents.messageContent,
      options: GatewayClientOptions(plugins: [cliIntegration, commands]),
    );

    _setCommands();
    // await client.users.fetchCurrentUser();
  }
}
