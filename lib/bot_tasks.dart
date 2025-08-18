import 'dart:async';
import 'package:easy_bot/easy_bot.dart';
import 'package:easy_bot/controllers/npx_controller.dart';
import 'package:easy_bot/utils/action.dart';
import 'package:easy_bot/utils/easy_message_builder.dart' as mb;
import 'package:nyxx/nyxx.dart';

class Task {
  Task({
    required this.name,
    required this.action,
    this.description,
    this.execParams,
  });

  final String name;
  final Action action;
  final Map<String, Object>? execParams;

  String? description;

  Timer? _timer;

  void exec() {
    print('[Task] Executing: $name');
    action(execParams);
  }

  void execDelayed(Duration delay) {
    _timer = Timer(delay, exec);
  }

  void execPeriodic(Duration interval) {
    exec();
    _timer = Timer.periodic(interval, (timer) => exec());
  }

  void stop() {
    _timer?.cancel();
  }
}

class MonitoreMissedCallsTask {
  final NpxController controller = NpxController.instance;

  Timer? timer;

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
          final message = mb.BotMessageBuilder(
            header: mb.MessageContent([
              mb.MessagePart('# Atenção! Nova ligação perdida', isBold: true),
            ]),
            content: mb.MessageContent([
              mb.MessagePart(call.callTime),
              mb.MessagePart('```${call.callerNumber}```\n'),
              mb.MessagePart(
                '${mb.Mention(id: roleId, type: mb.MentionType.role)}\n',
              ),
            ]),
          ).build();

          channel.sendMessage(MessageBuilder(content: message));
        }
      }
    });
  }
}
