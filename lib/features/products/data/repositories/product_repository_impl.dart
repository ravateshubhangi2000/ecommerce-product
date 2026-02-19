import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../../../../core/network/network_info.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts({int limit = 0, int skip = 0}) async {
    // 1. Always try to get data from local source first (Industry Standard for Offline-First)
    final cachedProducts = await localDataSource.getCachedProducts();
    
    if (cachedProducts.isNotEmpty) {
      return Right(cachedProducts);
    }

    // 2. If no cache, check connectivity and fetch from remote
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getProducts(limit: limit, skip: skip);
        // 3. Cache the remote data for future offline use
        await localDataSource.cacheProducts(remoteProducts);
        return Right(remoteProducts);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      // 4. No cache and no internet
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> getProduct(int id) async {
    // 1. Try to get from cache first
    final cachedProduct = await localDataSource.getCachedProduct(id);
    if (cachedProduct != null) {
      return Right(cachedProduct);
    }

    // 2. If no cache, check connectivity and fetch from remote
    if (await networkInfo.isConnected) {
      try {
        final product = await remoteDataSource.getProduct(id);
        return Right(product);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    final cached = await localDataSource.getCachedSearchProducts(query);
    if (cached.isNotEmpty) {
      return Right(cached);
    }

    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.searchProducts(query);
        await localDataSource.cacheSearchProducts(query, products);
        return Right(products);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    final cached = await localDataSource.getCachedCategories();
    if (cached.isNotEmpty) {
      return Right(cached);
    }

    if (await networkInfo.isConnected) {
      try {
        final categories = await remoteDataSource.getCategories();
        await localDataSource.cacheCategories(categories);
        return Right(categories);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category) async {
    final cached = await localDataSource.getCachedProductsByCategory(category);
    if (cached.isNotEmpty) {
      return Right(cached);
    }

    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getProductsByCategory(category);
        await localDataSource.cacheProductsByCategory(category, products);
        return Right(products);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
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
