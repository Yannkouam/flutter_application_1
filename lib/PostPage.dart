import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import pour choisir une image
import 'dart:io'; // Pour utiliser File

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes annonces'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bloc pour déposer une nouvelle annonce
            Card(
              color: Colors.orange[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading:
                    const Icon(Icons.add_box, size: 40, color: Colors.orange),
                title: const Text(
                  'Créer une nouvelle annonce',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Ajoutez votre annonce ici.'),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.orange),
                onTap: () {
                  // Logique pour aller à la page de création d'annonce
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreatePostPage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Bloc pour les annonces en cours
            const Text(
              'Vos annonces en cours',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount:
                    3, // Exemple avec 3 annonces, remplacez par votre liste dynamique
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                      title: Text('Annonce ${index + 1}'),
                      subtitle: const Text('Statut : En cours'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          // Logique pour éditer l'annonce
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Page de création d'annonce avec sélection de catégorie et photo
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final List<String> categories = [
    'Vêtements',
    'Électronique',
    'Mobilier',
    'Sports',
    'Jouets'
  ];
  String selectedCategory = 'Vêtements'; // Valeur par défaut
  File? _image; // Variable pour stocker l'image choisie

  // Méthode pour choisir une image depuis la galerie
  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Stocke le chemin de l'image
      });
    }
  }

  // Méthode pour prendre une photo avec la caméra
  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Stocke le chemin de l'image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une annonce'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Champ de sélection de catégorie
            const Text(
              'Choisir une catégorie',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Champ pour le titre de l'annonce
            const Text(
              'Titre de l\'annonce',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Entrez le titre de votre annonce',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Champ pour la description de l'annonce
            const Text(
              'Description de l\'annonce',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Entrez la description de votre annonce',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),

            // Boutons pour choisir ou prendre une photo
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: Icon(Icons.photo_library),
                  label: Text('Galerie'),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _pickImageFromCamera,
                  icon: Icon(Icons.camera_alt),
                  label: Text('Caméra'),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Affichage de l'image choisie ou prise
            _image != null
                ? Image.file(
                    _image!,
                    height: 100,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Center(
                      child: Text('Aucune image sélectionnée'),
                    ),
                  ),
            SizedBox(height: 10),

            // Bouton pour publier l'annonce
            ElevatedButton(
              onPressed: () {
                // Logique pour publier l'annonce
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Annonce publiée dans la catégorie $selectedCategory')),
                );
              },
              child: const Text('Publier l\'annonce'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PostPage(),
  ));
}
