import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar circulaire
              CircleAvatar(
                radius: screenWidth * 0.15,
                /*backgroundImage: NetworkImage(
                  'https://example.com/profile_picture.jpg', // Exemple
                ),*/
                child: const Icon(Icons.person, size: 50),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Informations utilisateur
              Text(
                'Nom Utilisateur',
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'email@example.com',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              const Divider(),
              SizedBox(height: screenHeight * 0.02),
              // Liste des options
              ListTile(
                leading: Icon(Icons.edit, size: screenWidth * 0.08),
                title: Text('Modifier le profil', style: TextStyle(fontSize: screenWidth * 0.045)),
                onTap: () {
                  // Logique pour modifier le profil
                },
              ),
              ListTile(
                leading: Icon(Icons.lock, size: screenWidth * 0.08),
                title: Text('Changer le mot de passe', style: TextStyle(fontSize: screenWidth * 0.045)),
                onTap: () {
                  // Logique pour changer le mot de passe
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, size: screenWidth * 0.08),
                title: Text('Déconnexion', style: TextStyle(fontSize: screenWidth * 0.045)),
                onTap: () {
                  // Logique pour la déconnexion
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
