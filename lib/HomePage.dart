import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = ''; // Variable pour stocker le texte de la recherche
  TextEditingController searchController =
      TextEditingController(); // Contrôleur pour le TextField
  Map<String, dynamic>?
      selectedAnnonce; // Variable pour afficher les détails de l'annonce

  void _likeAnnonce() {
    setState(() {
      selectedAnnonce!['likes'] += 1;
    });
  }

  void _dislikeAnnonce() {
    setState(() {
      selectedAnnonce!['dislikes'] += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: selectedAnnonce == null
          ? AppBar(
              title: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white60),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    searchQuery =
                        value.toLowerCase(); // Mettre à jour la recherche
                  });
                },
              ),
              centerTitle: true,
              backgroundColor: Colors.blueAccent,
              actions: [
                if (searchQuery.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        searchQuery = ''; // Effacer la recherche
                        searchController
                            .clear(); // Effacer le texte dans le champ de recherche
                      });
                    },
                  ),
              ],
            )
          : AppBar(
              title: Text("Détail de l'annonce"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedAnnonce = null; // Retourner à la liste des annonces
                  });
                },
              ),
            ),
      body: selectedAnnonce == null
          ? StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('Annonce').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                // 🟡 Affichage du loader si les données sont en chargement
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // 🔴 Vérification si aucune donnée n'est trouvée
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("Aucune publication trouvée"));
                }

                // ✅ Filtrer les publications en fonction de la recherche
                var filteredDocs = snapshot.data!.docs.where((doc) {
                  var titre = doc['Titre']?.toLowerCase() ?? '';
                  var categorie = doc['catégorie']?.toLowerCase() ?? '';
                  return titre.contains(searchQuery) ||
                      categorie.contains(searchQuery);
                }).toList();

                // ✅ Affichage des publications sous forme de blocs dans un GridView
                return GridView.builder(
                  padding: EdgeInsets.all(10.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Nombre de colonnes
                    crossAxisSpacing: 10.0, // Espacement entre les blocs
                    mainAxisSpacing:
                        10.0, // Espacement entre les blocs en verticale
                    childAspectRatio:
                        4 / 3, // Rapport largeur/hauteur = 1, bloc carré
                  ),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    var doc = filteredDocs[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAnnonce = doc.data() as Map<String, dynamic>;
                        });
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: doc['image'] != null &&
                                      doc['image'].toString().isNotEmpty
                                  ? Image.network(
                                      doc['image'],
                                      width: double.infinity,
                                      height: 150, // Taille de l'image réduite
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          Icon(Icons.broken_image, size: 50),
                                    )
                                  : Icon(Icons.image_not_supported, size: 50),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                doc['Titre'] ?? 'Sans titre',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "${doc['catégorie'] ?? 'Inconnu'} - ${doc['prix'] ?? 0} €",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: selectedAnnonce!['image'] != null &&
                            selectedAnnonce!['image'].toString().isNotEmpty
                        ? Image.network(
                            selectedAnnonce!['image'],
                            width: double.infinity,
                            height: 200, // Taille de l'image réduite
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.broken_image, size: 50),
                          )
                        : Icon(Icons.image_not_supported, size: 50),
                  ),
                  SizedBox(height: 10),
                  Text(
                    selectedAnnonce!['Titre'] ?? 'Sans titre',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Catégorie : ${selectedAnnonce!['catégorie'] ?? 'Inconnue'}",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Prix : ${selectedAnnonce!['prix']} €",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.thumb_up),
                        onPressed: _likeAnnonce,
                      ),
                      Text('${selectedAnnonce!['likes'] ?? 0} Likes'),
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(Icons.thumb_down),
                        onPressed: _dislikeAnnonce,
                      ),
                      Text('${selectedAnnonce!['dislikes'] ?? 0} Dislikes'),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
