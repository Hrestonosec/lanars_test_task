class Photo {
  final String url;
  final String photographer;
  final String alt;

  Photo({
    required this.url,
    required this.photographer,
    required this.alt,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      url: json['src']['medium'] ?? '',
      photographer: json['photographer'] ?? '',
      alt: json['alt'] ?? '',
    );
  }
}
