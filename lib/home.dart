import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'favorites_manager.dart';
import 'cart_manager.dart';
import 'package:card_swiper/card_swiper.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List products = [];
  bool isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchTrendingProducts();
  }

  Future<void> fetchTrendingProducts() async {
    try {
      final response =
      await Dio().get('https://dummyjson.com/products?limit=4');

      setState(() {
        products = response.data['products'];
        isLoading = false;
      });
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  Future<void> _onItemTapped(int index) async {
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
      case 4:
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(context, '/login');
        break;
    }
  }

  Widget _buildDepartmentCard(
      String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90.w,
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Color(0xFF87986A), size: 30.sp),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    bool isFav = FavoritesManager.isFavorite(product['id']);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: Image.network(
                  product['thumbnail'],
                  height: 120.h,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120.h,
                      color: Colors.grey[200],
                      child: Icon(Icons.image, size: 40.sp, color: Colors.grey),
                    );
                  },
                ),
              ),

              // Product Details
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "\$${product['price']}",
                            style: TextStyle(
                                color: Color(0xFF87986A),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),

                      // Add to Cart Button
                      GestureDetector(
                        onTap: () {
                          CartManager.addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${product['title']} added to cart 🛒"),
                              duration: Duration(seconds: 1),
                            ),
                          );
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
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Favorite Icon
          Positioned(
            right: 6.w,
            top: 6.h,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  FavoritesManager.toggleFavorite(product);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      FavoritesManager.isFavorite(product['id'])
                          ? "Added to favorites"
                          : "Removed from favorites",
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.grey,
                  size: 16.sp,
                ),
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
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= Banner =================
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.w),
                margin: EdgeInsets.only(bottom: 10.h),
                decoration: BoxDecoration(
                  color: Color(0xFF97A97C),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    "FREE SHIPPING OVER \$50",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp
                    ),
                  ),
                ),
              ),

              // ================= Shop by Department =================
              Text(
                  "Shop by Department",
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 10.h),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildDepartmentCard("All", Icons.grid_view,
                            () => Navigator.pushNamed(context, '/products')),
                    _buildDepartmentCard("Makeup", Icons.brush,
                            () => Navigator.pushNamed(context, '/makeup')),
                    _buildDepartmentCard("Furniture", Icons.chair,
                            () => Navigator.pushNamed(context, '/furniture')),
                    _buildDepartmentCard("Perfume", Icons.air,
                            () => Navigator.pushNamed(context, '/perfume')),
                    _buildDepartmentCard("Foods", Icons.fastfood,
                            () => Navigator.pushNamed(context, '/foods')),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // ================= Featured Products =================
              Text(
                "Featured Products",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),

              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                height: 220.h,
                child: Swiper(
                  itemCount: products.length,
                  autoplay: true,
                  pagination: SwiperPagination(),
                  viewportFraction: 0.8,
                  scale: 0.9,
                  itemBuilder: (context, index) {
                    final product = products[index];
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
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12.r)),
                            child: Image.network(
                              product['thumbnail'],
                              height: 140.h,
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['title'],
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "\$${product['price']}",
                                  style: TextStyle(
                                      color: Color(0xFF87986A),
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20.h),

              // ================= Trending Products =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "Top Trending Products",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/products'),
                    child: Text(
                      "See All",
                      style: TextStyle(
                          color: Color(0xFF97A97C),
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 0.65,
                  mainAxisExtent: 220.h,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(products[index]);
                },
              ),

              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),

      // ================= Bottom Navigation =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF87986A),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.store_outlined), label: "Products"),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout"),
        ],
      ),
    );
  }
}