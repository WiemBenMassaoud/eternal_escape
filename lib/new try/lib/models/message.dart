import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 10)
class Message extends HiveObject {
  @HiveField(0)
  String text;

  @HiveField(1)
  bool isSent;

  @HiveField(2)
  DateTime time;

  @HiveField(3)
  bool isRead;

  Message({
    required this.text,
    required this.isSent,
    required this.time,
    required this.isRead,
  });

  @override
  String toString() => 'Message(text: $text, isSent: $isSent, time: $time, isRead: $isRead)';
}