import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: PostPage(),
  ));
}

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final List<Map<String, dynamic>> annonces = [];

  @override
  void initState() {
    super.initState();
    _loadAnnonces();
  }

  // Charger les annonces depuis SharedPreferences
  void _loadAnnonces() async {
    final prefs = await SharedPreferences.getInstance();
    final String? annoncesJson = prefs.getString('annonces');
    if (annoncesJson != null) {
      final List<dynamic> decodedAnnonces = json.decode(annoncesJson);
      setState(() {
        annonces.clear();
        annonces
            .addAll(decodedAnnonces.map((e) => Map<String, dynamic>.from(e)));
      });
    }
  }

  // Sauvegarder les annonces dans SharedPreferences
  void _saveAnnonces() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('annonces', json.encode(annonces));
  }

  // Ajouter une annonce
  void ajouterAnnonce(Map<String, dynamic> annonce) {
    setState(() {
      annonces.add(annonce);
    });
    _saveAnnonces();
  }

  // Supprimer une annonce
  void supprimerAnnonce(int index) {
    setState(() {
      annonces.removeAt(index);
    });
    _saveAnnonces();
  }

  // Modifier une annonce
  void modifierAnnonce(int index, Map<String, dynamic> annonce) {
    setState(() {
      annonces[index] = annonce;
    });
    _saveAnnonces();
  }

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreatePostPage(onPostCreated: ajouterAnnonce),
                    ),
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
              child: annonces.isEmpty
                  ? const Center(child: Text("Aucune annonce en cours."))
                  : ListView.builder(
                      itemCount: annonces.length,
                      itemBuilder: (context, index) {
                        final annonce = annonces[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: annonce['image'] != null
                                ? Image.file(
                                    annonce['image'],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.image,
                                        color: Colors.grey),
                                  ),
                            title: Text(annonce['titre']),
                            subtitle: Text(
                                'Prix: ${annonce['prix']}€ • État: ${annonce['etat']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Icône stylo pour modifier l'annonce
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CreatePostPage(
                                          onPostCreated: (modifiedAnnonce) {
                                            modifierAnnonce(
                                                index, modifiedAnnonce);
                                          },
                                          annonce:
                                              annonce, // Passer les données de l'annonce à modifier
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // Icône poubelle pour supprimer l'annonce
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    supprimerAnnonce(index);
                                  },
                                ),
                              ],
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

class CreatePostPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onPostCreated;
  final Map<String, dynamic>? annonce;

  const CreatePostPage({super.key, required this.onPostCreated, this.annonce});

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
  final List<String> etats = ['Neuf', 'Bon état', 'Usé'];
  String selectedCategory = 'Vêtements';
  String selectedEtat = 'Neuf';
  File? _image;
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.annonce != null) {
      _titreController.text = widget.annonce!['titre'] ?? '';
      _descriptionController.text = widget.annonce!['description'] ?? '';
      _prixController.text = widget.annonce!['prix']?.toString() ?? '';
      selectedCategory = widget.annonce!['categorie'] ?? 'Vêtements';
      selectedEtat = widget.annonce!['etat'] ?? 'Neuf';
      _image = widget.annonce!['image'];
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: source, maxWidth: 150, maxHeight: 150);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _publierAnnonce() {
    if (_titreController.text.isEmpty || _prixController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    widget.onPostCreated({
      'titre': _titreController.text,
      'description': _descriptionController.text,
      'prix': _prixController.text,
      'categorie': selectedCategory,
      'etat': selectedEtat,
      'image': _image,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer ou modifier une annonce'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Catégorie',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                        },
                        items: categories
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('État',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<String>(
                        value: selectedEtat,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedEtat = newValue!;
                          });
                        },
                        items:
                            etats.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Titre de l\'annonce',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
                controller: _titreController,
                decoration:
                    const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 20),
            const Text('Prix (€)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
                controller: _prixController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 20),
            const Text('Description',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration:
                    const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 20),
            const Text('Image (aperçu)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            _image != null
                ? Image.file(_image!,
                    width: 100, height: 100, fit: BoxFit.cover)
                : Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, color: Colors.grey)),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galerie'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Caméra'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _publierAnnonce,
              child: Text(
                widget.annonce == null
                    ? 'Publier l\'annonce'
                    : 'Modifier l\'annonce',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
