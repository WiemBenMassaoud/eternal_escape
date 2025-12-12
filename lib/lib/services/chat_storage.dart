import 'package:hive_flutter/hive_flutter.dart';
import '../models/message.dart';
import '../models/conversation.dart';

class ChatStorage {
  static const String boxName = 'chats';
  static const String conversationsKey = 'conversations_list';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(MessageAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(ConversationAdapter());
    await Hive.openBox(boxName);
  }

  // ---------------- Messages per contact ----------------
  static Future<void> saveMessages(String contactName, List<Message> messages) async {
    final box = Hive.box(boxName);
    await box.put('chat_$contactName', messages);
  }

  static List<Message> loadMessages(String contactName) {
    final box = Hive.box(boxName);
    final raw = box.get('chat_$contactName');
    if (raw == null) return [];
    if (raw is List && raw.isNotEmpty && raw.first is Message) return List<Message>.from(raw);
    // Legacy migration
    try {
      final list = List<dynamic>.from(raw);
      final migrated = list.map((e) {
        if (e is Message) return e;
        if (e is Map) {
          return Message(
            text: e['text'] as String,
            isSent: e['isSent'] as bool,
            time: DateTime.parse(e['time'] as String),
            isRead: e['isRead'] as bool,
          );
        }
        throw Exception('Unsupported message type');
      }).toList();
      box.put('chat_$contactName', migrated);
      return migrated;
    } catch (_) {
      return [];
    }
  }

  static Future<void> deleteConversationMessages(String contactName) async {
    final box = Hive.box(boxName);
    await box.delete('chat_$contactName');
  }

  // ---------------- Conversations list ----------------
  static Future<void> saveConversations(List<Conversation> conversations) async {
    final box = Hive.box(boxName);
    await box.put(conversationsKey, conversations);
  }

  static List<Conversation> loadConversations() {
    final box = Hive.box(boxName);
    final raw = box.get(conversationsKey);
    if (raw == null) return [];
    if (raw is List && raw.isNotEmpty && raw.first is Conversation) return List<Conversation>.from(raw);
    // Legacy migration from Map -> Conversation
    try {
      final list = List<dynamic>.from(raw);
      final migrated = list.map((e) {
        if (e is Conversation) return e;
        if (e is Map) {
          return Conversation(
            name: e['name'] as String,
            avatarColorValue: e['avatarColorValue'] as int,
            isOnline: e['isOnline'] as bool? ?? false,
            isPinned: e['isPinned'] as bool? ?? false,
            notificationsEnabled: e['notificationsEnabled'] as bool? ?? true,
            lastMessageFromMe: e['lastMessageFromMe'] as bool? ?? false,
            lastMessage: e['lastMessage'] as String? ?? '',
            time: e['time'] as String? ?? '',
            unread: e['unread'] as int? ?? 0,
          );
        }
        throw Exception('Unsupported conversation type');
      }).toList();
      box.put(conversationsKey, migrated);
      return migrated;
    } catch (_) {
      return [];
    }
  }

  static Future<void> deleteConversationMetadata(String contactName) async {
    final convs = loadConversations();
    convs.removeWhere((c) => c.name == contactName);
    await saveConversations(convs);
  }

  // ---------------- Helpers to keep messages & conversations synced ----------------

  // Update (or create) conversation metadata after a new message
  static Future<void> updateConversationLastMessage({
    required String contactName,
    required String lastMessage,
    required String time,
    required bool lastMessageFromMe,
    int? avatarColorValue,
    bool? isOnline,
  }) async {
    final convs = loadConversations();
    final idx = convs.indexWhere((c) => c.name == contactName);
    if (idx >= 0) {
      final conv = convs[idx];
      conv.lastMessage = lastMessage;
      conv.time = time;
      conv.lastMessageFromMe = lastMessageFromMe;
      conv.unread = lastMessageFromMe ? 0 : conv.unread + 1;
      if (avatarColorValue != null) conv.avatarColorValue = avatarColorValue;
      if (isOnline != null) conv.isOnline = isOnline;
      convs[idx] = conv;
    } else {
      final conv = Conversation(
        name: contactName,
        avatarColorValue: avatarColorValue ?? 0xFF6C63FF,
        isOnline: isOnline ?? false,
        lastMessage: lastMessage,
        time: time,
        lastMessageFromMe: lastMessageFromMe,
        unread: lastMessageFromMe ? 0 : 1,
      );
      convs.insert(0, conv);
    }
    await saveConversations(convs);
  }
}