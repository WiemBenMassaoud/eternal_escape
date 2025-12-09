import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Messages")),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: 5, // Exemple fixe
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text("Utilisateur $index"),
              subtitle: Text("Bonjour, je voudrais réserver un logement."),
              trailing: Icon(Icons.message),
            ),
          );
        },
      ),
    );
  }
}
