// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BlogPostModelAdapter extends TypeAdapter<BlogPostModel> {
  @override
  final int typeId = 1;

  @override
  BlogPostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BlogPostModel(
      id: fields[0] as String,
      title: fields[1] as String,
      slug: fields[2] as String,
      content: fields[3] as String,
      imageUrl: fields[4] as String?,
      categoryId: fields[5] as String?,
      isFeatured: fields[6] as bool,
      createdAt: fields[7] as DateTime,
      authorId: fields[8] as String?,
      authorName: fields[9] as String?,
      authorAvatar: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BlogPostModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.slug)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.categoryId)
      ..writeByte(6)
      ..write(obj.isFeatured)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.authorId)
      ..writeByte(9)
      ..write(obj.authorName)
      ..writeByte(10)
      ..write(obj.authorAvatar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlogPostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
