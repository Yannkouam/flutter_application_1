import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Données fictives pour les messages
    final List<Map<String, dynamic>> messages = [
      {
        'sender': 'Alice',
        'lastMessage': 'Bonjour, est-ce encore disponible ?',
        'time': '12:30',
      },
      {
        'sender': 'Bob',
        'lastMessage': 'Merci pour la réponse !',
        'time': '10:15',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return Card(
              margin: EdgeInsets.only(bottom: screenWidth * 0.03),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(message['sender'][0]),
                ),
                title: Text(message['sender']),
                subtitle: Text(message['lastMessage']),
                trailing: Text(message['time']),
                onTap: () {
                  // Logique pour ouvrir la conversation
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
