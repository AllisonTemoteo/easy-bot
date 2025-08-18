import 'package:easy_bot/config/app_config.dart';
import 'package:easy_bot/controllers/npx_controller.dart';
import 'package:easy_bot/utils/message.dart';
import 'package:easy_bot/utils/message_sender.dart';

abstract class Action {
  Action({required this.name, this.message});

  final String name;
  final Message? message;

  Future call(Map<String, Object>? params);
}

class GetMissedCAllsAction extends Action {
  GetMissedCAllsAction({super.message}) : super(name: 'getMissedCalls');

  @override
  Future call(Map<String, Object>? params) async {
    final appConfig = AppConfig();

    final controller = NpxController.instance;
    final report = await controller.getNewMissedCalls();

    if (report == null) {
      return;
    }

    for (var call in report) {
      final message = Message(
        mentions: [appConfig.roles['Patrão']!],
        template: '# Atenção! Nova ligação perdida\n{time}\n```{number}```',
        placeholders: {'{time}': call.callTime, '{number}': call.callerNumber},
      );

      MessageSender.sendToChannel(
        message,
        appConfig.textChannels['teste-easybot']!,
      );
    }
  }
}
