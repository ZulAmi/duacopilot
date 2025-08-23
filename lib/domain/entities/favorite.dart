import 'package:equatable/equatable.dart';

enum FavoriteType { ragResponse, audio, query }

/// Favorite class implementation
class Favorite extends Equatable {
  final int? id;
  final String itemId;
  final FavoriteType itemType;
  final String? title;
  final String? content;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const Favorite({
    this.id,
    required this.itemId,
    required this.itemType,
    this.title,
    this.content,
    this.metadata,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    itemId,
    itemType,
    title,
    content,
    metadata,
    createdAt,
  ];
}
