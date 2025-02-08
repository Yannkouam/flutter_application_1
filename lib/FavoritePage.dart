import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteAnnonces;

  const FavoritePage({Key? key, required this.favoriteAnnonces})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Favoris'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: favoriteAnnonces.isEmpty
          ? Center(
              child: Text(
                "Aucun favori ajouté",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: favoriteAnnonces.length,
              itemBuilder: (context, index) {
                var annonce = favoriteAnnonces[index];

                return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        annonce['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      annonce['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Prix : ${annonce['price']}€',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        // Logique pour supprimer de la liste des favoris
                      },
                    ),
                    onTap: () {
                      // Logique si on veut voir les détails de l'annonce (par exemple, navigation vers une page de détail)
                    },
                  ),
                );
              },
            ),
    );
  }
}
