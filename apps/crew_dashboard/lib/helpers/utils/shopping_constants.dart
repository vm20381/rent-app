import 'package:captainapp_crew_dashboard/models/shopping_cart_data.dart';
import 'package:captainapp_crew_dashboard/models/shopping_product_data.dart';

class ShoppingCache {
  static List<ShoppingProduct>? products;
  static List<ShoppingCart>? carts;

  static bool isFirstTime = true;
}
