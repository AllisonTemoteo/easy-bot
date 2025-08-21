import 'package:easy_bot/services/config_service.dart';
import 'package:easy_bot/utils/env.dart';
import 'package:easy_bot/utils/message.dart';
import 'package:easy_bot/utils/task.dart';
import 'package:easy_bot/utils/actions.dart';

enum Actions {
  getMissedCalls('getMissedCalls');

  final String name;
  const Actions(this.name);
}

enum Tasks {
  monitoreMissedCalls('monitoreMissedCalls');

  //
  final String name;
  const Tasks(this.name);
}

class BotConfig {
  BotConfig._internal({required this.messages});
  static BotConfig? _instance;
  static BotConfig get instance => _instance ??= _init();

  static final tasks = <Task>[
    Task(
      name: Tasks.monitoreMissedCalls.name,
      actions: [actions[Actions.getMissedCalls]!],
      execInterval: Duration(seconds: 5),
    ),
  ];

  static final actions = <Actions, Action>{
    Actions.getMissedCalls: GetMissedCAllsAction(),
  };

  final List<Message> messages;

  static BotConfig _init() {
    final env = Env.get('ENV', defaultValue: 'dev');
    final configs = ConfigService('config.$env.json');

    final messages = configs
        .messages //
        .map(Message.fromMap)
        .toList();

    return BotConfig._internal(messages: messages);
  }

  void startTasks() {
    for (var task in tasks) {
      if (task.isActive) {
        print('Starting task: ${task.name}');
        task.start();
      }
    }
  }

  void taskRegister(Task task) {
    print('Registering ${task.name}');
    tasks.add(task);
  }

  Task getTaskByName(String name) =>
      tasks.firstWhere((task) => task.name == name);

  Message getMessageByName(String name) =>
      messages.firstWhere((message) => message.name == name);
}
