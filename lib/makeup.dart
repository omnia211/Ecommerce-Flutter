import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'favorites_manager.dart';
import 'cart_manager.dart';

class MakeupPage extends StatefulWidget {
  static const String routeName = '/makeup';
  const MakeupPage({super.key});

  @override
  State<MakeupPage> createState() => _MakeupPageState();
}

class _MakeupPageState extends State<MakeupPage> {
  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response =
      await Dio().get('https://dummyjson.com/products/category/beauty');
      setState(() {
        products = response.data['products'];
        isLoading = false;
      });
    } catch (e) {
      print('Error loading makeup products: $e');
    }
  }

  Widget _buildProductCard(dynamic product) {
    bool isFav = FavoritesManager.isFavorite(product['id']);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========== Product Image ==========
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: Image.network(
                  product['thumbnail'],
                  height: 110.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // ========== Product Details ==========
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['title'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14.sp),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "\$${product['price']}",
                      style: TextStyle(color: Color(0xFF87986A)),
                    ),
                    SizedBox(height: 8.h),

                    // ========== Add To Cart ==========
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          final productMap = {
                            'id': product['id'],
                            'title': product['title'],
                            'price': product['price'],
                            'thumbnail': product['thumbnail'],
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
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Color(0xFF6C8C6E),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            "Add To Cart",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ========== Favorite Icon ==========
          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  FavoritesManager.toggleFavorite(product);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      FavoritesManager.isFavorite(product['id'])
                          ? "${product['title']} added to favorites ❤️"
                          : "${product['title']} removed from favorites 💔",
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Icon(
                FavoritesManager.isFavorite(product['id'])
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: FavoritesManager.isFavorite(product['id'])
                    ? Colors.red
                    : Colors.grey,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Makeup")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: EdgeInsets.all(12.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.68,
        ),
        itemCount: products.length,
        itemBuilder: (_, i) => _buildProductCard(products[i]),
      ),
    );
  }
}
