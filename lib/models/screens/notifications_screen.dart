import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(Icons.notifications, color: Colors.deepPurple),
              title: Text("Notification $index"),
              subtitle: Text("Vous avez une nouvelle réservation."),
            ),
          );
        },
      ),
    );
  }
}
