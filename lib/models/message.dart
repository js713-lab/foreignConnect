// lib/models/message.dart

import 'package:json_annotation/json_annotation.dart';
part 'message.g.dart';

@JsonEnum()
enum MessageType {
  text,
  image,
  file,
  voice,
  video,
  location,
  contact,
  reply,
  system,
  deleted
}

@JsonEnum()
enum MessageStatus { sending, sent, delivered, read, failed }

@JsonSerializable()
class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String recipientId;
  String content;
  @JsonKey(defaultValue: MessageType.text)
  final MessageType type;
  final String? attachmentUrl;
  final DateTime timestamp;
  final String? replyToMessageId;
  final Map<String, dynamic>? metadata;
  @JsonKey(defaultValue: MessageStatus.sending)
  MessageStatus status;
  DateTime? deliveredAt;
  DateTime? readAt;
  @JsonKey(defaultValue: false)
  bool isEdited;
  DateTime? editedAt;
  @JsonKey(defaultValue: false)
  bool isDeleted;
  @JsonKey(defaultValue: [])
  List<String> readBy;
  @JsonKey(defaultValue: [])
  List<String> deliveredTo;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.recipientId,
    required this.content,
    this.type = MessageType.text,
    this.attachmentUrl,
    required this.timestamp,
    this.replyToMessageId,
    this.metadata,
    this.status = MessageStatus.sending,
    this.deliveredAt,
    this.readAt,
    this.isEdited = false,
    this.editedAt,
    this.isDeleted = false,
    List<String>? readBy,
    List<String>? deliveredTo,
  })  : readBy = readBy ?? [],
        deliveredTo = deliveredTo ?? [];

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  Message copyWith({
    String? content,
    MessageStatus? status,
    DateTime? deliveredAt,
    DateTime? readAt,
    bool? isEdited,
    DateTime? editedAt,
    bool? isDeleted,
    List<String>? readBy,
    List<String>? deliveredTo,
  }) {
    return Message(
      id: id,
      chatId: chatId,
      senderId: senderId,
      recipientId: recipientId,
      content: content ?? this.content,
      type: type,
      attachmentUrl: attachmentUrl,
      timestamp: timestamp,
      replyToMessageId: replyToMessageId,
      metadata: metadata,
      status: status ?? this.status,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      readAt: readAt ?? this.readAt,
      isEdited: isEdited ?? this.isEdited,
      editedAt: editedAt ?? this.editedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      readBy: readBy ?? List.from(this.readBy),
      deliveredTo: deliveredTo ?? List.from(this.deliveredTo),
    );
  }
}
