import 'dart:io';

import 'package:easy_bot/utils/errors.dart';
import 'package:path/path.dart';

class FileService {
  final String _base = Directory.current.path;

  void createFile(String path, String name) async {
    final fileDir = join(_base, path);
    final fileFullName = join(fileDir, name);

    try {
      File(fileFullName).createSync(recursive: true);
    } catch (e) {
      throw AppIOException('Não foi possível criar o arquivo $name\n$e');
    }
  }

  Future<String> readAsString(String path) async {
    final filePath = join(_base, path);
    final file = File(filePath);

    try {
      return await file.readAsString();
    } catch (e) {
      throw AppIOException('Não foi possível ler o arquivo em $path\n$e');
    }
  }

  Future<void> writeAsString(String path, String content) async {
    final filePath = join(_base, path);
    final file = File(filePath);

    try {
      await file.writeAsString(content);
    } catch (e) {
      throw AppIOException('Não foi possível escrever no arquivo $path\n$e');
    }
  }
}
