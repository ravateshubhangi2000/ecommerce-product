import 'package:hive_ce/hive_ce.dart';
import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<ProductModel?> getCachedProduct(int id);
  Future<void> cacheProducts(List<ProductModel> productsToCache);
  
  Future<List<ProductModel>> getCachedSearchProducts(String query);
  Future<void> cacheSearchProducts(String query, List<ProductModel> productsToCache);
  
  Future<List<ProductModel>> getCachedProductsByCategory(String category);
  Future<void> cacheProductsByCategory(String category, List<ProductModel> productsToCache);
  
  Future<List<String>> getCachedCategories();
  Future<void> cacheCategories(List<String> categoriesToCache);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const String productBoxName = 'products_box';
  static const String searchBoxName = 'search_box';
  static const String categoryProductsBoxName = 'category_products_box';
  static const String categoriesBoxName = 'categories_list_box';

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final box = await Hive.openBox<ProductModel>(productBoxName);
    return box.values.toList();
  }

  @override
  Future<ProductModel?> getCachedProduct(int id) async {
    final box = await Hive.openBox<ProductModel>(productBoxName);
    try {
      return box.values.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> productsToCache) async {
    final box = await Hive.openBox<ProductModel>(productBoxName);
    await box.clear();
    await box.addAll(productsToCache);
  }

  @override
  Future<List<ProductModel>> getCachedSearchProducts(String query) async {
    final box = await Hive.openBox<List<dynamic>>(searchBoxName);
    final cached = box.get(query);
    if (cached != null) {
      return cached.cast<ProductModel>();
    }
    return [];
  }

  @override
  Future<void> cacheSearchProducts(String query, List<ProductModel> productsToCache) async {
    final box = await Hive.openBox<List<dynamic>>(searchBoxName);
    await box.put(query, productsToCache);
  }

  @override
  Future<List<ProductModel>> getCachedProductsByCategory(String category) async {
    final box = await Hive.openBox<List<dynamic>>(categoryProductsBoxName);
    final cached = box.get(category);
    if (cached != null) {
      return cached.cast<ProductModel>();
    }
    return [];
  }

  @override
  Future<void> cacheProductsByCategory(String category, List<ProductModel> productsToCache) async {
    final box = await Hive.openBox<List<dynamic>>(categoryProductsBoxName);
    await box.put(category, productsToCache);
  }

  @override
  Future<List<String>> getCachedCategories() async {
    final box = await Hive.openBox<String>(categoriesBoxName);
    return box.values.toList();
  }

  @override
  Future<void> cacheCategories(List<String> categoriesToCache) async {
    final box = await Hive.openBox<String>(categoriesBoxName);
    await box.clear();
    await box.addAll(categoriesToCache);
  }
}
