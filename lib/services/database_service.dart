import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class DatabaseService {
  String? userID, annonceID;
  DatabaseService({this.userID, this.annonceID});

  // Initialisation
  CollectionReference _annonces =
      FirebaseFirestore.instance.collection('annonces');
  FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload de l'image vers Firebase Storage
  Future<String> uploadImage(File file, XFile fileWeb) async {
    Reference reference =
        _storage.ref().child('annonces/${DateTime.now()}.png');
    Uint8List imageToSave = await fileWeb.readAsBytes();
    SettableMetadata metaData = SettableMetadata(contentType: 'image/jpeg');
    UploadTask uploadTask = kIsWeb
        ? reference.putData(imageToSave, metaData)
        : reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  // Ajouter une annonce dans la BDD
  void addAnnonce(Map<String, dynamic> annonceData) {
    _annonces.add({
      "titre": annonceData['titre'],
      "description": annonceData['description'],
      "prix": annonceData['prix'],
      "categorie": annonceData['categorie'],
      "image": annonceData['image'], // L'URL de l'image si elle existe
      "userID": annonceData['userID'],
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  // Récupérer toutes les annonces en temps réel
  Stream<List<Map<String, dynamic>>> get annonces {
    Query queryAnnonces = _annonces.orderBy('timestamp', descending: true);
    return queryAnnonces.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'annonceID': doc.id,
          'titre': doc.get('titre'),
          'description': doc.get('description'),
          'prix': doc.get('prix'),
          'categorie': doc.get('categorie'),
          'image': doc.get('image'),
          'userID': doc.get('userID'),
          'timestamp': doc.get('timestamp'),
        };
      }).toList();
    });
  }

  // Modifier une annonce
  void updateAnnonce(String annonceID, Map<String, dynamic> updatedData) {
    _annonces.doc(annonceID).update(updatedData);
  }

  // Supprimer une annonce
  Future<void> deleteAnnonce(String annonceID) =>
      _annonces.doc(annonceID).delete();

  // Récupérer une annonce spécifique
  Future<Map<String, dynamic>> getAnnonce(String annonceID) async {
    final doc = await _annonces.doc(annonceID).get();
    return {
      'annonceID': annonceID,
      'titre': doc.get('titre'),
      'description': doc.get('description'),
      'prix': doc.get('prix'),
      'categorie': doc.get('categorie'),
      'image': doc.get('image'),
      'userID': doc.get('userID'),
      'timestamp': doc.get('timestamp'),
    };
  }
}
