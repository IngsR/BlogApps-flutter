import 'package:equatable/equatable.dart';
import 'package:blogapps/features/bookmarks/data/models/bookmark_model.dart';

class BlogPost extends Equatable {
  final String id;
  final String title;
  final String slug;
  final String content;
  final String? imageUrl;
  final String? categoryId;
  final bool isFeatured;
  final DateTime createdAt;
  final String? authorId;
  final String? authorName;
  final String? authorAvatar;

  const BlogPost({
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
  });

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String? ?? '',
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      categoryId: json['category_id'] as String?,
      isFeatured: json['is_featured'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      authorId: json['author_id'] as String?,
      authorName: json['profiles']?['name'] as String?,
      authorAvatar: json['profiles']?['avatar_url'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id, 
    title, 
    slug,
    content, 
    imageUrl, 
    categoryId, 
    isFeatured, 
    createdAt, 
    authorId,
    authorName,
    authorAvatar,
  ];

  Bookmark toBookmark() {
    return Bookmark(
      id: id,
      title: title,
      slug: slug,
      content: content,
      imageUrl: imageUrl,
      createdAt: createdAt,
      authorName: authorName,
    );
  }
}
