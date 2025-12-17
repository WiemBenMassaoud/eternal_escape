import 'package:hive_flutter/hive_flutter.dart';
import '../models/message.dart';
import '../models/conversation.dart';

class ChatStorage {
  static const String boxName = 'chats';
  static const String conversationsKey = 'conversations_list';
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      // Vérifier si les adaptateurs sont enregistrés
      if (!Hive.isAdapterRegistered(10)) {
        Hive.registerAdapter(MessageAdapter());
        print('✅ MessageAdapter enregistré dans ChatStorage');
      }
      
      if (!Hive.isAdapterRegistered(11)) {
        Hive.registerAdapter(ConversationAdapter());
        print('✅ ConversationAdapter enregistré dans ChatStorage');
      }
      
      // Vérifier si Hive est déjà initialisé
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox(boxName);
      }
      
      _isInitialized = true;
      print('✅ ChatStorage initialisé avec succès');
    } catch (e) {
      print('❌ Erreur lors de l\'initialisation de ChatStorage: $e');
      
      // Tentative de récupération
      try {
        // Fermer la box si elle est ouverte
        if (Hive.isBoxOpen(boxName)) {
          await Hive.box(boxName).close();
        }
        
        // Réessayer d'ouvrir
        await Hive.openBox(boxName);
        _isInitialized = true;
        print('✅ ChatStorage réinitialisé après erreur');
      } catch (retryError) {
        print('❌ Échec de la réinitialisation: $retryError');
        _isInitialized = false;
        rethrow;
      }
    }
  }

  static Box _getBox() {
    if (!_isInitialized || !Hive.isBoxOpen(boxName)) {
      throw Exception('ChatStorage non initialisé. Appelez ChatStorage.init() d\'abord.');
    }
    return Hive.box(boxName);
  }

  // ---------------- Messages per contact ----------------
  static Future<void> saveMessages(String contactName, List<Message> messages) async {
    try {
      final box = _getBox();
      await box.put('chat_$contactName', messages);
    } catch (e) {
      print('❌ Erreur sauvegarde messages pour $contactName: $e');
      rethrow;
    }
  }

  static List<Message> loadMessages(String contactName) {
    try {
      final box = _getBox();
      final raw = box.get('chat_$contactName');
      
      if (raw == null) return [];
      
      // Si c'est déjà une liste de Message
      if (raw is List && raw.isNotEmpty && raw.first is Message) {
        return List<Message>.from(raw);
      }
      
      // Migration depuis l'ancien format
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
          throw Exception('Type de message non supporté');
        }).toList();
        
        // Sauvegarder le format migré
        box.put('chat_$contactName', migrated);
        return migrated;
      } catch (migrationError) {
        print('❌ Erreur migration messages: $migrationError');
        return [];
      }
    } catch (e) {
      print('❌ Erreur chargement messages pour $contactName: $e');
      return [];
    }
  }

  static Future<void> deleteConversationMessages(String contactName) async {
    try {
      final box = _getBox();
      await box.delete('chat_$contactName');
    } catch (e) {
      print('❌ Erreur suppression messages: $e');
    }
  }

  // ---------------- Conversations list ----------------
  static Future<void> saveConversations(List<Conversation> conversations) async {
    try {
      final box = _getBox();
      await box.put(conversationsKey, conversations);
      print('✅ ${conversations.length} conversations sauvegardées');
    } catch (e) {
      print('❌ Erreur sauvegarde conversations: $e');
      rethrow;
    }
  }

  static List<Conversation> loadConversations() {
    try {
      final box = _getBox();
      final raw = box.get(conversationsKey);
      
      if (raw == null) {
        print('ℹ️ Aucune conversation trouvée dans le stockage');
        return [];
      }
      
      // Si c'est déjà une liste de Conversation
      if (raw is List && raw.isNotEmpty && raw.first is Conversation) {
        final convs = List<Conversation>.from(raw);
        print('✅ ${convs.length} conversations chargées');
        return convs;
      }
      
      // Migration depuis l'ancien format
      try {
        print('🔄 Tentative de migration des conversations...');
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
          throw Exception('Type de conversation non supporté');
        }).toList();
        
        // Sauvegarder le format migré
        box.put(conversationsKey, migrated);
        print('✅ ${migrated.length} conversations migrées');
        return migrated;
      } catch (migrationError) {
        print('❌ Erreur migration conversations: $migrationError');
        return [];
      }
    } catch (e) {
      print('❌ Erreur chargement conversations: $e');
      return [];
    }
  }

  static Future<void> deleteConversationMetadata(String contactName) async {
    try {
      final convs = loadConversations();
      convs.removeWhere((c) => c.name == contactName);
      await saveConversations(convs);
    } catch (e) {
      print('❌ Erreur suppression métadata conversation: $e');
    }
  }

  // ---------------- Helpers to keep messages & conversations synced ----------------
  static Future<void> updateConversationLastMessage({
    required String contactName,
    required String lastMessage,
    required String time,
    required bool lastMessageFromMe,
    int? avatarColorValue,
    bool? isOnline,
  }) async {
    try {
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
        print('🔄 Conversation existante mise à jour: $contactName');
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
        print('🆕 Nouvelle conversation créée: $contactName');
      }
      
      await saveConversations(convs);
      print('✅ Conversation $contactName mise à jour avec succès');
    } catch (e) {
      print('❌ Erreur mise à jour conversation: $e');
      rethrow;
    }
  }

  // Méthode pour fermer proprement
  static Future<void> close() async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
    _isInitialized = false;
  }
}