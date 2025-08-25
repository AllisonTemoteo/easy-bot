import 'package:easy_bot/controllers/npx_controller.dart';
import 'package:easy_bot/services/nyxx/nyxx_service.dart';
import 'package:easy_bot/utils/errors.dart';
import 'package:easy_bot/utils/message.dart';

sealed class Action {
  Action({required _Executable execute, required this.name})
    : _execute = execute;

  final _Executable _execute;
  final String name;

  Map<String, dynamic>? params;

  static Action fromMap(Map<String, dynamic> map) {
    final name = map['name'];
    final params = map['params'];

    final action = getByName(name);
    action.params = params;

    return action;
  }

  static final List<Action> actions = [
    _Action(execute: _GetAndShowMissedCalls(), name: 'getAndShowMissedCalls'),
    _Action(execute: _SendTestMessage(), name: 'sendMessage'),
  ];

  static Action getByName(String name) {
    return actions.firstWhere((action) => action.name == name);
  }

  void execute() => _execute(params ?? {});
}

class _Action extends Action {
  _Action({required super.execute, required super.name});
}

sealed class _Executable {
  const _Executable();

  void call(Map<String, dynamic>? params);
}

class _GetAndShowMissedCalls extends _Executable {
  @override
  void call(Map<String, dynamic>? params) async {
    if (params == null) {
      throw AppException('Parametros faltando na tarefa getAndShowMissedCalls');
    }

    if (!params.containsKey('last_minutes')) {
      throw AppException('Parametros faltando na tarefa getAndShowMissedCalls');
    }

    if (!params.containsKey('message')) {
      throw AppException('Parametros faltando na tarefa getAndShowMissedCalls');
    }

    final controller = NpxController.instance;

    Duration lastMinutes = Duration(minutes: int.parse(params['last_minutes']));
    Message message = Message.fromMap(params['message']);

    final report = await controller.getNewMissedCalls(lastMinutes);

    if (report == null) {
      return;
    }

    for (var call in report) {
      message.placeholders = {'{time}': call.time, '{number}': call.number};

      final NyxxService nyxx = await NyxxService.instance;
      await nyxx.sendMessage(message, confirmation: true);
    }
  }
}

class _SendTestMessage extends _Executable {
  @override
  void call(Map<String, dynamic>? params) async {
    final message = Message.fromMap(params!['message']);

    final NyxxService nyxx = await NyxxService.instance;
    await nyxx.sendMessage(message, confirmation: true);
  }
}
