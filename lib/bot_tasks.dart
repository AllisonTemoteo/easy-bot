import 'dart:async';

import 'package:easy_bot/easy_bot.dart';
import 'package:easy_bot/controllers/npx_controller.dart';
import 'package:easy_bot/utils/easy_message_builder.dart';
import 'package:nyxx/nyxx.dart';

abstract class EasyBotTask {
  Timer? timer;
  void start(Duration refreshTimer);
}

class MonitoreMissedCallsTask extends EasyBotTask {
  final NpxController controller = NpxController();
  @override
  void start(Duration refreshTimer) {
    print('Monitoring missed calls at every $refreshTimer');
    timer = Timer.periodic(refreshTimer, (timer) async {
      final easyBot = await EasyBot.instance;
      final client = easyBot.client;

      final report = await controller.getNewMissedCalls();

      if (report != null) {
        final roleId = Snowflake(1134131241915003003);
        final channelId = Snowflake(1401599830509228164);
        final channel = await client.channels.fetch(channelId) as TextChannel;

        for (var call in report) {
          final message = BotMessageBuilder(
            header: MessageContent([
              MessagePart('${Mention(id: roleId, type: MentionType.role)}\n'),
              MessagePart('# Atenção! Nova ligação perdida', isBold: true),
            ]),
            content: MessageContent([
              MessagePart(call.callTime),
              MessagePart('```${call.callerNumber}```'),
            ]),
          ).build();
          channel.sendMessage(MessageBuilder(content: message));
        }
      }
    });
  }
}
