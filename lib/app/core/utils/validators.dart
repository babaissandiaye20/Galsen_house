class Validators {
  // Validation email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format d\'email invalide';
    }
    
    return null;
  }

  // Validation mot de passe
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    
    return null;
  }

  // Validation confirmation mot de passe
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'La confirmation du mot de passe est requise';
    }
    
    if (value != password) {
      return 'Les mots de passe ne correspondent pas';
    }
    
    return null;
  }

  // Validation nom/prénom
  static String? validateName(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName est requis';
    }
    
    if (value.length < 2) {
      return '$fieldName doit contenir au moins 2 caractères';
    }
    
    final nameRegex = RegExp(r'^[a-zA-ZÀ-ÿ\s-]+$');
    if (!nameRegex.hasMatch(value)) {
      return '$fieldName ne peut contenir que des lettres, espaces et tirets';
    }
    
    return null;
  }

  // Validation téléphone sénégalais
  static String? validatePhoneSenegal(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de téléphone est requis';
    }
    
    // Supprimer les espaces et caractères spéciaux
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Formats acceptés: +221XXXXXXXXX, 221XXXXXXXXX, 0XXXXXXXXX, XXXXXXXXX
    final phoneRegex = RegExp(r'^(\+221|221|0)?[7][0-8][0-9]{7}$');
    
    if (!phoneRegex.hasMatch(cleanPhone)) {
      return 'Format de téléphone invalide (ex: 77 123 45 67)';
    }
    
    return null;
  }

  // Validation prix
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le prix est requis';
    }
    
    final price = double.tryParse(value.replaceAll(RegExp(r'[^\d.]'), ''));
    if (price == null || price <= 0) {
      return 'Le prix doit être un nombre positif';
    }
    
    if (price > 100000000) {
      return 'Le prix ne peut pas dépasser 100 millions FCFA';
    }
    
    return null;
  }

  // Validation nombre de chambres
  static String? validateChambres(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le nombre de chambres est requis';
    }
    
    final chambres = int.tryParse(value);
    if (chambres == null || chambres < 0) {
      return 'Le nombre de chambres doit être un nombre positif';
    }
    
    if (chambres > 20) {
      return 'Le nombre de chambres ne peut pas dépasser 20';
    }
    
    return null;
  }

  // Validation titre d'annonce
  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le titre est requis';
    }
    
    if (value.length < 10) {
      return 'Le titre doit contenir au moins 10 caractères';
    }
    
    if (value.length > 100) {
      return 'Le titre ne peut pas dépasser 100 caractères';
    }
    
    return null;
  }

  // Validation description
  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'La description est requise';
    }
    
    if (value.length < 20) {
      return 'La description doit contenir au moins 20 caractères';
    }
    
    if (value.length > 1000) {
      return 'La description ne peut pas dépasser 1000 caractères';
    }
    
    return null;
  }

  // Validation adresse
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'adresse est requise';
    }
    
    if (value.length < 5) {
      return 'L\'adresse doit contenir au moins 5 caractères';
    }
    
    if (value.length > 200) {
      return 'L\'adresse ne peut pas dépasser 200 caractères';
    }
    
    return null;
  }

  // Validation champ requis générique
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }

  // Validation longueur minimale
  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName est requis';
    }
    
    if (value.length < minLength) {
      return '$fieldName doit contenir au moins $minLength caractères';
    }
    
    return null;
  }

  // Validation longueur maximale
  static String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.length > maxLength) {
      return '$fieldName ne peut pas dépasser $maxLength caractères';
    }
    
    return null;
  }

  // Validation URL
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL optionnelle
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Format d\'URL invalide';
    }
    
    return null;
  }

  // Validation numérique
  static String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName est requis';
    }
    
    if (double.tryParse(value) == null) {
      return '$fieldName doit être un nombre';
    }
    
    return null;
  }

  // Validation entier positif
  static String? validatePositiveInteger(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName est requis';
    }
    
    final number = int.tryParse(value);
    if (number == null || number < 0) {
      return '$fieldName doit être un nombre entier positif';
    }
    
    return null;
  }

  // Validation format de fichier image
  static String? validateImageFile(String? filePath) {
    if (filePath == null || filePath.isEmpty) {
      return 'Aucun fichier sélectionné';
    }
    
    final allowedExtensions = ['.jpg', '.jpeg', '.png', '.webp'];
    final extension = filePath.toLowerCase().substring(filePath.lastIndexOf('.'));
    
    if (!allowedExtensions.contains(extension)) {
      return 'Format de fichier non supporté. Utilisez JPG, PNG ou WebP';
    }
    
    return null;
  }

  // Validation multiple (combine plusieurs validateurs)
  static String? validateMultiple(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }

  // Validation conditionnelle
  static String? validateConditional(
    String? value,
    bool condition,
    String? Function(String?) validator,
  ) {
    if (!condition) return null;
    return validator(value);
  }

  // Nettoyage et formatage du téléphone
  static String formatPhoneSenegal(String phone) {
    // Supprimer tous les caractères non numériques sauf le +
    String cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Si commence par +221, garder tel quel
    if (cleaned.startsWith('+221')) {
      return cleaned;
    }
    
    // Si commence par 221, ajouter le +
    if (cleaned.startsWith('221')) {
      return '+$cleaned';
    }
    
    // Si commence par 0, remplacer par +221
    if (cleaned.startsWith('0')) {
      return '+221${cleaned.substring(1)}';
    }
    
    // Sinon, ajouter +221
    return '+221$cleaned';
  }

  // Validation et formatage du prix
  static String formatPrice(String price) {
    // Supprimer tous les caractères non numériques
    final cleaned = price.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleaned.isEmpty) return '0';
    
    // Convertir en nombre et formater avec des espaces
    final number = int.parse(cleaned);
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }
}

