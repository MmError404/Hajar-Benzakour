import 'Produit.dart';
class Commande {
  int id;
  Map<Produit, int> produits = {}; //produit et quantite
  double total = 0.0;

  Commande(this.id);//constructeur

  void ajouterProduit(Produit produit, int quantite) {
    if(produit.stock >= quantite) {
      produit.stock -= quantite;
      produits[produit] = (produits[produit] ?? 0) + quantite;
      calculerTotal();
    } else {
      throw StockInsuffisantException("Stock insuffisant pour ${produit.nom}");
    }
  }

  void calculerTotal() {
    produits.forEach((produit, quantite) => total += quantite * produit.prix);
  }

  void afficherCommande() {
    if(!produits.isEmpty) {
      print("Commande ID: $id, Total: $total DH");
      produits.forEach((produit, quantite) {
        print(" ${produit.nom} x $quantite = ${produit.prix * quantite} DH");
      });
    } else {
      throw CommandeVideException("La commande est vide");
    }
  }
}
class StockInsuffisantException implements Exception {
  final String message;
  StockInsuffisantException(this.message);
  @override
  String toString() => "Erreur: $message";
}

class CommandeVideException implements Exception {
  final String message;
  CommandeVideException(this.message);
  @override
  String toString() => "Erreur: $message";
}

// Liste globale des produits
List<Produit> produits = [
  Produit("iPhone 13", 12000, 5, "Phone"),
  Produit("MacBook Air", 15000, 3, "Laptop"),
  Produit("Samsung Galaxy S22", 11000, 4, "Phone"),
  Produit("HP Pavilion", 8000, 2, "Laptop"),
];

// 🔍 Trouver un produit par nom
Produit? rechercherProduitParNom(String nom) {
  return produits.firstWhere((produit) => produit.nom == nom, orElse: () => Produit("Inconnu", 0, 0, "N/A"));
}

//  Afficher les produits commandés avec map()
void afficherProduitsCommandes(Commande commande) {
  var listeFormatee = commande.produits.entries.map((entry) => "${entry.key.nom} x${entry.value}");
  print("Produits commandés: ${listeFormatee.join(', ')}");
}

//  Filtrer les produits à plus de 50 DH avec filter()
List<Produit> filtrerProduitsChers() {
  return produits.where((produit) => produit.prix > 50).toList();
}

//  Trouver le produit le plus cher avec reduce()
Produit trouverProduitLePlusCher() {
  return produits.reduce((a, b) => a.prix > b.prix ? a : b);
}

//  Appliquer une remise de 10% sur les produits de la catégorie "Phone"
void appliquerRemisePhones() {
  produits.where((produit) => produit.categorie == "Phone").forEach((produit) {
    produit.prix *= 0.9;
  });
}

//  Transformation des prix avec une fonction de haut niveau
void transformerPrix(double Function(double) transformation) {
  produits.forEach((produit) {
    produit.prix = transformation(produit.prix);
  });
}