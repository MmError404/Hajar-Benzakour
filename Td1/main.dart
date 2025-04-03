import 'Produit.dart';
import 'commande.dart';
void main() {
  //  Tester la classe Produit
  var produit1 = Produit("iPhone 14", 13000, 10, "Phone");
  var produit2 = Produit("Dell XPS", 14000, 5, "Laptop");
  produit1.afficherDetails();
  produit2.afficherDetails();

  // 🛒 Créer une commande et ajouter des produits
  var commande = Commande(1);
  try {
    commande.ajouterProduit(produit1, 2);
    commande.ajouterProduit(produit2, 1);
    commande.afficherCommande();
  } catch (e) {
    print(e);
  }

  // Tester la recherche d'un produit
  print("Recherche produit : ${rechercherProduitParNom('MacBook Air')?.nom}");

  //  Tester le filtrage des produits chers
  print("Produits chers: ${filtrerProduitsChers().map((p) => p.nom).join(', ')}");

  //  Trouver le produit le plus cher
  print("Produit le plus cher: ${trouverProduitLePlusCher().nom}");

  //  Appliquer une remise de 10% sur les Phones
  appliquerRemisePhones();
  print("Prix après remise: ${produits.map((p) => "${p.nom}: ${p.prix} DH").join(', ')}");

  //  Transformer les prix (ex: augmenter de 5%)
  transformerPrix((prix) => prix * 1.05);
  print("Prix après augmentation: ${produits.map((p) => "${p.nom}: ${p.prix} DH").join(', ')}");
}



















