import 'package:equatable/equatable.dart';

class FoodItem extends Equatable {
  const FoodItem({
    required this.calories,
  });

  final int calories;

  @override
  List<Object?> get props => [calories];

  FoodItem copyWith({
    int? calories,
  }) {
    return FoodItem(
      calories: calories ?? this.calories,
    );
  }
}
