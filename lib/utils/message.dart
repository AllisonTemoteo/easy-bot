import 'package:easy_bot/utils/guild_entity.dart';

class Message {
  Message({
    required this.name,
    required this.template,
    this.mentions,
    this.placeholders,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    final name = map['name'];
    final template = map['template'] as String;
    final placeholders = map['placeholders'] as Map<String, Object>?;

    final mentionsMap = (map['mentions'] as List)
        .map((e) => Map<String, String>.from(e as Map))
        .toList();

    final mentions = mentionsMap
        .map((e) => Map<String, String>.from(e as Map))
        .toList()
        .map(GuildEntity.fromMap)
        .toList();

    return Message(
      name: name,
      mentions: mentions,
      template: template,
      placeholders: placeholders,
    );
  }

  final String name;
  final String template;
  final List<GuildEntity>? mentions;
  Map<String, Object>? placeholders;

  String get content {
    var content = StringBuffer();

    if (mentions != null) {
      String separator = '';
      for (int i = mentions!.length - 1; i >= 0; i--) {
        content.write(mentions![i].mentionFormat + separator);
        separator = ', ';
      }
    }

    content.write('\n');
    content.write(placeholders == null ? template : _resolvePlaceholders());

    return content.toString();
  }

  String _resolvePlaceholders() {
    final regex = RegExp(r'({.*})');

    return template.replaceAllMapped(regex, (match) {
      final key = match.group(1)?.trim();
      if (key == null) return match.group(0)!;

      final value = placeholders![key];

      return value?.toString() ?? match.group(0)!;
    });
  }
}
