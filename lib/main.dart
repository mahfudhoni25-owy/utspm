import 'package:flutter/material.dart';

void main() {
  runApp(MyShopApp());
}

class MyShopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop Mini',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

// ========================= MODELS =============================

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class Product {
  final String id;
  final String categoryId;
  final String name;
  final double price;
  final IconData icon;

  Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.icon,
  });
}

// ========================= CATEGORY DATA =============================

final List<Category> kCategories = [
  Category(id: 'c1', name: 'Makanan', icon: Icons.fastfood, color: Colors.orange),
  Category(id: 'c2', name: 'Minuman', icon: Icons.local_drink, color: Colors.blue),
  Category(id: 'c3', name: 'Elektronik', icon: Icons.devices, color: Colors.green),
];

// ========================= PRODUCT DATA =============================
// Sudah termasuk tambahan menu baru pada setiap kategori
final List<Product> kProducts = [
  // Makanan
  Product(id: 'p1', categoryId: 'c1', name: 'Nasi Goreng', price: 12000, icon: Icons.restaurant),
  Product(id: 'p2', categoryId: 'c1', name: 'Sate Ayam', price: 15000, icon: Icons.set_meal),
  Product(id: 'p7', categoryId: 'c1', name: 'Nasi Campur', price: 13000, icon: Icons.restaurant_menu),
  Product(id: 'p8', categoryId: 'c1', name: 'Ayam Bakar', price: 20000, icon: Icons.food_bank),
  Product(id: 'p9', categoryId: 'c1', name: 'Bakso', price: 10000, icon: Icons.ramen_dining),

  // Minuman
  Product(id: 'p3', categoryId: 'c2', name: 'Es Teh', price: 5000, icon: Icons.icecream),
  Product(id: 'p4', categoryId: 'c2', name: 'Kopi Tubruk', price: 10000, icon: Icons.local_cafe),
  Product(id: 'p10', categoryId: 'c2', name: 'Jus Alpukat', price: 15000, icon: Icons.blender),
  Product(id: 'p11', categoryId: 'c2', name: 'Air Mineral', price: 3000, icon: Icons.water),

  // Elektronik
  Product(id: 'p5', categoryId: 'c3', name: 'Headphone', price: 250000, icon: Icons.headphones),
  Product(id: 'p6', categoryId: 'c3', name: 'Powerbank', price: 120000, icon: Icons.battery_charging_full),
  Product(id: 'p12', categoryId: 'c3', name: 'Mouse Wireless', price: 50000, icon: Icons.mouse),
  Product(id: 'p13', categoryId: 'c3', name: 'Keyboard', price: 80000, icon: Icons.keyboard),
];

// ========================= TRANSISI ANIMASI =============================

PageRouteBuilder slidePage(Widget page) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 300),
    pageBuilder: (_, animation, __) => FadeTransition(opacity: animation, child: page),
    transitionsBuilder: (_, animation, __, child) {
      final slide = Tween(begin: Offset(0.2, 0), end: Offset.zero)
          .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
      return SlideTransition(position: slide, child: child);
    },
  );
}

// ========================= HOME SCREEN =============================

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MyShop Mini',
                    style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Pilih Kategori',
                    style: TextStyle(color: Colors.white70, fontSize: 18)),
                SizedBox(height: 20),

                Row(
                  children: kCategories.map((cat) {
                    return Expanded(child: CategoryCard(category: cat));
                  }).toList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ========================= CATEGORY CARD =============================

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        onTap: () {
          Navigator.push(context, slidePage(ProductListScreen(category: category)));
        },
        child: Hero(
          tag: category.id,
          child: Container(
            height: 130,
            decoration: BoxDecoration(
              color: category.color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: category.color.withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, 6))
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category.icon, size: 40, color: Colors.white),
                SizedBox(height: 8),
                Text(category.name,
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ========================= PRODUCT LIST SCREEN =============================

class ProductListScreen extends StatelessWidget {
  final Category category;

  const ProductListScreen({required this.category});

  List<Product> get categoryProducts =>
      kProducts.where((p) => p.categoryId == category.id).toList();

  @override
  Widget build(BuildContext context) {
    final products = categoryProducts;

    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: category.id,
          child: Material(
            color: Colors.transparent,
            child: Text(category.name,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: category.color)),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: category.color),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (_, index) =>
              ProductCard(product: products[index], category: category),
        ),
      ),
    );
  }
}

// ========================= PRODUCT CARD =============================

class ProductCard extends StatelessWidget {
  final Product product;
  final Category category;

  const ProductCard({required this.product, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, slidePage(ProductDetailScreen(product: product, category: category)));
      },
      child: Hero(
        tag: product.id,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 5)),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(product.icon, size: 48, color: category.color),
                SizedBox(height: 12),
                Text(product.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text("Rp ${product.price.toInt()}",
                    style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ========================= PRODUCT DETAIL SCREEN =============================

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final Category category;

  const ProductDetailScreen({required this.product, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Produk', style: TextStyle(color: category.color)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: category.color),
      ),

      body: Center(
        child: Hero(
          tag: product.id,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(product.icon, size: 130, color: category.color),
              SizedBox(height: 20),
              Text(product.name,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Rp ${product.price.toInt()}",
                  style: TextStyle(fontSize: 22, color: Colors.grey[700])),
              SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
                label: Text("Kembali"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: category.color,
                  foregroundColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
