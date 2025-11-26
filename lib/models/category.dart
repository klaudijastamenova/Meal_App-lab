class Category {
  final String categoryID;
  final String categoryName;
  final String categoryThumb;
  final String categoryDescription;

  Category({
    required this.categoryID,
    required this.categoryName,
    required this.categoryThumb,
    required this.categoryDescription,
  });

  factory Category.fromJson(Map<String, dynamic> j) => Category(
    categoryID: j['idCategory'] as String,
    categoryName: j['strCategory'] as String,
    categoryThumb: j['strCategoryThumb'] as String,
    categoryDescription: j['strCategoryDescription'] as String,
  );
}