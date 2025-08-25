import 'dart:convert';

import 'package:easy_bot/services/storage/file_service.dart';
import 'package:easy_bot/utils/env.dart';
import 'package:easy_bot/utils/task.dart';

enum Tasks {
  monitoreMissedCalls('monitoreMissedCalls');

  //
  final String name;
  const Tasks(this.name);
}

class BotConfig {
  BotConfig._internal();
  static BotConfig? _instance;
  static BotConfig get instance => _instance ??= _init();

  static final List<Task> tasks = [];

  static BotConfig _init() {
    final env = Env.get('ENV', defaultValue: 'dev');
    final configs =
        jsonDecode(FileService.readAsString('config.$env.json'))
            as Map<String, dynamic>;

    // Carrega as tasks ---------------------------------------

    if (configs.containsKey('bot')) {
      final botConfigs = configs['bot'];
      final tasksMap = botConfigs['tasks'] as List;

      final List<Map<String, dynamic>> tasksList = tasksMap
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      for (var item in tasksList) {
        final task = Task.fromMap(item);
        tasks.add(task);

        if (item['autostart']) {
          task.start();
        }
      }
    }

    // --------------------------------------------------------

    return BotConfig._internal();
  }

  void startTasks() {
    if (tasks.isNotEmpty) {
      Task monitoreMissedCalls = getTaskByName(Tasks.monitoreMissedCalls.name);
      monitoreMissedCalls.start();
    }
  }

  void taskRegister(Task task) {
    print('Registering ${task.name}');
    tasks.add(task);
  }

  Task getTaskByName(String name) =>
      tasks.firstWhere((task) => task.name == name);
}
