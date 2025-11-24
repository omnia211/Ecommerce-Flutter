import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'api_service.dart';
import 'models.dart';
import 'product_detail.dart';
import 'favorites.dart';
import 'cart.dart';
import 'cart_manager.dart';
import 'favorites_manager.dart';

class ProductPage extends StatefulWidget {
  static const String routeName = '/products';
  const ProductPage({super.key});
  @override
  _ProductPageState createState() => _ProductPageState();
}
int _selectedIndex = 0;

class _ProductPageState extends State<ProductPage> {
  final ApiService api = ApiService();
  int _currentIndex = 0;
  late Future<List<Product>> productsFuture;

  @override
  void initState() {
    super.initState();
    productsFuture = api.fetchProducts();
  }

  List<Widget> get _pages => [
    _buildHome(),
    FavoritesPage(),
    CartPage(),
  ];
// ـ bottom bar
  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/cart');
        break;
      case 2:
        Navigator.pushNamed(context, '/favorites');
        break;
      case 3:
        Navigator.pushNamed(context, '/products');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      //  5- bottom nav bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF87986A),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: "Favorites"),
          BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined), label: "Products"),
        ],
      ),
    );
  }

  Widget _buildHome() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Find Your Dream Furniture",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFE3F0E4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("20% OFF\nUntil 24 Dec",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  Icon(Icons.chair_alt, size: 40, color: Color(0xFF6C8C6E)),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: productsFuture,
              builder: (context, snap) {
                if (!snap.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final products = snap.data!;
                return GridView.builder(
                  padding: EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: products.length,
                  itemBuilder: (_, i) {
                    final p = products[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ProductDetail.routeName,
                          arguments: p.id,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(1, 2),
                            )
                          ],
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                    child: CachedNetworkImage(
                                      imageUrl: p.thumbnail,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14)),
                                      SizedBox(height: 4),
                                      Text("\$${p.price}",
                                          style: TextStyle(
                                              color: Color(0xFF6C8C6E),
                                              fontWeight: FontWeight.w600)),
                                      SizedBox(height: 6),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            final productMap = {
                                              'id': p.id,
                                              'title': p.title,
                                              'price': p.price,
                                              'thumbnail': p.thumbnail,
                                            };
                                            final productId = productMap['id'];
                                            if (productId is int && !CartManager.isInCart(productId)) {
                                              CartManager.addToCart(productMap);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text("${productMap['title']} added to cart 🛒"),
                                                  duration: Duration(seconds: 1),
                                                ),
                                              );
                                            } else if (productId is int) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text("${productMap['title']} is already in cart"),
                                                  duration: Duration(seconds: 1),
                                                ),
                                              );
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF6C8C6E),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Add To Cart",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),


                            Positioned(
                              right: 8,
                              top: 8,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    FavoritesManager.toggleFavorite({
                                      'id': p.id,
                                      'title': p.title,
                                      'price': p.price,
                                      'thumbnail': p.thumbnail,
                                    });
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        FavoritesManager.isFavorite(p.id)
                                            ? "${p.title} added to favorites "
                                            : "${p.title} removed from favorites ",
                                      ),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: Icon(
                                  FavoritesManager.isFavorite(p.id)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: FavoritesManager.isFavorite(p.id)
                                      ? Colors.red
                                      : Colors.grey,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  ,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
