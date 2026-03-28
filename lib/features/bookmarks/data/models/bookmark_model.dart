import 'package:hive/hive.dart';
import 'package:blogapps/features/home/data/models/blog_post_model.dart';

part 'bookmark_model.g.dart';

@HiveType(typeId: 0)
class Bookmark extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String? imageUrl;
  @HiveField(3)
  final String content;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final String? authorName;
  @HiveField(6)
  final String slug;

  Bookmark({
    required this.id,
    required this.title,
    required this.slug,
    this.imageUrl,
    required this.content,
    required this.createdAt,
    this.authorName,
  });

  BlogPost toBlogPost() {
    return BlogPost(
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
