import 'dart:async';

import 'package:easy_bot/bot_tasks.dart';
import 'package:easy_bot/utils/env.dart';
import 'package:nyxx/nyxx.dart';

class EasyBot {
  EasyBot._internal();
  static EasyBot? _instance;
  static Future<EasyBot> get instance async => _instance ??= await _init();

  static NyxxGateway? _client;
  NyxxGateway get client => _client!;

  static Future<EasyBot> _init() async {
    var easyBot = EasyBot._internal();

    _client ??= await Nyxx.connectGateway(
      Env.get('DISCORD_TOKEN'),
      GatewayIntents.allUnprivileged,
      options: GatewayClientOptions(plugins: [logging, cliIntegration]),
    );

    _client!.onReady.listen((event) async {
      print('Bot ready');

      print('Setting tasks');
      final monitoreMissedCallsTask = MonitoreMissedCallsTask();
      monitoreMissedCallsTask.start(Duration(seconds: 30));
    });

    return easyBot;
  }
}
