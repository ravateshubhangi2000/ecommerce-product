import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/failures.dart';
import '../models/product_model.dart';
import '../../domain/entities/product.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({int limit = 0, int skip = 0});
  Future<ProductModel> getProduct(int id);
  Future<List<ProductModel>> searchProducts(String query);
  Future<List<String>> getCategories();
  Future<List<ProductModel>> getProductsByCategory(String category);
  Future<ProductModel> addProduct(Map<String, dynamic> productData);
  Future<ProductModel> updateProduct(int id, Map<String, dynamic> productData);
  Future<ProductModel> deleteProduct(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'https://dummyjson.com/products';

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts({int limit = 0, int skip = 0}) async {
    final String url = limit > 0 
        ? '$baseUrl?limit=$limit&skip=$skip' 
        : baseUrl;
        
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> productsJson = jsonResponse['products'];
      return productsJson.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw ServerFailure();
    }
  }

  @override
  Future<ProductModel> getProduct(int id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure();
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    final response = await client.get(
      Uri.parse('$baseUrl/search?q=$query'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> productsJson = jsonResponse['products'];
      return productsJson.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw ServerFailure();
    }
  }

  @override
  Future<List<String>> getCategories() async {
    final response = await client.get(
      Uri.parse('$baseUrl/categories'), // Note: API might have changed to return objects, assuming strings for now based on typical dummyjson
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> categoriesJson = json.decode(response.body);
      // DummyJSON sometimes returns list of strings or list of objects.
      // Current docs say: GET /products/categories -> ["smartphones", "laptops", ...] OR objects
      // Let's handle both strings and objects (if objects, extract name/slug)
      return categoriesJson.map((e) {
        if (e is String) return e;
        if (e is Map) return e['slug'] as String? ?? e['name'] as String? ?? '';
        return e.toString();
      }).toList();
    } else {
      throw ServerFailure();
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final response = await client.get(
      Uri.parse('$baseUrl/category/$category'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> productsJson = jsonResponse['products'];
      return productsJson.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw ServerFailure();
    }
  }

  @override
  Future<ProductModel> addProduct(Map<String, dynamic> productData) async {
    final response = await client.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(productData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure();
    }
  }

  @override
  Future<ProductModel> updateProduct(int id, Map<String, dynamic> productData) async {
    final response = await client.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(productData),
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure();
    }
  }

  @override
  Future<ProductModel> deleteProduct(int id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure();
    }
  }
}
