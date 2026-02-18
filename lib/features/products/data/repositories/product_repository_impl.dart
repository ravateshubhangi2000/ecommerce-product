import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getProducts({int limit = 0, int skip = 0}) async {
    try {
      final remoteProducts = await remoteDataSource.getProducts(limit: limit, skip: skip);
      return Right(remoteProducts);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> getProduct(int id) async {
    try {
      final product = await remoteDataSource.getProduct(id);
      return Right(product);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    try {
      final products = await remoteDataSource.searchProducts(query);
      return Right(products);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category) async {
    try {
      final products = await remoteDataSource.getProductsByCategory(category);
      return Right(products);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> addProduct(Map<String, dynamic> productData) async {
    try {
      final product = await remoteDataSource.addProduct(productData);
      return Right(product);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(int id, Map<String, dynamic> productData) async {
    try {
      final product = await remoteDataSource.updateProduct(id, productData);
      return Right(product);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> deleteProduct(int id) async {
    try {
      final product = await remoteDataSource.deleteProduct(id);
      return Right(product);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
