import 'package:hive_flutter/hive_flutter.dart';
part 'shoppinglist_item.g.dart';

@HiveType(typeId: 3)
class ShopingListItem {
  @HiveField(0)
  final String name;
  @HiveField(1)
  String category;
  @HiveField(2)
  String quantity;
  @HiveField(3)
  String unit;

  ShopingListItem({
    required this.name,
    required this.quantity,
    this.unit = '',
    this.category = 'others',
  });

   Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'category': category,
    };
  }
}
