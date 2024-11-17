class CategoryDetails {
  final String id;
  final String title;
  final String description;

  CategoryDetails({required this.id, required this.title,required this.description});

  factory CategoryDetails.fromJson(Map<String, dynamic> json) {
    return CategoryDetails(
      id: json['id'],
      title: json['title'],
      description: json['subtitle'],
    );
  }
}