// ignore_for_file: overridden_fields

import 'package:blogapps/core/common/entities/category.dart';
import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 2)
class CategoryModel extends Category {
  @override
  @HiveField(0)
  final String id;
  
  @override
  @HiveField(1)
  final String name;
  
  @override
  @HiveField(2)
  final String slug;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
  }) : super(
          id: id,
          name: name,
          slug: slug,
        );

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }
}
