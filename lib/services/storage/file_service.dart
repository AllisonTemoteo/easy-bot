import 'dart:io';

import 'package:easy_bot/utils/errors.dart';
import 'package:path/path.dart';

abstract class FileService {
  static final String _base = join(Directory.current.path, 'bin');

  static void createFile(String path, String name) async {
    final fileDir = join(_base, path);
    final fileFullName = join(fileDir, name);

    try {
      File(fileFullName).createSync(recursive: true);
    } catch (e) {
      throw AppIOException('Não foi possível criar o arquivo $name\n$e');
    }
  }

  static String readAsString(String path) {
    final filePath = join(_base, path);
    final file = File(filePath);

    try {
      return file.readAsStringSync();
    } catch (e) {
      throw AppIOException('Não foi possível ler o arquivo em $path\n$e');
    }
  }

  static void writeAsString(String path, String content) {
    final filePath = join(_base, path);
    final file = File(filePath);

    try {
      file.writeAsStringSync(content);
    } catch (e) {
      throw AppIOException('Não foi possível escrever no arquivo $path\n$e');
    }
  }
}
