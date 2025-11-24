import 'package:flutter/material.dart';
import 'api_service.dart';
import 'models.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetail extends StatefulWidget {
  static const routeName = '/product';
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final ApiService api = ApiService();
  late Future<Product> productFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = ModalRoute.of(context)?.settings.arguments as int?;
    if (id != null) {
      productFuture = api.fetchProductById(id);
    } else {
      productFuture = Future.error('No product id');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product'),
      ),
      body: FutureBuilder<Product>(
        future: productFuture,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final p = snap.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: p.thumbnail,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Center(child: CircularProgressIndicator()),
                    errorWidget: (_, __, ___) => Icon(Icons.broken_image, size: 120),
                  ),
                  SizedBox(height: 12),
                  Text(p.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("\$${p.price}", style: TextStyle(fontSize: 18, color: Colors.green[700])),
                  SizedBox(height: 12),
                  Text(p.description),
                  SizedBox(height: 16),
                  Text("Category: ${p.category}", style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
