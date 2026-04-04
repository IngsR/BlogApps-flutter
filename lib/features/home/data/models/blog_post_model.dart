// ignore_for_file: overridden_fields

import 'package:blogapps/core/common/entities/blog_post.dart';
import 'package:hive/hive.dart';

part 'blog_post_model.g.dart';

@HiveType(typeId: 1)
class BlogPostModel extends BlogPost {
  @override
  @HiveField(0)
  final String id;
  
  @override
  @HiveField(1)
  final String title;
  
  @override
  @HiveField(2)
  final String slug;
  
  @override
  @HiveField(3)
  final String content;
  
  @override
  @HiveField(4)
  final String? imageUrl;
  
  @override
  @HiveField(5)
  final String? categoryId;
  
  @override
  @HiveField(6)
  final bool isFeatured;
  
  @override
  @HiveField(7)
  final DateTime createdAt;
  
  @override
  @HiveField(8)
  final String? authorId;
  
  @override
  @HiveField(9)
  final String? authorName;
  
  @override
  @HiveField(10)
  final String? authorAvatar;

  const BlogPostModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.content,
    this.imageUrl,
    this.categoryId,
    this.isFeatured = false,
    required this.createdAt,
    this.authorId,
    this.authorName,
    this.authorAvatar,
  }) : super(
          id: id,
          title: title,
          slug: slug,
          content: content,
          imageUrl: imageUrl,
          categoryId: categoryId,
          isFeatured: isFeatured,
          createdAt: createdAt,
          authorId: authorId,
          authorName: authorName,
          authorAvatar: authorAvatar,
        );

  factory BlogPostModel.fromJson(Map<String, dynamic> json) {
    return BlogPostModel(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      categoryId: json['category_id'] as String?,
      isFeatured: json['is_featured'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      authorId: json['author_id'] as String?,
      authorName: json['author_name'] as String?,
      authorAvatar: json['author_avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'content': content,
      'image_url': imageUrl,
      'category_id': categoryId,
      'is_featured': isFeatured,
      'created_at': createdAt.toIso8601String(),
      'author_id': authorId,
      'author_name': authorName,
      'author_avatar': authorAvatar,
    };
  }
}
