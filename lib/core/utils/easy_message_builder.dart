import 'package:nyxx/nyxx.dart';

enum MentionType {
  role('&'),
  user('');

  final String value;
  const MentionType(this.value);
}

class Mention {
  Mention({required this.mentionType, required this.id});
  MentionType mentionType;
  Snowflake id;

  String get _mentionType => mentionType.value;
}

class MessageMentions {
  MessageMentions({required this.mentions});
  List<Mention> mentions;

  String build() {
    String strMentions = '';
    String separator = '';

    for (int i = mentions.length - 1; i >= 0; i--) {
      strMentions =
          '<@${mentions[i]._mentionType}${mentions[i].id}>'
          '$separator$strMentions';
      separator = ', ';
    }

    return strMentions;
  }
}

class MessageContentPart {
  MessageContentPart(
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

  final List<MessageContentPart> parts;

  String build() {
    String content = '';

    for (int i = 0; i < parts.length; i++) {
      content += parts[i].build();
    }

    return content;
  }
}

class MessageHeader {
  MessageHeader({MessageMentions? mentions, required MessageContent title})
    : _mentions = mentions,
      _title = title;

  final MessageMentions? _mentions;
  final MessageContent _title;

  String build() {
    String strMentions = '';

    if (_mentions != null) {
      strMentions += _mentions.build();
    }

    return '$strMentions\n${_title.build()}';
  }
}

class BotMessageBuilder {
  BotMessageBuilder({this.header, required this.content});

  MessageHeader? header;
  MessageContent content;

  String build() {
    String strHeader = '';

    if (header != null) {
      strHeader = header!.build();
    }

    return '$strHeader\n'
        '${content.build()}';
  }
}
