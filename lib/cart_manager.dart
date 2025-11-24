class CartManager {
  static final List<Map<String, dynamic>> _cartItems = [];

  static List<Map<String, dynamic>> get items => _cartItems;

  static void addToCart(Map<String, dynamic> product) {
    final exists = _cartItems.any((item) => item['id'] == product['id']);
    if (!exists) {
      _cartItems.add(product);
    }
  }

  static void removeFromCart(int id) {
    _cartItems.removeWhere((item) => item['id'] == id);
  }

  static void clearCart() {
    _cartItems.clear();
  }

  /// ✅ الدالة دي هي اللي كانت ناقصة
  static bool isInCart(int id) {
    return _cartItems.any((item) => item['id'] == id);
  }
}
