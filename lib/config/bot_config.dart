import 'package:easy_bot/bot_tasks.dart';
import 'package:easy_bot/utils/action.dart';

class BotConfig {
  BotConfig._internal();
  static BotConfig? _instance;
  static BotConfig get instance => _init();

  final tasks = <String, Task>{};

  static BotConfig _init() {
    if (_instance != null) {
      return _instance!;
    }

    _instance = BotConfig._internal();

    _instance!.taskRegister(
      Task(name: 'monitoreMissedCalls', action: GetMissedCAllsAction()),
    );

    return _instance!;
  }

  void taskRegister(Task task) {
    print('Registering ${task.name}');
    tasks[task.name] = task;
  }

  Task getTaskByName(String name) {
    return tasks[name]!;
  }
}
