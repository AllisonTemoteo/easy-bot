import 'package:easy_bot/config/app_config.dart';
import 'package:easy_bot/config/bot_config.dart';
import 'package:easy_bot/controllers/npx_controller.dart';
import 'package:easy_bot/services/nyxx/nyxx_service.dart';

abstract class Action {
  Action({required this.name});
  final String name;

  Future call(Map<String, Object>? params);
}

class GetMissedCAllsAction extends Action {
  GetMissedCAllsAction() : super(name: 'getMissedCalls');

  @override
  Future call(Map<String, Object>? params) async {
    final appConfig = await AppConfig.instance;

    final controller = NpxController.instance;
    final report = await controller.getNewMissedCalls();

    if (report == null) {
      return;
    }

    for (var call in report) {
      final botConfig = BotConfig.instance;
      final message = botConfig.getMessageByName('newMissedCall');

      message.placeholders = {'{time}': call.time, '{number}': call.number};

      final NyxxService nyxx = await NyxxService.instance;
      nyxx.sendMessage(message, appConfig.getChannelByName('teste-easybot'));
    }
  }
}
