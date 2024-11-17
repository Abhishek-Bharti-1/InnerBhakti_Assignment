class MusicCategory {
  final String id;
  final String name;
  final String imageUrl;
  final int duration;
  final String description;

  MusicCategory({required this.id, required this.name, required this.imageUrl,required this.duration,required this.description});

  factory MusicCategory.fromJson(Map<String, dynamic> json) {
    return MusicCategory(
      id: json['id'],
      name: json['title'],
      imageUrl: json['coverImageUrl'],
      duration: json['duration'],
      description: json['description']
    );
  }
}