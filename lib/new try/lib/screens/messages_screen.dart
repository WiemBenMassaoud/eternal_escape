// messages_screen.dart
import 'package:flutter/material.dart';
import '../models/conversation.dart';
import '../widgets/conversation_card.dart';
import 'chat_screen.dart';
import '../services/chat_storage.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Conversation> conversations = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadConversations();
  }

  void _loadConversations() {
    final saved = ChatStorage.loadConversations();
    if (saved.isNotEmpty) {
      conversations = saved;
    } else {
      conversations = [
        Conversation(name: 'Ahmed Ben Ali', avatarColorValue: Color(0xFFEC407A).value, isOnline: true, lastMessage: 'Bonjour, le logement est-il disponible pour...', time: '10:30', unread: 3),
        Conversation(name: 'Support Client', avatarColorValue: Color(0xFFFF6B6B).value, lastMessage: 'Comment pouvons-nous vous aider?', time: '23/12', unread: 1, isOnline: true),
        Conversation(name: 'Mohamed Chérif', avatarColorValue: Color(0xFF7C4DFF).value, lastMessage: 'Merci pour votre séjour!', time: '22/12', lastMessageFromMe: true),
        Conversation(name: 'Résidence El Firdaous', avatarColorValue: Color(0xFF06D6A0).value, lastMessage: 'Nouvelle offre spéciale pour vous.', time: '20/12', isOnline: true),
        Conversation(name: 'Sarah Johnson', avatarColorValue: Color(0xFFFFD166).value, lastMessage: 'Pouvons-nous modifier les dates?', time: '18/12', unread: 2, lastMessageFromMe: true),
      ];
      ChatStorage.saveConversations(conversations);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int get totalUnread => conversations.fold(0, (sum, c) => sum + c.unread);

  List<Conversation> get pinnedConversations => conversations.where((c) => c.isPinned).toList();
  List<Conversation> get unpinnedConversations => conversations.where((c) => !c.isPinned).toList();
  List<Conversation> get conversationsWithMyLastMessage => conversations.where((c) => c.lastMessageFromMe).toList();

  void _openChatWithConversation(int index) async {
    final conversation = conversations[index];
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          contactName: conversation.name,
          avatarColor: conversation.avatarColor,
          isOnline: conversation.isOnline,
          initialMessage: conversation.lastMessageFromMe ? conversation.lastMessage : null,
        ),
      ),
    );
    if (result != null && result is String) {
      setState(() {
        conversation.lastMessage = result;
        conversation.time = _getCurrentTime();
        conversation.unread = 0;
        conversation.lastMessageFromMe = true;
        final updated = conversations.removeAt(index);
        conversations.insert(0, updated);
        ChatStorage.saveConversations(conversations);
      });
    } else {
      setState(() {
        conversation.unread = 0;
        ChatStorage.saveConversations(conversations);
      });
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _showNewMessageDialog() {
    final recipientController = TextEditingController();
    final messageController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.all(0),
          titlePadding: EdgeInsets.all(24),
          actionsPadding: EdgeInsets.all(16),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFEC407A), Color(0xFFF06292)], // Dégradé rose
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFEC407A).withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.message_rounded, color: Colors.white, size: 26),
              ),
              SizedBox(width: 16),
              Text(
                'Nouveau message',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F9FF),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Color(0xFFE8EAED), width: 1.5),
                  ),
                  child: TextField(
                    controller: recipientController,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: 'Nom du destinataire',
                      hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
                      prefixIcon: Icon(Icons.person_rounded, color: Color(0xFFEC407A)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F9FF),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Color(0xFFE8EAED), width: 1.5),
                  ),
                  child: TextField(
                    controller: messageController,
                    maxLines: 4,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: 'Votre message...',
                      hintStyle: TextStyle(color: Color(0xFF9E9E9E)),
                      alignLabelWithHint: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF9E9E9E),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: Color(0xFFE8EAED), width: 1.5),
                ),
              ),
              child: Text('Annuler', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            ),
            ElevatedButton(
              onPressed: () {
                if (recipientController.text.isNotEmpty && messageController.text.isNotEmpty) {
                  Navigator.pop(context);
                  _addNewConversation(recipientController.text, messageController.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Veuillez remplir tous les champs'),
                      backgroundColor: Color(0xFFFF6B6B),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEC407A),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Text('Envoyer', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ],
        );
      },
    );
  }

  void _addNewConversation(String recipientName, String message) {
    final existingIndex = conversations.indexWhere((c) => c.name.toLowerCase() == recipientName.toLowerCase());
    if (existingIndex >= 0) {
      final conv = conversations[existingIndex];
      conv.lastMessage = message;
      conv.time = _getCurrentTime();
      conv.unread = 0;
      conv.lastMessageFromMe = true;
      setState(() {
        final vc = conversations.removeAt(existingIndex);
        conversations.insert(0, vc);
        ChatStorage.saveConversations(conversations);
      });
      _openChatWithConversation(0);
    } else {
      final conv = Conversation(
        name: recipientName,
        avatarColorValue: _generateRandomColor().value,
        lastMessage: message,
        time: _getCurrentTime(),
        lastMessageFromMe: true,
      );
      setState(() {
        conversations.insert(0, conv);
        ChatStorage.saveConversations(conversations);
      });
      _openChatWithConversation(0);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nouvelle conversation créée avec $recipientName'),
          backgroundColor: Color(0xFF06D6A0),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Color _generateRandomColor() {
    final colors = [
      Color(0xFFEC407A), // Rose
      Color(0xFF42A5F5), // Bleu
      Color(0xFFFF6B6B), // Rouge clair
      Color(0xFF7C4DFF), // Violet
      Color(0xFF06D6A0), // Vert émeraude
      Color(0xFFFFD166), // Jaune
      Color(0xFF4ECDC4), // Turquoise
      Color(0xFFFF8A80), // Rose corail
      Color(0xFF9575CD), // Violet clair
      Color(0xFF4DB6AC), // Vert bleuté
    ];
    return colors[DateTime.now().millisecondsSinceEpoch % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllMessages(),
                  _buildUnreadMessages(),
                  _buildArchivedMessages(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFEC407A).withOpacity(0.4),
              blurRadius: 25,
              offset: Offset(0, 10),
              spreadRadius: 0,
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: _showNewMessageDialog,
          label: Row(
            children: [
              Icon(Icons.edit_rounded, size: 22),
              SizedBox(width: 12),
              Text(
                'Nouveau message',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: -0.3),
              ),
            ],
          ),
          backgroundColor: Color(0xFFEC407A),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFFAFBFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 8),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFEC407A).withOpacity(0.15), Color(0xFFF06292).withOpacity(0.15)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFFEC407A).withOpacity(0.3), width: 1.5),
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFEC407A), size: 22),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Messages',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.8,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${conversations.length} conversations',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          if (totalUnread > 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFEC407A), Color(0xFFF06292)], // Dégradé rose
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFEC407A).withOpacity(0.4),
                    blurRadius: 15,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                '$totalUnread',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () => _showMoreOptions(),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFEC407A).withOpacity(0.15), Color(0xFFF06292).withOpacity(0.15)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFFEC407A).withOpacity(0.3), width: 1.5),
              ),
              child: Icon(Icons.more_vert_rounded, color: Color(0xFFEC407A), size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Color(0xFFEC407A),
        unselectedLabelColor: Color(0xFF9E9E9E),
        labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: -0.3),
        unselectedLabelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: Color(0xFFEC407A), width: 3.5),
          insets: EdgeInsets.symmetric(horizontal: 24),
        ),
        tabs: [
          Tab(text: 'Tous'),
          Tab(text: 'Non lus ($totalUnread)'),
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Mes envois'),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF06D6A0).withOpacity(0.2), Color(0xFF4ACFB0).withOpacity(0.2)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Color(0xFF06D6A0).withOpacity(0.3), width: 1.5),
                  ),
                  child: Text(
                    '${conversationsWithMyLastMessage.length}',
                    style: TextStyle(
                      color: Color(0xFF06D6A0),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllMessages() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 20),
      children: [
        if (pinnedConversations.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFEC407A).withOpacity(0.2), Color(0xFFF06292).withOpacity(0.2)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.push_pin_rounded, color: Color(0xFFEC407A), size: 18),
                ),
                SizedBox(width: 12),
                Text(
                  'Épinglés',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFEC407A),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          ...pinnedConversations.map((c) => ConversationCard(
                conversation: c,
                onTap: () => _openChatWithConversation(conversations.indexOf(c)),
              )).toList(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Row(
              children: [
                Expanded(child: Divider(color: Color(0xFFE8EAED), thickness: 1.5)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Tous les messages',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9E9E9E),
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Color(0xFFE8EAED), thickness: 1.5)),
              ],
            ),
          ),
        ],
        ...unpinnedConversations.map((c) => ConversationCard(
              conversation: c,
              onTap: () => _openChatWithConversation(conversations.indexOf(c)),
            )).toList(),
      ],
    );
  }

  Widget _buildUnreadMessages() {
    final unread = conversations.where((c) => c.unread > 0).toList();
    if (unread.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFEC407A).withOpacity(0.2), Color(0xFFF06292).withOpacity(0.2)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFEC407A).withOpacity(0.25),
                      blurRadius: 25,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Icon(Icons.mark_chat_read_rounded, size: 80, color: Color(0xFFEC407A)),
              ),
              SizedBox(height: 32),
              Text(
                'Aucun message non lu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Vous êtes à jour!',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 20),
      children: unread.map((c) => ConversationCard(
            conversation: c,
            onTap: () => _openChatWithConversation(conversations.indexOf(c)),
          )).toList(),
    );
  }

  Widget _buildArchivedMessages() {
    final myMessages = conversationsWithMyLastMessage;
    if (myMessages.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF06D6A0).withOpacity(0.2), Color(0xFF4ACFB0).withOpacity(0.2)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF06D6A0).withOpacity(0.25),
                      blurRadius: 25,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Icon(Icons.send_rounded, size: 80, color: Color(0xFF06D6A0)),
              ),
              SizedBox(height: 32),
              Text(
                'Aucun message envoyé',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Les messages que vous envoyez apparaitront ici',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _showNewMessageDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF06D6A0),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  'Envoyer un message',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: -0.3),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 20),
      children: myMessages.map((c) => ConversationCard(
            conversation: c,
            onTap: () => _openChatWithConversation(conversations.indexOf(c)),
          )).toList(),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(top: 24, left: 24, right: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: Offset(0, -10),
                spreadRadius: -5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Color(0xFFE8EAED),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 28),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFEC407A).withOpacity(0.2), Color(0xFFF06292).withOpacity(0.2)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.mark_chat_read_rounded, color: Color(0xFFEC407A), size: 24),
                ),
                title: Text(
                  'Marquer tout comme lu',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, letterSpacing: -0.3),
                ),
                onTap: () {
                  setState(() {
                    for (var c in conversations) c.unread = 0;
                  });
                  ChatStorage.saveConversations(conversations);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tous les messages marqués comme lus'),
                      backgroundColor: Color(0xFF06D6A0),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF06D6A0).withOpacity(0.2), Color(0xFF4ACFB0).withOpacity(0.2)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.send_rounded, color: Color(0xFF06D6A0), size: 24),
                ),
                title: Text(
                  'Mes envois',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, letterSpacing: -0.3),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _tabController.animateTo(2);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}