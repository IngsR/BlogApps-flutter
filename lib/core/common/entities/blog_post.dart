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

  int get readingTime => (content.length / 500).ceil();

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
}
