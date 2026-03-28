import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String slug;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
    };
  }

  @override
  List<Object?> get props => [id, name, slug];
}
