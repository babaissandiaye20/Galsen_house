import '../../models/user.dart';
import '../../models/role.dart';
import '../../models/annonce.dart';
import '../../models/photo.dart';

class MockData {
  static final List<Role> roles = [
    Role(id: 1, name: RoleType.CLIENT),
    Role(id: 2, name: RoleType.PROPRIETAIRE),
    Role(id: 3, name: RoleType.ADMIN),
  ];

  static final List<User> users = [
    User(
      id: 1,
      prenom: 'Jean',
      nom: 'Dupont',
      region: 'Dakar',
      commune: 'Plateau',
      email: 'baba@gmail.com',
      password: 'passer',
      telephone: '+221 78 636 06 62',
      role: roles[1], // PROPRIETAIRE
      createdAt: DateTime.now().subtract(Duration(days: 30)),
      updatedAt: DateTime.now().subtract(Duration(days: 1)),
    ),
    User(
      id: 2,
      prenom: 'Marie',
      nom: 'Martin',
      region: 'Thiès',
      commune: 'Thiès Nord',
      email: 'marie.martin@email.com',
      password: 'password123',
      telephone: '+221 76 234 56 78',
      role: roles[0], // CLIENT
      createdAt: DateTime.now().subtract(Duration(days: 25)),
      updatedAt: DateTime.now().subtract(Duration(days: 2)),
    ),
    User(
      id: 3,
      prenom: 'Amadou',
      nom: 'Ba',
      region: 'Saint-Louis',
      commune: 'Saint-Louis Centre',
      email: 'amadou.ba@email.com',
      password: 'password123',
      telephone: '+221 77 345 67 89',
      role: roles[1], // PROPRIETAIRE
      createdAt: DateTime.now().subtract(Duration(days: 20)),
      updatedAt: DateTime.now().subtract(Duration(days: 3)),
    ),
    User(
      id: 4,
      prenom: 'Fatou',
      nom: 'Diop',
      region: 'Kaolack',
      commune: 'Kaolack Centre',
      email: 'fatou.diop@email.com',
      password: 'password123',
      telephone: '+221 76 456 78 90',
      role: roles[0], // CLIENT
      createdAt: DateTime.now().subtract(Duration(days: 15)),
      updatedAt: DateTime.now().subtract(Duration(days: 1)),
    ),
    User(
      id: 5,
      prenom: 'Admin',
      nom: 'System',
      region: 'Dakar',
      commune: 'Plateau',
      email: 'admin@gmail.com',
      password: 'admin',
      telephone: '+221 77 000 00 00',
      role: roles[2], // ADMIN
      createdAt: DateTime.now().subtract(Duration(days: 100)),
      updatedAt: DateTime.now(),
    ),
  ];

  static final List<Photo> photos = [
    // Photos pour annonce 1
    Photo(
      id: 1,
      url: 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800',
      annonceId: 1,
    ),
    Photo(
      id: 2,
      url: 'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800',
      annonceId: 1,
    ),
    Photo(
      id: 3,
      url: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
      annonceId: 1,
    ),

    // Photos pour annonce 2
    Photo(
      id: 4,
      url: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
      annonceId: 2,
    ),
    Photo(
      id: 5,
      url: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
      annonceId: 2,
    ),

    // Photos pour annonce 3
    Photo(
      id: 6,
      url: 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
      annonceId: 3,
    ),
    Photo(
      id: 7,
      url: 'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?w=800',
      annonceId: 3,
    ),
    Photo(
      id: 8,
      url: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800',
      annonceId: 3,
    ),

    // Photos pour annonce 4
    Photo(
      id: 9,
      url: 'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?w=800',
      annonceId: 4,
    ),
    Photo(
      id: 10,
      url: 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?w=800',
      annonceId: 4,
    ),

    // Photos pour annonce 5
    Photo(
      id: 11,
      url: 'https://images.unsplash.com/photo-1600573472592-401b489a3cdc?w=800',
      annonceId: 5,
    ),
    Photo(
      id: 12,
      url: 'https://images.unsplash.com/photo-1600566752355-35792bedcfea?w=800',
      annonceId: 5,
    ),
    Photo(
      id: 13,
      url: 'https://images.unsplash.com/photo-1600563438938-a42d0c5e0b6e?w=800',
      annonceId: 5,
    ),
  ];

  static final List<Annonce> annonces = [
    Annonce(
      id: 1,
      titre: 'Villa moderne avec piscine - Almadies',
      description:
          'Magnifique villa de 4 chambres avec piscine, jardin et vue sur mer. Située dans le quartier résidentiel des Almadies, cette propriété offre tout le confort moderne avec une architecture contemporaine. Idéale pour une famille ou pour investissement locatif.',
      prix: 85000000,
      modalitesPaiement: 'Comptant ou financement bancaire possible',
      typeLogement: TypeLogement.VILLA,
      region: 'Dakar',
      commune: 'Almadies',
      adresse: 'Route des Almadies, près de la corniche',
      nombreChambres: 4,
      vues: 156,
      proprietaire: users[0],
      photos: photos.where((p) => p.annonceId == 1).toList(),
      createdAt: DateTime.now().subtract(Duration(days: 15)),
      updatedAt: DateTime.now().subtract(Duration(days: 2)),
    ),
    Annonce(
      id: 2,
      titre: 'Appartement 3 pièces - Plateau',
      description:
          'Bel appartement de 3 pièces au cœur du Plateau. Proche des commerces, transports et administrations. Immeuble sécurisé avec ascenseur. Parfait pour jeune couple ou professionnel.',
      prix: 35000000,
      modalitesPaiement: 'Négociable, facilités de paiement',
      typeLogement: TypeLogement.APPARTEMENT,
      region: 'Dakar',
      commune: 'Plateau',
      adresse: 'Avenue Léopold Sédar Senghor',
      nombreChambres: 2,
      vues: 89,
      proprietaire: users[2],
      photos: photos.where((p) => p.annonceId == 2).toList(),
      createdAt: DateTime.now().subtract(Duration(days: 12)),
      updatedAt: DateTime.now().subtract(Duration(days: 1)),
    ),
    Annonce(
      id: 3,
      titre: 'Maison familiale - Thiès',
      description:
          'Grande maison familiale de 5 chambres avec cour spacieuse. Quartier calme et résidentiel. Proche des écoles et centres de santé. Idéale pour grande famille.',
      prix: 45000000,
      modalitesPaiement: 'Comptant de préférence',
      typeLogement: TypeLogement.MAISON,
      region: 'Thiès',
      commune: 'Thiès Nord',
      adresse: 'Quartier Randoulène',
      nombreChambres: 5,
      vues: 67,
      proprietaire: users[0],
      photos: photos.where((p) => p.annonceId == 3).toList(),
      createdAt: DateTime.now().subtract(Duration(days: 8)),
      updatedAt: DateTime.now().subtract(Duration(days: 1)),
    ),
    Annonce(
      id: 4,
      titre: 'Studio meublé - Mermoz',
      description:
          'Studio moderne entièrement meublé et équipé. Climatisation, wifi inclus. Parfait pour étudiant ou jeune professionnel. Disponible immédiatement.',
      prix: 18000000,
      modalitesPaiement: 'Paiement échelonné possible',
      typeLogement: TypeLogement.STUDIO,
      region: 'Dakar',
      commune: 'Mermoz',
      adresse: 'Cité Keur Gorgui',
      nombreChambres: 1,
      vues: 134,
      proprietaire: users[2],
      photos: photos.where((p) => p.annonceId == 4).toList(),
      createdAt: DateTime.now().subtract(Duration(days: 5)),
      updatedAt: DateTime.now(),
    ),
    Annonce(
      id: 5,
      titre: 'Chambre dans villa - Point E',
      description:
          'Chambre spacieuse dans villa partagée. Accès cuisine, salon et jardin. Environnement calme et sécurisé. Idéal pour étudiant ou stagiaire.',
      prix: 8000000,
      modalitesPaiement: 'Mensuel ou trimestriel',
      typeLogement: TypeLogement.CHAMBRE,
      region: 'Dakar',
      commune: 'Point E',
      adresse: 'Résidence Point E',
      nombreChambres: 1,
      vues: 45,
      proprietaire: users[0],
      photos: photos.where((p) => p.annonceId == 5).toList(),
      createdAt: DateTime.now().subtract(Duration(days: 3)),
      updatedAt: DateTime.now(),
    ),
  ];

  static List<String> regions = [
    'Dakar',
    'Thiès',
    'Saint-Louis',
    'Kaolack',
    'Ziguinchor',
    'Diourbel',
    'Louga',
    'Fatick',
    'Kolda',
    'Tambacounda',
    'Kaffrine',
    'Kédougou',
    'Matam',
    'Sédhiou',
  ];

  static Map<String, List<String>> communesParRegion = {
    'Dakar': [
      'Plateau',
      'Almadies',
      'Mermoz',
      'Point E',
      'Sacré-Cœur',
      'Ouakam',
      'Ngor',
    ],
    'Thiès': ['Thiès Nord', 'Thiès Sud', 'Thiès Est', 'Thiès Ouest'],
    'Saint-Louis': [
      'Saint-Louis Centre',
      'Saint-Louis Nord',
      'Saint-Louis Sud',
    ],
    'Kaolack': ['Kaolack Centre', 'Kaolack Nord', 'Kaolack Sud'],
    // Ajouter d'autres communes selon les besoins
  };
}
