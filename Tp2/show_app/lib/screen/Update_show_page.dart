import 'dart:convert'; // Pour convertir les données JSON
import 'dart:io'; // Pour gérer les fichiers, si vous gérez des images
import 'package:flutter/material.dart'; // Pour la création de l'interface utilisateur
import 'package:http/http.dart' as http; // Pour envoyer les requêtes HTTP

class UpdateShowPage extends StatefulWidget {
  // Les informations du show que nous voulons modifier
  final int showId;
  final String title;
  final String description;
  final String category;
  final String image;

  // Constructeur pour initialiser les valeurs du show
  const UpdateShowPage({
    super.key,
    required this.showId,
    required this.title,
    required this.description,
    required this.category,
    required this.image,
  });

  @override
  _UpdateShowPageState createState() => _UpdateShowPageState();
}

class _UpdateShowPageState extends State<UpdateShowPage> {
  // Contrôleurs pour chaque champ de texte
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'movie';  // Catégorie sélectionnée
  File? _imageFile;  // Fichier image à télécharger (si nécessaire)

  @override
  void initState() {
    super.initState();
    // Pré-remplir les champs avec les données existantes du show
    _titleController.text = widget.title;
    _descriptionController.text = widget.description;
    _selectedCategory = widget.category;
  }

  // Fonction pour envoyer les données mises à jour au backend
  Future<void> _updateShow() async {
    var response = await http.put(
      Uri.parse('http://10.0.2.2:5000/shows/${widget.showId}'),
      body: {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'category': _selectedCategory,
        // Ajoutez ici la gestion de l'image si nécessaire
      },
    );

    if (response.statusCode == 200) {
      // Si la mise à jour a réussi, revenir à la page d'accueil
      Navigator.pop(context, true);
    } else {
      // Afficher un message d'erreur si la mise à jour échoue
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to update show")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Show")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ pour le titre du show
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Title")),
            // Champ pour la description du show
            TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: "Description")),
            // Menu déroulant pour la catégorie du show
            DropdownButton<String>(
              value: _selectedCategory,
              items: const ['movie', 'anime', 'serie'].map((category) {
                return DropdownMenuItem<String>(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) => setState(() => _selectedCategory = value!),
            ),
            // Bouton pour soumettre la mise à jour
            ElevatedButton(
              onPressed: _updateShow,
              child: const Text("Update Show"),
            ),
          ],
        ),
      ),
    );
  }
}
