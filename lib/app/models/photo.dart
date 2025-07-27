class Photo {
  final int id;
  final String url;
  final int annonceId;

  Photo({
    required this.id,
    required this.url,
    required this.annonceId,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as int,
      url: json['url'] as String,
      annonceId: json['annonceId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'annonceId': annonceId,
    };
  }

  Photo copyWith({
    int? id,
    String? url,
    int? annonceId,
  }) {
    return Photo(
      id: id ?? this.id,
      url: url ?? this.url,
      annonceId: annonceId ?? this.annonceId,
    );
  }

  @override
  String toString() {
    return 'Photo{id: $id, url: $url, annonceId: $annonceId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Photo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

