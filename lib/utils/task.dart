import 'dart:async';
import 'package:easy_bot/utils/actions.dart';

class Task {
  Task({
    required this.name,
    required this.actions,
    this.delay = Duration.zero,
    this.execInterval,
    this.description,
    this.execParams,
    this.isActive = true,
  });

  final String name;
  final List<Action> actions;

  final Map<String, Object>? execParams;

  final Duration delay;
  final Duration? execInterval;
  final bool isActive;

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
    _execAtions();

    if (execInterval != null) {
      _timer = Timer.periodic(execInterval!, (timer) => _execAtions());
    }
  }

  void _execAtions() async {
    Map<String, Object>? lastActionResult = execParams;

    for (Action action in actions) {
      lastActionResult = await action(lastActionResult);
    }
  }

  void _delayedExec() async {
    await Future.delayed(delay);
    _exec();
  }

  void stop() {
    _timer?.cancel();
  }
}
