import 'package:easy_bot/easy_bot.dart';
import 'package:easy_bot/utils/guild_entity.dart';
import 'package:easy_bot/utils/message.dart';
import 'package:nyxx/nyxx.dart' show TextChannel, MessageBuilder;

abstract class MessageSender {
  MessageSender();
  static void sendToChannel(Message message, GuildTextChannel target) async {
    final bot = await EasyBot.instance;
    final channel = await bot.client.channels.fetch(target.id);

    if (channel is TextChannel) {
      channel.sendMessage(MessageBuilder(content: message.content));
    }
  }
}
