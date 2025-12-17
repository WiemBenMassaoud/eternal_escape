import 'package:flutter/material.dart';
import '../models/conversation.dart';

typedef ConversationTap = void Function();

class ConversationCard extends StatelessWidget {
  final Conversation conversation;
  final ConversationTap? onTap;
  final VoidCallback? onLongPress;
  const ConversationCard({Key? key, required this.conversation, this.onTap, this.onLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPinned = conversation.isPinned;
    final notificationsEnabled = conversation.notificationsEnabled;
    final lastMessageFromMe = conversation.lastMessageFromMe;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPinned ? Color(0xFF6C63FF).withOpacity(0.2) : Color(0xFFE8EAED),
            width: 1.5,
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(children: [
            Stack(children: [
              Hero(
                tag: 'avatar_${conversation.name}',
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [conversation.avatarColor, conversation.avatarColor.withOpacity(0.7)]),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: conversation.avatarColor.withOpacity(0.3), blurRadius: 8, offset: Offset(0, 2))],
                  ),
                  child: Center(child: Text(conversation.name[0].toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700))),
                ),
              ),
              if (conversation.isOnline)
                Positioned(bottom: 0, right: 0, child: Container(width: 16, height: 16, decoration: BoxDecoration(color: Color(0xFF06D6A0), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)))),
              if (isPinned)
                Positioned(top: 0, left: 0, child: Container(padding: EdgeInsets.all(4), decoration: BoxDecoration(color: Color(0xFF6C63FF), shape: BoxShape.circle), child: Icon(Icons.push_pin_rounded, color: Colors.white, size: 12))),
              if (!notificationsEnabled)
                Positioned(top: 0, right: 0, child: Container(padding: EdgeInsets.all(4), decoration: BoxDecoration(color: Color(0xFF9E9E9E), shape: BoxShape.circle), child: Icon(Icons.notifications_off_rounded, color: Colors.white, size: 12))),
              if (lastMessageFromMe)
                Positioned(bottom: 0, left: 0, child: Container(padding: EdgeInsets.all(4), decoration: BoxDecoration(color: Color(0xFF06D6A0), shape: BoxShape.circle), child: Icon(Icons.check_rounded, color: Colors.white, size: 12))),
            ]),
            SizedBox(width: 16),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(conversation.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)), overflow: TextOverflow.ellipsis)),
                  SizedBox(width: 8),
                  Text(conversation.time, style: TextStyle(fontSize: 12, color: conversation.unread > 0 ? Color(0xFF6C63FF) : lastMessageFromMe ? Color(0xFF06D6A0) : Color(0xFFBDBDBD), fontWeight: FontWeight.w600))
                ]),
                SizedBox(height: 6),
                Row(children: [
                  if (lastMessageFromMe) Padding(padding: EdgeInsets.only(right: 4), child: Text('Vous: ', style: TextStyle(fontSize: 14, color: Color(0xFF06D6A0), fontWeight: FontWeight.w600))),
                  Expanded(child: Text(conversation.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14, color: conversation.unread > 0 ? Color(0xFF1A1A1A) : Color(0xFF9E9E9E), fontWeight: conversation.unread > 0 || lastMessageFromMe ? FontWeight.w600 : FontWeight.w400))),
                  if (conversation.unread > 0) ...[
                    SizedBox(width: 12),
                    Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF5B54E0)]), borderRadius: BorderRadius.circular(10)), child: Text('${conversation.unread}', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))),
                  ],
                ]),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}