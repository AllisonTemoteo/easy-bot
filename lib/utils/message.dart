import 'package:easy_bot/utils/guild_entity.dart';

class Message {
  Message({
    required this.mentions,
    required this.template,
    required this.placeholders,
  });

  final List<GuildEntity>? mentions;
  final String template;
  final Map<String, Object> placeholders;

  String get content {
    var content = StringBuffer();

    if (mentions != null) {
      String separator = '';
      for (int i = mentions!.length - 1; i >= 0; i--) {
        if (mentions![i] is GuildRole) {
          content.write('<@&${mentions![i].id}>$separator');
        }

        if (mentions![i] is GuildUser) {
          content.write('<@${mentions![i].id}>$separator');
        }

        if (mentions![i] is GuildTextChannel) {
          content.write('<#&${mentions![i].id}>$separator');
        }

        separator = ', ';
      }
    }

    content.write('\n');
    content.write(_resolvePlaceholders());

    return content.toString();
  }

  String _resolvePlaceholders() {
    final regex = RegExp(r'({.*})');

    return template.replaceAllMapped(regex, (match) {
      final key = match.group(1)?.trim();
      if (key == null) return match.group(0)!;

      final value = placeholders[key];

      return value?.toString() ?? match.group(0)!;
    });
  }
}
