import 'package:easy_bot/utils/guild_entity.dart';

class Message {
  Message({
    required this.template,
    required this.receiver,
    this.mentions,
    this.placeholders,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    final template = map['template'] as String;
    final placeholders = map['placeholders'] as Map<String, Object>?;

    final mentionsMap = (map['mentions'] as List)
        .map((e) => Map<String, String>.from(e as Map))
        .toList();

    final receiver = GuildEntity.fromMap(map['receiver']);

    final mentions = mentionsMap
        .map((e) => Map<String, String>.from(e as Map))
        .toList()
        .map(GuildEntity.fromMap)
        .toList();

    return Message(
      mentions: mentions,
      template: template,
      receiver: receiver,
      placeholders: placeholders,
    );
  }

  final String template;
  final List<GuildEntity>? mentions;
  final GuildEntity receiver;
  Map<String, Object>? placeholders;

  String get content {
    String content = '';

    if (mentions != null) {
      String separator = '';
      for (int i = mentions!.length - 1; i >= 0; i--) {
        content = mentions![i].mentionFormat + separator + content;
        separator = ', ';
      }
    }

    content += '\n';
    content += (placeholders == null ? template : _resolvePlaceholders());

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
