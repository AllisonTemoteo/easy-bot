import 'package:easy_bot/bot_tasks.dart';
import 'package:easy_bot/easy_bot.dart';
import 'package:easy_bot/utils/action.dart';
import 'package:easy_bot/utils/guild_entity.dart';
import 'package:nyxx/nyxx.dart' show Snowflake, TextChannel;

class AppConfig {
  AppConfig();

  Map<String, GuildTextChannel> textChannels = {
    'teste-easybot': GuildTextChannel(
      id: Snowflake(1401599830509228164),
      name: 'teste-easybot',
    ),
  };

  Map<String, GuildRole> roles = {
    'Patrão': GuildRole(id: Snowflake(1134131241915003003), name: 'Patrão'),
  };

  Map<String, GuildRole> users = {
    'Patrão': GuildRole(id: Snowflake(183608698545897472), name: 'bleque'),
  };

  Map<String, Task> tasks = {};
  Map<String, Action> actions = {};

  Snowflake get guildId => Snowflake(1134130266001133648);

  Future<TextChannel?> fetchTextChannel(String name) async {
    final easyBot = await EasyBot.instance;
    final client = easyBot.client;

    final textChannelId = textChannels[name]?.id;

    if (textChannelId != null) {
      return await client.channels.fetch(textChannels[name]!.id) as TextChannel;
    }

    return null;
  }

  void registerTask(Task task) {
    print('Registering task: ${task.name}');
    tasks[task.name] = task;
  }

  void registerActions(Action action) {
    print('Registering action: ${action.name}');
    actions[action.name] = action;
  }
}
