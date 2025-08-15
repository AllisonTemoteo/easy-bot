import 'package:nyxx/nyxx.dart';

enum MentionType {
  user('@'),
  role('@&'),
  channel('#');

  final String value;
  const MentionType(this.value);
}

class Mention {
  Mention({required this.type, required this.id});
  MentionType type;
  Snowflake id;

  String get mentionFormated => '<${type.value}$id>';

  @override
  String toString() {
    return mentionFormated;
  }
}

class MessagePart {
  MessagePart(
    String part, {
    this.isBold = false,
    this.isItalic = false,
    this.isSpoiler = false,
    this.isStrikethrough = false,
    this.isUnderlined = false,
  }) : _part = part;

  String _part;

  final bool isBold;
  final bool isItalic;
  final bool isSpoiler;
  final bool isStrikethrough;
  final bool isUnderlined;

  String build() {
    if (isSpoiler) {
      _part = '||$_part||';
    }

    if (isItalic) {
      _part = '_${_part}_';
    }

    if (isBold) {
      _part = '**$_part**';
    }

    if (isStrikethrough) {
      _part = '~~$_part~~';
    }

    if (isUnderlined) {
      _part = '__${_part}__';
    }

    return _part;
  }
}

class MessageContent {
  MessageContent(this.parts);

  final List<MessagePart> parts;

  String build() {
    String content = '';

    for (var part in parts) {
      content += part.build();
    }

    return content;
  }
}

class BotMessageBuilder {
  BotMessageBuilder({this.header, required this.content});

  MessageContent? header;
  MessageContent content;

  String build() {
    String strHeader = '';

    if (header != null) {
      strHeader = header!.build();
    }

    return '$strHeader\n${content.build()}';
  }
}
