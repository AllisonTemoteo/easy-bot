import 'dart:async';

import 'package:easy_bot/utils/easy_message_builder.dart';
import 'package:easy_bot/models/call_model.dart';
import 'package:easy_bot/repositories/npx_repository_api.dart';
import 'package:easy_bot/services/npx_api_client.dart';
import 'package:nyxx/nyxx.dart';

class NpxCommandsController {
  Timer? _monitor;

  Map<String, NpxCallModel> missedCalls = {};

  void startMonitoring(Role mention, TextChannel target) {
    if (_monitor != null) {
      print("Monitoramento já está ativo");
      return;
    }

    final monitoringRefreshTime = Duration(seconds: 2);

    _monitor = Timer.periodic(monitoringRefreshTime, (timer) async {
      final client = NpxApiClient();
      final api = NpxRepositoryApi(client);

      try {
        final DateTime now = DateTime.now();

        final calls = await api.getMissedCalls(
          Interval(
            dateTimeStarting: now.subtract(Duration(days: 2)),
            dateTimeEnding: now,
          ),
        );
        if (calls != null) {
          for (int i = 0; i < calls.length; i++) {
            String callId = '${calls[i].callTimeText}${calls[i].callerNumber}';
            if (missedCalls.containsKey(callId)) {
              continue;
            }

            missedCalls[callId] = calls[i];

            var message = BotMessageBuilder(
              header: MessageHeader(
                mentions: MessageMentions(
                  mentions: [
                    Mention(mentionType: MentionType.role, id: mention.id),
                  ],
                ),
                title: MessageContent([
                  MessageContentPart(
                    '# Atenção! Nova chamada perdida',
                    isBold: true,
                  ),
                ]),
              ),
              content: MessageContent([
                MessageContentPart(calls[i].callTimeText),
                MessageContentPart('```${calls[i].callerNumber}```'),
              ]),
            );

            target.sendMessage(MessageBuilder(content: message.build()));
          }
        }

        print('$now: $calls');
      } catch (e) {
        print('API error');
      }
    });
  }

  void stopMonitoring() {
    _monitor?.cancel();
    _monitor = null;
    print('Monitor stoped');
  }
}
