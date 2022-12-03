import 'package:flutter_auth/domain/entity/Country_entity.dart';

class ProductCategory extends ProductCategoryEntity {
  int? id;
  late String name;
  late String description;

  ProductCategory({required this.name, required this.description})
      : super(name: name, description: description);

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'description': description};
  }

  factory ProductCategory.toFromMap(Map<String, dynamic> json) {
    return ProductCategory(
        name: json['name'], description: json['description']);
  }
}
