import 'package:intl/intl.dart';

String formatTime(DateTime time) {
  final now = DateTime.now();
  final diff = now.difference(time);
  if (diff.inMinutes < 1) return 'Maintenant';
  if (diff.inHours < 1) return '${diff.inMinutes} min';
  if (diff.inDays < 1) return DateFormat('HH:mm').format(time);
  if (diff.inDays < 7) {
    final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return days[time.weekday - 1];
  }
  return '${time.day}/${time.month}';
}

String formatDateHeader(DateTime time) {
  final now = DateTime.now();
  final diff = now.difference(time);
  if (diff.inDays == 0) return 'Aujourd\'hui';
  if (diff.inDays == 1) return 'Hier';
  if (diff.inDays < 7) {
    final days = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche'
    ];
    return days[time.weekday - 1];
  }
  return '${time.day}/${time.month}/${time.year}';
}