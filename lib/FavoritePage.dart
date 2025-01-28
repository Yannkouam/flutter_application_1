import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Données fictives pour les favoris
    final List<Map<String, dynamic>> favorites = [
      {
        'title': 'Lampe de bureau',
        'price': 29.99,
        'imageUrl': 'https://via.placeholder.com/150',
        'description': 'Lampe moderne pour bureau.'
      },
      {
        'title': 'Étagère en bois',
        'price': 79.99,
        'imageUrl': 'https://via.placeholder.com/150',
        'description': 'Étagère robuste en bois massif.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final item = favorites[index];
            return Card(
              margin: EdgeInsets.only(bottom: screenHeight * 0.02),
              child: ListTile(
                leading: Image.network(item['imageUrl']),
                title: Text(item['title']),
                subtitle: Text('${item['price']} €'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Logique pour supprimer des favoris
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
