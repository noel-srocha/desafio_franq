import 'package:desafio_franq/domain/entities/product.dart';
import 'package:desafio_franq/domain/entities/rating.dart';
import 'rating_model.dart';

class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final RatingModel rating;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final dynamic priceVal = json['price'];
    return ProductModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      price: priceVal is int ? priceVal.toDouble() : (priceVal as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'] as Map<String, dynamic>)
          : RatingModel(rate: 0, count: 0),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'image': image,
        'rating': rating.toJson(),
      };

  Product toEntity() => Product(
        id: id,
        title: title,
        price: price,
        description: description,
        category: category,
        image: image,
        rating: Rating(rate: rating.rate, count: rating.count),
      );

  static ProductModel fromEntity(Product entity) => ProductModel(
        id: entity.id,
        title: entity.title,
        price: entity.price,
        description: entity.description,
        category: entity.category,
        image: entity.image,
        rating: RatingModel.fromEntity(entity.rating),
      );
}
