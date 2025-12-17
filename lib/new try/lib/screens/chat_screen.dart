import 'package:flutter/material.dart';
import '../models/message.dart';
import '../services/chat_storage.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';
import '../utils/date_utils.dart';

class ChatScreen extends StatefulWidget {
  final String contactName;
  final Color avatarColor;
  final bool isOnline;
  final String? initialMessage;

  const ChatScreen({
    Key? key,
    required this.contactName,
    required this.avatarColor,
    required this.isOnline,
    this.initialMessage,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];
  bool isTyping = false;
  late AnimationController _fabAnimationController;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _messageController.addListener(() {
      setState(() {});
      if (_messageController.text.isNotEmpty) {
        _fabAnimationController.forward();
      } else {
        _fabAnimationController.reverse();
      }
    });
    _loadMessages();
    if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _addInitialMessage(widget.initialMessage!);
      });
    }
  }

  Future<void> _loadMessages() async {
    messages = ChatStorage.loadMessages(widget.contactName);
    if (messages.isEmpty) {
      messages = [
        Message(text: 'Bonjour ${widget.contactName}! 👋', isSent: false, time: DateTime.now().subtract(Duration(minutes: 5)), isRead: true),
        Message(text: 'Bienvenue dans la conversation!', isSent: false, time: DateTime.now().subtract(Duration(minutes: 4)), isRead: true),
      ];
      await ChatStorage.saveMessages(widget.contactName, messages);
      await ChatStorage.updateConversationLastMessage(
        contactName: widget.contactName,
        lastMessage: messages.last.text,
        time: _getCurrentTime(),
        lastMessageFromMe: messages.last.isSent,
        avatarColorValue: widget.avatarColor.value,
        isOnline: widget.isOnline,
      );
    }
    setState(() {});
    _scrollToBottom(delay: 0);
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _addInitialMessage(String messageText) async {
    final newMessage = Message(text: messageText, isSent: true, time: DateTime.now(), isRead: false);
    setState(() {
      messages.add(newMessage);
      _messageController.clear();
    });
    await ChatStorage.saveMessages(widget.contactName, messages);
    await ChatStorage.updateConversationLastMessage(
      contactName: widget.contactName,
      lastMessage: newMessage.text,
      time: _getCurrentTime(),
      lastMessageFromMe: true,
      avatarColorValue: widget.avatarColor.value,
      isOnline: widget.isOnline,
    );
    _simulateResponse();
    _scrollToBottom();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    final newMessage = Message(text: text, isSent: true, time: DateTime.now(), isRead: false);
    setState(() {
      messages.add(newMessage);
      _messageController.clear();
    });
    await ChatStorage.saveMessages(widget.contactName, messages);
    await ChatStorage.updateConversationLastMessage(
      contactName: widget.contactName,
      lastMessage: newMessage.text,
      time: _getCurrentTime(),
      lastMessageFromMe: true,
      avatarColorValue: widget.avatarColor.value,
      isOnline: widget.isOnline,
    );
    _scrollToBottom();
    _simulateResponse();
  }

  void _simulateResponse() {
    if (widget.contactName.toLowerCase().contains('support') || widget.contactName.toLowerCase().contains('client')) {
      return;
    }
    setState(() => isTyping = true);
    Future.delayed(Duration(milliseconds: 1500), () async {
      if (!mounted) return;
      final responses = [
        'Merci pour votre message!',
        'Je vous réponds dans quelques instants.',
        'Je comprends. Donnez-moi un moment pour vérifier.',
        'Excellente question! Laissez-moi vous répondre.',
        'Je note votre demande et je reviens vers vous rapidement.',
      ];
      final idx = DateTime.now().millisecond % responses.length;
      final response = Message(text: responses[idx], isSent: false, time: DateTime.now(), isRead: true);
      setState(() {
        isTyping = false;
        messages.add(response);
      });
      await ChatStorage.saveMessages(widget.contactName, messages);
      await ChatStorage.updateConversationLastMessage(
        contactName: widget.contactName,
        lastMessage: response.text,
        time: _getCurrentTime(),
        lastMessageFromMe: false,
        avatarColorValue: widget.avatarColor.value,
        isOnline: widget.isOnline,
      );
      _scrollToBottom();
    });
  }

  void _scrollToBottom({int delay = 100}) {
    Future.delayed(Duration(milliseconds: delay), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  Message? _lastSentMessage() {
    for (var i = messages.length - 1; i >= 0; i--) {
      if (messages[i].isSent) return messages[i];
    }
    return null;
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  Widget _buildDateHeaderIfNeeded(int index) {
    final message = messages[index];
    final messageTime = message.time;
    final showDate = index == 0 || formatDateHeader(messageTime) != formatDateHeader(messages[index - 1].time);
    if (!showDate) return SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6C63FF).withOpacity(0.15), Color(0xFF857BFF).withOpacity(0.15)],
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Color(0xFF6C63FF).withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF6C63FF).withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            formatDateHeader(messageTime),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF6C63FF),
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.05),
        leading: Container(
          margin: EdgeInsets.all(8),
          child: Material(
            color: Color(0xFFF8F9FF),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                final lastSent = _lastSentMessage();
                Navigator.pop(context, lastSent?.text);
              },
              child: Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF6C63FF), size: 20),
            ),
          ),
        ),
        title: Row(
          children: [
            Hero(
              tag: 'avatar_${widget.contactName}',
              child: Stack(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [widget.avatarColor, widget.avatarColor.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.avatarColor.withOpacity(0.4),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        widget.contactName[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  if (widget.isOnline)
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Color(0xFF06D6A0),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF06D6A0).withOpacity(0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contactName,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: widget.isOnline ? Color(0xFF06D6A0) : Color(0xFF9E9E9E),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        widget.isOnline ? 'En ligne' : 'Hors ligne',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: widget.isOnline ? Color(0xFF06D6A0) : Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: Material(
              color: Color(0xFFF8F9FF),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Icon(Icons.more_vert_rounded, color: Color(0xFF6C63FF), size: 22),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF6C63FF).withOpacity(0.15), Color(0xFF857BFF).withOpacity(0.15)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF6C63FF).withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(Icons.message_rounded, size: 72, color: Color(0xFF6C63FF)),
                        ),
                        SizedBox(height: 28),
                        Text(
                          'Aucun message',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Envoyez votre premier message!',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF9E9E9E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    itemCount: messages.length + (isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (isTyping && index == messages.length) {
                        return TypingIndicator();
                      }
                      final message = messages[index];
                      return Column(
                        children: [
                          _buildDateHeaderIfNeeded(index),
                          MessageBubble(message: message),
                        ],
                      );
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: Offset(0, -5),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F9FF),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: _messageController.text.isNotEmpty 
                              ? Color(0xFF6C63FF).withOpacity(0.3) 
                              : Color(0xFFE8EAED),
                          width: 1.5,
                        ),
                        boxShadow: _messageController.text.isNotEmpty
                            ? [
                                BoxShadow(
                                  color: Color(0xFF6C63FF).withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Écrivez un message...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Color(0xFFBDBDBD),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF1A1A1A),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: null,
                              textCapitalization: TextCapitalization.sentences,
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          if (_messageController.text.isNotEmpty)
                            ScaleTransition(
                              scale: _fabAnimationController,
                              child: IconButton(
                                icon: Icon(Icons.emoji_emotions_rounded, color: Color(0xFF6C63FF)),
                                onPressed: () {},
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _fabAnimationController,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF5B54E0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF6C63FF).withOpacity(0.4),
                            blurRadius: 15,
                            offset: Offset(0, 6),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send_rounded, color: Colors.white, size: 22),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}