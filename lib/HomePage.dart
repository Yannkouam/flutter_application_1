import 'package:flutter/material.dart';

// 1. Page principale affichant les annonces
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Liste des annonces (sous forme de données simulées)
  List<Map<String, dynamic>> annonces = [
    {
      'title': 'Sofa en cuir',
      'price': 500.0,
      'description': 'Sofa en cuir noir, utilisé mais en bon état.',
      'status': 'Occasion',
      'author': 'Jean Dupont',
      'date': '12/01/2025',
      'likes': 10,
      'dislikes': 1,
      'image': 'assets/sofa.jpg',
    },
    {
      'title': 'Table en bois',
      'price': 150.0,
      'description': 'Table en bois massif, très bon état.',
      'status': 'Neuf',
      'author': 'Marie Durand',
      'date': '14/01/2025',
      'likes': 20,
      'dislikes': 2,
      'image': 'assets/table.jpg',
    },
  ];

  // Variable pour afficher les détails d'une annonce
  Map<String, dynamic>? selectedAnnonce;

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
              title: Text("Accueil"),
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    // Logique de publication d'une nouvelle annonce
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
          ? Padding(
              padding: EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 4 / 3,
                ),
                itemCount: annonces.length,
                itemBuilder: (context, index) {
                  var annonce = annonces[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAnnonce = annonce;
                      });
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[300],
                                  image: DecorationImage(
                                    image: AssetImage(annonce['image']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              annonce['title'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Prix : ${annonce['price']}€",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        selectedAnnonce!['image'],
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      selectedAnnonce!['title'],
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Prix : ${selectedAnnonce!['price']}€',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Description :',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      selectedAnnonce!['description'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Statut : ${selectedAnnonce!['status']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Publié par : ${selectedAnnonce!['author']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Date de publication : ${selectedAnnonce!['date']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up, color: Colors.blue),
                          onPressed: _likeAnnonce,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${selectedAnnonce!['likes']} Likes',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 16),
                        IconButton(
                          icon: Icon(Icons.thumb_down, color: Colors.red),
                          onPressed: _dislikeAnnonce,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${selectedAnnonce!['dislikes']} Dislikes',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Logique de réservation
                      },
                      child: Text(
                        "Réserver",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
