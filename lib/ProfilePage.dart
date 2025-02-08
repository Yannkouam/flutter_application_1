import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  // Contrôleurs pour les champs de saisie
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  // 🔹 Fonction de création de compte
  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Créer un utilisateur avec l'email et le mot de passe
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Compte créé avec succès !")),
      );
      setState(() {
        _user = userCredential.user;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de création de compte : $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 🔹 Fonction de connexion
  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      setState(() {
        _user = userCredential.user;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de connexion : $e")),
      );
    }
  }

  // 🔹 Fonction de déconnexion
  Future<void> _signOut() async {
    await _auth.signOut();
    setState(() {
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon compte'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 20),
              _user == null ? _buildLoginForm() : _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Bloc : Photo de profil avec initiale du nom
  Widget _buildProfileHeader() {
    String initiale = "?";
    if (_user?.email != null && _user!.email!.isNotEmpty) {
      initiale = _user!.email![0].toUpperCase();
    }

    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: null, // Pas d'image pour l'instant
            child: Text(
              initiale,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // 🔹 Formulaire de connexion
  Widget _buildLoginForm() {
    return Column(
      children: [
        _buildEditableField(
            label: 'Email', icon: Icons.email, controller: _emailController),
        _buildEditableField(
            label: 'Mot de passe',
            icon: Icons.lock,
            controller: _passwordController,
            isPassword: true),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _signIn,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white),
          child: const Text('Se connecter'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _showSignUpDialog(context);
          },
          child: const Text("Créer un compte"),
        ),
      ],
    );
  }

  // 🔹 Champ de texte avec option mot de passe
  Widget _buildEditableField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }

  // 🔹 Bouton de déconnexion et affichage du nom en gras
  Widget _buildLogoutButton() {
    String username = "Utilisateur inconnu";
    if (_user?.email != null) {
      username = _user!.email!
          .split(RegExp(r'[.@]'))[0]; // Récupère la première partie
    }

    return Center(
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              text: "Bienvenue ",
              children: [
                TextSpan(
                  text: username,
                  style:
                      const TextStyle(fontWeight: FontWeight.bold), // En gras
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _signOut,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }

  // 🔹 Affichage du formulaire de création de compte
  void _showSignUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Créer un compte'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditableField(
                  label: 'Email',
                  icon: Icons.email,
                  controller: _emailController),
              _buildEditableField(
                  label: 'Mot de passe',
                  icon: Icons.lock,
                  controller: _passwordController,
                  isPassword: true),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer le dialog
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer le dialog
                _signUp();
              },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Créer'),
            ),
          ],
        );
      },
    );
  }
}
