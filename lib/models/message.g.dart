// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';
// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      recipientId: json['recipientId'] as String,
      content: json['content'] as String,
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
          MessageType.text,
      attachmentUrl: json['attachmentUrl'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      replyToMessageId: json['replyToMessageId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      status: $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
          MessageStatus.sending,
      deliveredAt: json['deliveredAt'] == null
          ? null
          : DateTime.parse(json['deliveredAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      isEdited: json['isEdited'] as bool? ?? false,
      editedAt: json['editedAt'] == null
          ? null
          : DateTime.parse(json['editedAt'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
      readBy: (json['readBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      deliveredTo: (json['deliveredTo'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'chatId': instance.chatId,
      'senderId': instance.senderId,
      'recipientId': instance.recipientId,
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type],
      'attachmentUrl': instance.attachmentUrl,
      'timestamp': instance.timestamp.toIso8601String(),
      'replyToMessageId': instance.replyToMessageId,
      'metadata': instance.metadata,
      'status': _$MessageStatusEnumMap[instance.status],
      'deliveredAt': instance.deliveredAt?.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
      'isEdited': instance.isEdited,
      'editedAt': instance.editedAt?.toIso8601String(),
      'isDeleted': instance.isDeleted,
      'readBy': instance.readBy,
      'deliveredTo': instance.deliveredTo,
    };

final _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.file: 'file',
  MessageType.voice: 'voice',
  MessageType.video: 'video',
  MessageType.location: 'location',
  MessageType.contact: 'contact',
  MessageType.reply: 'reply',
  MessageType.system: 'system',
  MessageType.deleted: 'deleted',
};

final _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.read: 'read',
  MessageStatus.failed: 'failed',
};
