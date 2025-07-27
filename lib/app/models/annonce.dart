import 'user.dart';
import 'photo.dart';

enum TypeLogement { VILLA, MAISON, APPARTEMENT, STUDIO, CHAMBRE }

class Annonce {
  final int id;
  final String titre;
  final String description;
  final double prix;
  final String modalitesPaiement;
  final TypeLogement typeLogement;
  final String region;
  final String commune;
  final String adresse;
  final int nombreChambres;
  final int vues;
  final User proprietaire;
  final List<Photo> photos;
  final DateTime createdAt;
  final DateTime updatedAt;

  Annonce({
    required this.id,
    required this.titre,
    required this.description,
    required this.prix,
    required this.modalitesPaiement,
    required this.typeLogement,
    required this.region,
    required this.commune,
    required this.adresse,
    required this.nombreChambres,
    required this.vues,
    required this.proprietaire,
    required this.photos,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Annonce.fromJson(Map<String, dynamic> json) {
    return Annonce(
      id: json['id'] as int,
      titre: json['titre'] as String,
      description: json['description'] as String,
      prix: (json['prix'] as num).toDouble(),
      modalitesPaiement: json['modalitesPaiement'] as String,
      typeLogement: TypeLogement.values.firstWhere(
        (e) => e.toString().split('.').last == json['typeLogement'],
        orElse: () => TypeLogement.APPARTEMENT,
      ),
      region: json['region'] as String,
      commune: json['commune'] as String,
      adresse: json['adresse'] as String,
      nombreChambres: json['nombreChambres'] as int,
      vues: json['vues'] as int,
      proprietaire: User.fromJson(json['proprietaire'] as Map<String, dynamic>),
      photos:
          (json['photos'] as List<dynamic>)
              .map((photo) => Photo.fromJson(photo as Map<String, dynamic>))
              .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'prix': prix,
      'modalitesPaiement': modalitesPaiement,
      'typeLogement': typeLogement.toString().split('.').last,
      'region': region,
      'commune': commune,
      'adresse': adresse,
      'nombreChambres': nombreChambres,
      'vues': vues,
      'proprietaire': proprietaire.toJson(),
      'photos': photos.map((photo) => photo.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get typeLogementDisplay {
    switch (typeLogement) {
      case TypeLogement.VILLA:
        return 'Villa';
      case TypeLogement.MAISON:
        return 'Maison';
      case TypeLogement.APPARTEMENT:
        return 'Appartement';
      case TypeLogement.STUDIO:
        return 'Studio';
      case TypeLogement.CHAMBRE:
        return 'Chambre';
    }
  }

  String get prixFormate {
    return '${prix.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')} FCFA';
  }

  String get formattedPrice => prixFormate;

  String get adresseComplete => '$adresse, $commune, $region';

  String get mainPhotoUrl => photos.isNotEmpty ? photos.first.url : '';

  Annonce copyWith({
    int? id,
    String? titre,
    String? description,
    double? prix,
    String? modalitesPaiement,
    TypeLogement? typeLogement,
    String? region,
    String? commune,
    String? adresse,
    int? nombreChambres,
    int? vues,
    User? proprietaire,
    List<Photo>? photos,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Annonce(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      description: description ?? this.description,
      prix: prix ?? this.prix,
      modalitesPaiement: modalitesPaiement ?? this.modalitesPaiement,
      typeLogement: typeLogement ?? this.typeLogement,
      region: region ?? this.region,
      commune: commune ?? this.commune,
      adresse: adresse ?? this.adresse,
      nombreChambres: nombreChambres ?? this.nombreChambres,
      vues: vues ?? this.vues,
      proprietaire: proprietaire ?? this.proprietaire,
      photos: photos ?? this.photos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Annonce{id: $id, titre: $titre, prix: $prixFormate, typeLogement: $typeLogementDisplay}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Annonce && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
