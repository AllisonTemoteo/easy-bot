import 'package:dotenv/dotenv.dart';

abstract class Env {
  static String get(String key, {String? defaultValue}) {
    final env = DotEnv(includePlatformEnvironment: true)..load();
    final value = env[key.trim()] ?? defaultValue;

    if (value == null) {
      throw Exception('Env key not founded or has no value');
    }

    return value;
  }
}
