import 'dart:async';
import 'package:easy_bot/config/app_config.dart';
import 'package:easy_bot/services/nyxx/nyxx_service.dart';

class EasyBot {
  EasyBot._internal({required this.appConfig});

  static EasyBot? _instance;
  static Future<EasyBot> get instance async =>
      _instance ??= await _initInstance();

  final AppConfig appConfig;

  static Future<EasyBot> _initInstance() async {
    await NyxxService.instance;

    final appConfig = await AppConfig.instance;
    appConfig.bot.startTasks();

    return EasyBot._internal(appConfig: appConfig);
  }
}
