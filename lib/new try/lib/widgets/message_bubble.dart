import 'package:flutter/material.dart';
import '../models/message.dart';
import '../utils/date_utils.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSent = message.isSent;
    final isRead = message.isRead;
    final time = message.time;

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 12,
          left: isSent ? 60 : 0,
          right: isSent ? 0 : 60,
        ),
        child: Column(
          crossAxisAlignment:
              isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints:
                  BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSent
                    ? LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF857BFF)],
                      )
                    : null,
                color: isSent ? null : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(isSent ? 20 : 4),
                  bottomRight: Radius.circular(isSent ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isSent ? Color(0xFF6C63FF) : Colors.black).withOpacity(0.08),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isSent ? Colors.white : Color(0xFF1A1A1A),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatTime(time),
                    style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
                  ),
                  if (isSent) ...[
                    SizedBox(width: 4),
                    Icon(
                      isRead ? Icons.done_all_rounded : Icons.done_rounded,
                      size: 14,
                      color: isRead ? Color(0xFF06D6A0) : Color(0xFF9E9E9E),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}