import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:show_app/config/api_config.dart';
import 'package:show_app/screens/add_show_page.dart';
import 'package:show_app/screens/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<dynamic> movies = [];
  List<dynamic> anime = [];
  List<dynamic> series = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchShows(); // Charger les shows au démarrage
  }
  Future<void> refreshShows() async {
    await fetchShows();
    setState(() {}); // Mise à jour de l'UI
  }

  // Fonction pour récupérer les shows depuis le backend
  Future<void> fetchShows() async {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/shows'));

    if (response.statusCode == 200) {
      List<dynamic> allShows = jsonDecode(response.body);

      setState(() {
        movies = allShows.where((show) => show['category'] == 'movie').toList();
        anime = allShows.where((show) => show['category'] == 'anime').toList();
        series = allShows.where((show) => show['category'] == 'serie').toList();
        isLoading = false; // Fin du chargement
      });
    } else {
      setState(() => isLoading = false);
      throw Exception('Failed to load shows');
    }
  }

  // Fonction pour supprimer un show
  Future<void> deleteShow(int id) async {
    final response = await http.delete(Uri.parse('${ApiConfig.baseUrl}/shows/$id'));

    if (response.statusCode == 200) {
      fetchShows(); // Rafraîchir la liste après suppression
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete show")),
      );
    }
  }

  // Fonction de confirmation avant suppression
  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Show"),
        content: const Text("Are you sure you want to delete this show?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteShow(id); // Suppression du show
            },
            child: const Text("Yes, Delete"),
          ),
        ],
      ),
    );
  }

  // Fonction pour obtenir le contenu du body selon l'onglet sélectionné
  Widget _getBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator()); // Indicateur de chargement
    }

    switch (_selectedIndex) {
      case 0:
        return ShowList(shows: movies, onDelete: confirmDelete);
      case 1:
        return ShowList(shows: anime, onDelete: confirmDelete);
      case 2:
        return ShowList(shows: series, onDelete: confirmDelete);
      default:
        return const Center(child: Text("Unknown Page"));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Show App"), backgroundColor: Colors.blueAccent),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (builder)=>ProfilePage())),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("Add Show"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (builder)=> AddShowPage())).then((_) {
                fetchShows(); // Rafraîchir la liste après un ajout
              }),
            ),
          ],
        ),
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Movies"),
          BottomNavigationBarItem(icon: Icon(Icons.animation), label: "Anime"),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: "Series"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Widget pour afficher la liste des shows
class ShowList extends StatelessWidget {
  final List<dynamic> shows;
  final Function(int) onDelete;
  final Function() refreshShows; // Fonction pour rafraîchir les données

  const ShowList({super.key, required this.shows, required this.onDelete, required this.refreshShows});

  @override
  Widget build(BuildContext context) {
    if (shows.isEmpty) {
      return const Center(child: Text("No Shows Available"));
    }

    return ListView.builder(
      itemCount: shows.length,
      itemBuilder: (context, index) {
        final show = shows[index];
        return Dismissible(
          key: Key(show['id'].toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerRight,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) => onDelete(show['id']),
          confirmDismiss: (direction) => onDelete(show['id']),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Image.network(
                ApiConfig.baseUrl + show['image'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
              ),
              title: Text(show['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(show['description']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Bouton Modifier
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateShowPage(show: show),
                        ),
                      ).then((_) => refreshShows()); // Rafraîchir après modification
                    },
                  ),
                  // Bouton Supprimer
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => onDelete(show['id']),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
