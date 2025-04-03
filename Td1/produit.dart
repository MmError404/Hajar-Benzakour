class Produit {
  // Attributs
  String nom;
  double prix;
  int stock;
  String categorie;

  // Constructeur
  Produit(this.nom, this.prix, this.stock, this.categorie);

  // Méthode pour afficher les détails du produit
  void afficherDetails() {
    print("Produit : $nom\nPrix : \$${prix.toStringAsFixed(2)}\nStock disponible : $stock\nCatégorie : $categorie");
  }
}