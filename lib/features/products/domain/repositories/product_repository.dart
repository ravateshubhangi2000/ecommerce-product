import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({int limit = 0, int skip = 0});
  Future<Either<Failure, Product>> getProduct(int id);
  Future<Either<Failure, List<Product>>> searchProducts(String query);
  Future<Either<Failure, List<String>>> getCategories();
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);
  Future<Either<Failure, Product>> addProduct(Map<String, dynamic> productData);
  Future<Either<Failure, Product>> updateProduct(int id, Map<String, dynamic> productData);
  Future<Either<Failure, Product>> deleteProduct(int id);
}
