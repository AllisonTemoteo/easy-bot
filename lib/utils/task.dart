import 'dart:async';
import 'package:easy_bot/utils/action.dart';

class Task {
  Task({
    required this.name,
    required this.action,
    this.delay = Duration.zero,
    this.execInterval,
    this.description,
    this.isActive = true,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    Action action = Action.fromMap(map['action']);
    String name = map['name'];
    bool isActive = map['is_active'];

    String? delayValue = map['delay'];
    Duration delay = Duration.zero;
    if (delayValue != null) {
      delay = Duration(
        hours: int.parse(delayValue.split(':')[0]),
        minutes: int.parse(delayValue.split(':')[1]),
        seconds: int.parse(delayValue.split(':')[2]),
      );
    }

    String? execIntervalValue = map['exec_interval'];
    Duration? execInterval;
    if (execIntervalValue != null) {
      delay = Duration(
        hours: int.parse(execIntervalValue.split(':')[0]),
        minutes: int.parse(execIntervalValue.split(':')[1]),
        seconds: int.parse(execIntervalValue.split(':')[2]),
      );
    }

    return Task(
      name: name,
      action: action,
      isActive: isActive,
      delay: delay,
      execInterval: execInterval,
    );
  }

  final String name;
  final Action action;

  Map<String, dynamic>? params;
  Duration delay;
  Duration? execInterval;
  bool isActive;

  String? description;

  Timer? _timer;

  void start() {
    if (!isActive) {
      return;
    }

    if (delay != Duration.zero) {
      _delayedExec();
      return;
    }

    _exec();
  }

  void _exec() async {
    _execAtion();

    if (execInterval != null) {
      _timer = Timer.periodic(execInterval!, (timer) => _execAtion());
    }
  }

  void _execAtion() async {
    action.execute();
  }

  void _delayedExec() async {
    await Future.delayed(delay);
    _exec();
  }

  void stop() {
    _timer?.cancel();
  }
}
