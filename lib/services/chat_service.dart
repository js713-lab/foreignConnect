// lib/services/chat_service.dart

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class ChatService {
  static const String baseUrl =
      'YOUR_SERVER_URL'; // e.g., 'http://your-server.com'
  late IO.Socket socket;
  final String userId;
  final StreamController<Message> _messageController =
      StreamController<Message>.broadcast();

  Stream<Message> get messageStream => _messageController.stream;

  ChatService({required this.userId}) {
    _initSocket();
  }

  void _initSocket() {
    socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'userId': userId},
    });

    socket.connect();

    socket.on('connect', (_) {
      debugPrint('Connected to socket server');
    });

    socket.on('message', (data) {
      final message = Message.fromJson(data);
      _messageController.add(message);
    });

    socket.on('typing', (data) {
      // Handle typing indicator
    });

    socket.on('disconnect', (_) {
      debugPrint('Disconnected from socket server');
    });
  }

  Future<void> sendMessage({
    required String chatId,
    required String recipientId,
    required String content,
    String? attachmentUrl,
    MessageType type = MessageType.text,
  }) async {
    final message = {
      'chatId': chatId,
      'senderId': userId,
      'recipientId': recipientId,
      'content': content,
      'type': type.toString(),
      'attachmentUrl': attachmentUrl,
      'timestamp': DateTime.now().toIso8601String(),
    };

    socket.emit('message', message);

    // Store message in database through REST API
    await http.post(
      Uri.parse('$baseUrl/api/messages'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(message),
    );
  }

  Future<void> sendTypingStatus({
    required String chatId,
    required String recipientId,
    required bool isTyping,
  }) {
    socket.emit('typing', {
      'chatId': chatId,
      'senderId': userId,
      'recipientId': recipientId,
      'isTyping': isTyping,
    });
    return Future.value();
  }

  Future<String?> uploadAttachment(PlatformFile file) async {
    try {
      final uri = Uri.parse('$baseUrl/api/upload');
      final request = http.MultipartRequest('POST', uri);

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path!,
          filename: path.basename(file.path!),
        ),
      );

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final json = jsonDecode(responseString);

      return json['url'];
    } catch (e) {
      debugPrint('Error uploading file: $e');
      return null;
    }
  }

  Future<List<Message>> loadChatHistory(String chatId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/messages/$chatId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Message.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error loading chat history: $e');
      return [];
    }
  }

  void dispose() {
    socket.disconnect();
    _messageController.close();
  }
}

enum MessageType { text, image, file, voice, emoji }

class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String recipientId;
  final String content;
  final MessageType type;
  final String? attachmentUrl;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.recipientId,
    required this.content,
    required this.type,
    this.attachmentUrl,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      recipientId: json['recipientId'],
      content: json['content'],
      type: MessageType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => MessageType.text,
      ),
      attachmentUrl: json['attachmentUrl'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
