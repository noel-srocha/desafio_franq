import 'package:desafio_franq/domain/entities/rating.dart';

class RatingModel {
  final double rate;
  final int count;

  RatingModel({required this.rate, required this.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    final dynamic rateVal = json['rate'];
    final dynamic countVal = json['count'];
    return RatingModel(
      rate: rateVal is int ? rateVal.toDouble() : (rateVal as num?)?.toDouble() ?? 0.0,
      count: (countVal as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'rate': rate,
        'count': count,
      };

  Rating toEntity() => Rating(rate: rate, count: count);

  static RatingModel fromEntity(Rating entity) => RatingModel(rate: entity.rate, count: entity.count);
}
