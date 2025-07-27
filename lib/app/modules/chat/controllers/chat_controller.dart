import 'package:get/get.dart';
import '../../../models/annonce.dart';
import '../../../services/annonce_service_mock.dart';
import '../../../services/utils_service_mock.dart';

class Message {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<Annonce>? suggestions;

  Message({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.suggestions,
  });
}

class ChatController extends GetxController {
  final AnnonceServiceMock _annonceService = Get.find<AnnonceServiceMock>();
  final UtilsServiceMock _utilsService = Get.find<UtilsServiceMock>();
  // Observables
  final messages = <Message>[].obs;
  final isTyping = false.obs;
  final messageController = ''.obs;
  final isVisible = false.obs;
  
  // Suggestions prédéfinies
  final quickReplies = [
    'Rechercher une villa',
    'Appartements à Dakar',
    'Prix moyen des maisons',
    'Comment publier une annonce ?',
    'Contacter un propriétaire',
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeChat();
  }

  void _initializeChat() {
    // Message de bienvenue
    final welcomeMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text:
          'Bonjour ! Je suis votre assistant immobilier. Comment puis-je vous aider aujourd\'hui ?',
      isUser: false,
      timestamp: DateTime.now(),
    );
    
    messages.add(welcomeMessage);
    update();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Ajouter le message de l'utilisateur
    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );
    
    messages.add(userMessage);
    messageController.value = '';
    update();
    
    // Simuler la frappe du bot
    isTyping.value = true;
    update();
    
    // Délai pour simuler la réflexion
    await Future.delayed(Duration(milliseconds: 1000 + (text.length * 50)));
    
    // Générer la réponse du bot
    final botResponse = await _generateBotResponse(text);
    
    isTyping.value = false;
    messages.add(botResponse);
    update();
    
    // Faire défiler vers le bas
    _scrollToBottom();
  }

  Future<Message> _generateBotResponse(String userMessage) async {
    final message = userMessage.toLowerCase();
    String response = '';
    List<Annonce>? suggestions;

    // Analyse simple du message pour générer une réponse appropriée
    if (message.contains('villa') || message.contains('villas')) {
      response =
          'Je vois que vous cherchez une villa. Voici quelques villas disponibles dans notre base de données :';
      suggestions =
          _getMockAnnonces()
              .where((a) => a.typeLogement == TypeLogement.VILLA)
              .toList();
    } else if (message.contains('appartement') ||
        message.contains('appartements')) {
      response = 'Voici les appartements disponibles :';
      suggestions =
          _getMockAnnonces()
              .where((a) => a.typeLogement == TypeLogement.APPARTEMENT)
              .toList();
    } else if (message.contains('maison') || message.contains('maisons')) {
      response = 'Voici les maisons disponibles :';
      suggestions =
          _getMockAnnonces()
              .where((a) => a.typeLogement == TypeLogement.MAISON)
              .toList();
    } else if (message.contains('studio') || message.contains('studios')) {
      response = 'Voici les studios disponibles :';
      suggestions =
          _getMockAnnonces()
              .where((a) => a.typeLogement == TypeLogement.STUDIO)
              .toList();
    } else if (message.contains('dakar')) {
      response = 'Voici les propriétés disponibles à Dakar :';
      suggestions =
          _getMockAnnonces()
              .where((a) => a.region.toLowerCase().contains('dakar'))
              .toList();
    } else if (message.contains('thiès') || message.contains('thies')) {
      response = 'Voici les propriétés disponibles à Thiès :';
      suggestions =
          _getMockAnnonces()
              .where((a) => a.region.toLowerCase().contains('thiès'))
              .toList();
    } else if (message.contains('prix') ||
        message.contains('coût') ||
        message.contains('cout')) {
      response =
          'Les prix varient selon le type de logement :\n\n'
          '• Villas : 45M - 85M FCFA\n'
          '• Maisons : 35M - 50M FCFA\n'
          '• Appartements : 25M - 40M FCFA\n'
          '• Studios : 15M - 25M FCFA\n'
          '• Chambres : 5M - 15M FCFA\n\n'
          'Souhaitez-vous voir des annonces dans une gamme de prix spécifique ?';
    } else if (message.contains('publier') ||
        message.contains('créer') ||
        message.contains('ajouter')) {
      response =
          'Pour publier une annonce, vous devez :\n\n'
          '1. Créer un compte propriétaire\n'
          '2. Vous connecter à l\'application\n'
          '3. Aller dans "Mes annonces"\n'
          '4. Cliquer sur "Nouvelle annonce"\n'
          '5. Remplir le formulaire avec les détails\n'
          '6. Ajouter des photos\n'
          '7. Publier votre annonce\n\n'
          'Voulez-vous que je vous guide vers la page de création de compte ?';
    } else if (message.contains('contacter') ||
        message.contains('contact') ||
        message.contains('téléphone') ||
        message.contains('whatsapp')) {
      response =
          'Pour contacter un propriétaire :\n\n'
          '1. Ouvrez l\'annonce qui vous intéresse\n'
          '2. Cliquez sur "Contacter le propriétaire"\n'
          '3. Choisissez votre mode de contact :\n'
          '   • Appel téléphonique\n'
          '   • Message WhatsApp\n'
          '   • Email\n\n'
          'Le propriétaire sera notifié de votre intérêt !';
    } else if (message.contains('aide') || message.contains('help')) {
      response =
          'Je peux vous aider avec :\n\n'
          '• Rechercher des propriétés par type ou localisation\n'
          '• Obtenir des informations sur les prix\n'
          '• Expliquer comment publier une annonce\n'
          '• Guider pour contacter un propriétaire\n'
          '• Répondre à vos questions générales\n\n'
          'Que souhaitez-vous savoir ?';
    } else if (message.contains('merci') || message.contains('thank')) {
      response =
          'Je vous en prie ! N\'hésitez pas si vous avez d\'autres questions. Je suis là pour vous aider à trouver le logement idéal ! 😊';
    } else if (message.contains('bonjour') ||
        message.contains('salut') ||
        message.contains('hello')) {
      response =
          'Bonjour ! Ravi de vous aider dans votre recherche immobilière. Que puis-je faire pour vous aujourd\'hui ?';
    } else {
      // Réponse par défaut avec suggestions
      response =
          'Je comprends que vous cherchez des informations immobilières. Voici ce que je peux vous proposer :\n\n'
          '• Rechercher par type de logement (villa, maison, appartement...)\n'
          '• Filtrer par région (Dakar, Thiès, Saint-Louis...)\n'
          '• Obtenir des informations sur les prix\n'
          '• Aide pour publier une annonce\n\n'
          'Pouvez-vous préciser ce que vous recherchez ?';
    }

    return Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: response,
      isUser: false,
      timestamp: DateTime.now(),
      suggestions: suggestions,
    );
  }

  List<Annonce> _getMockAnnonces() {
    // Retourner quelques annonces mock pour les suggestions
    // En réalité, cela viendrait du service API
    return [
      // Vous pouvez ajouter quelques annonces mock ici
      // ou récupérer depuis le service
    ];
  }

  void sendQuickReply(String reply) {
    sendMessage(reply);
  }

  void toggleChatVisibility() {
    isVisible.value = !isVisible.value;
  }

  void showChat() {
    isVisible.value = true;
  }

  void hideChat() {
    isVisible.value = false;
  }

  void clearChat() {
    messages.clear();
    _initializeChat();
    update();
  }

  void _scrollToBottom() {
    // Cette méthode sera utilisée dans l'UI pour faire défiler vers le bas
    // L'implémentation dépendra du widget utilisé (ScrollController)
  }

  void onAnnonceSelected(Annonce annonce) {
    hideChat();
    Get.toNamed('/annonce/detail', arguments: annonce);
  }

  // Getters utiles
  bool get hasMessages => messages.isNotEmpty;
  
  int get messageCount => messages.length;
  
  Message? get lastMessage => messages.isNotEmpty ? messages.last : null;
  
  bool get isLastMessageFromBot => lastMessage?.isUser == false;
}
