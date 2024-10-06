class Category
{
  int categoryID;
  String categoryName;
  String description;

  Category({
    required this.categoryID,
    required this.categoryName,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryID: json['categoryId'] ?? 0,
      categoryName: json['categoryName'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, Object?> toMap() {
    return {
      "categoryId": categoryID,
      "categoryName": categoryName,
      "description": description,
    };
  }

}