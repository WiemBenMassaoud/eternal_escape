import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'conversation.g.dart';

@HiveType(typeId: 1)
class Conversation extends HiveObject {
  @HiveField(0)
  String name;

  // store color as int for persistence
  @HiveField(1)
  int avatarColorValue;

  @HiveField(2)
  bool isOnline;

  @HiveField(3)
  bool isPinned;

  @HiveField(4)
  bool notificationsEnabled;

  @HiveField(5)
  bool lastMessageFromMe;

  @HiveField(6)
  String lastMessage;

  @HiveField(7)
  String time;

  @HiveField(8)
  int unread;

  Conversation({
    required this.name,
    required this.avatarColorValue,
    this.isOnline = false,
    this.isPinned = false,
    this.notificationsEnabled = true,
    this.lastMessageFromMe = false,
    this.lastMessage = '',
    this.time = '',
    this.unread = 0,
  });

  Color get avatarColor => Color(avatarColorValue);
}