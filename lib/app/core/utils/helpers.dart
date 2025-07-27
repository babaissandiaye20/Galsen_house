import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpers {
  // Formatage des prix
  static String formatPrice(double price) {
    final formatter = NumberFormat('#,###', 'fr_FR');
    return formatter.format(price).replaceAll(',', ' ');
  }

  // Formatage des dates
  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy', 'fr_FR');
    return formatter.format(date);
  }

  static String formatDateTime(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy à HH:mm', 'fr_FR');
    return formatter.format(date);
  }

  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return formatDate(date);
    } else if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'À l\'instant';
    }
  }

  // Gestion des URLs
  static Future<bool> launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri);
      }
      return false;
    } catch (e) {
      debugPrint('Erreur lors du lancement de l\'URL: $e');
      return false;
    }
  }

  // Appel téléphonique
  static Future<bool> makePhoneCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    return await launchURL('tel:$cleanPhone');
  }

  // Message WhatsApp
  static Future<bool> sendWhatsAppMessage(String phoneNumber, [String? message]) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final encodedMessage = message != null ? Uri.encodeComponent(message) : '';
    return await launchURL('https://wa.me/$cleanPhone?text=$encodedMessage');
  }

  // Email
  static Future<bool> sendEmail(String email, [String? subject, String? body]) async {
    final encodedSubject = subject != null ? Uri.encodeComponent(subject) : '';
    final encodedBody = body != null ? Uri.encodeComponent(body) : '';
    return await launchURL('mailto:$email?subject=$encodedSubject&body=$encodedBody');
  }

  // Partage d'annonce
  static Future<bool> shareAnnonce(String title, String url) async {
    try {
      // Utiliser le package share_plus si disponible
      // Pour l'instant, on copie dans le presse-papier
      return await launchURL('https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(url)}');
    } catch (e) {
      debugPrint('Erreur lors du partage: $e');
      return false;
    }
  }

  // Affichage des snackbars
  static void showSuccessSnackbar(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Succès',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  static void showErrorSnackbar(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Erreur',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
    );
  }

  static void showInfoSnackbar(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Information',
      message,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      icon: const Icon(Icons.info, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  static void showWarningSnackbar(String message, {String? title}) {
    Get.snackbar(
      title ?? 'Attention',
      message,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      icon: const Icon(Icons.warning, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  // Dialogues de confirmation
  static Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirmer',
    String cancelText = 'Annuler',
    Color? confirmColor,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: confirmColor != null
                ? ElevatedButton.styleFrom(backgroundColor: confirmColor)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // Dialogue de suppression
  static Future<bool> showDeleteConfirmDialog({
    required String itemName,
    String? customMessage,
  }) async {
    return await showConfirmDialog(
      title: 'Confirmer la suppression',
      message: customMessage ?? 'Êtes-vous sûr de vouloir supprimer "$itemName" ? Cette action est irréversible.',
      confirmText: 'Supprimer',
      cancelText: 'Annuler',
      confirmColor: Colors.red,
    );
  }

  // Gestion des images
  static String getImagePlaceholder(String type) {
    switch (type.toLowerCase()) {
      case 'villa':
        return 'assets/images/villa_placeholder.png';
      case 'maison':
        return 'assets/images/maison_placeholder.png';
      case 'appartement':
        return 'assets/images/appartement_placeholder.png';
      case 'studio':
        return 'assets/images/studio_placeholder.png';
      case 'chambre':
        return 'assets/images/chambre_placeholder.png';
      default:
        return 'assets/images/default_placeholder.png';
    }
  }

  // Validation de taille de fichier
  static bool isFileSizeValid(int fileSizeInBytes, {int maxSizeInMB = 5}) {
    final maxSizeInBytes = maxSizeInMB * 1024 * 1024;
    return fileSizeInBytes <= maxSizeInBytes;
  }

  // Formatage de taille de fichier
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  // Génération de couleurs aléatoires pour les avatars
  static Color generateAvatarColor(String text) {
    final colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
    ];
    
    final hash = text.hashCode;
    return colors[hash.abs() % colors.length];
  }

  // Capitalisation de la première lettre
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Capitalisation de chaque mot
  static String capitalizeWords(String text) {
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  // Troncature de texte
  static String truncateText(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }

  // Nettoyage de texte
  static String cleanText(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  // Validation d'email simple
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  // Génération d'ID unique simple
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Calcul de distance approximative (formule haversine simplifiée)
  static double calculateDistance(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    const double earthRadius = 6371; // Rayon de la Terre en km
    
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);
    
    final double a = 
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    
    final double c = 2 * asin(sqrt(a));
    
    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // Formatage de distance
  static String formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).round()} m';
    } else {
      return '${distanceInKm.toStringAsFixed(1)} km';
    }
  }

  // Débounce pour les recherches
  static Timer? _debounceTimer;
  
  static void debounce(Duration duration, VoidCallback callback) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, callback);
  }

  // Vérification de connexion internet
  static Future<bool> hasInternetConnection() async {
    try {
      // Tentative de connexion à un serveur fiable
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Gestion des erreurs réseau
  static String getNetworkErrorMessage(dynamic error) {
    if (error.toString().contains('SocketException')) {
      return 'Pas de connexion internet';
    } else if (error.toString().contains('TimeoutException')) {
      return 'Délai de connexion dépassé';
    } else if (error.toString().contains('FormatException')) {
      return 'Erreur de format de données';
    } else {
      return 'Erreur de connexion';
    }
  }
}

// Extensions utiles
extension StringExtensions on String {
  String get capitalize => Helpers.capitalize(this);
  String get capitalizeWords => Helpers.capitalizeWords(this);
  String truncate(int maxLength, {String suffix = '...'}) => 
      Helpers.truncateText(this, maxLength, suffix: suffix);
  bool get isValidEmail => Helpers.isValidEmail(this);
}

extension DateTimeExtensions on DateTime {
  String get formatted => Helpers.formatDate(this);
  String get formattedWithTime => Helpers.formatDateTime(this);
  String get relativeTime => Helpers.formatRelativeTime(this);
}

extension DoubleExtensions on double {
  String get formattedPrice => Helpers.formatPrice(this);
}

