import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/products/data/datasources/product_remote_data_source.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/domain/usecases/add_product.dart';
import 'features/products/domain/usecases/delete_product.dart';
import 'features/products/domain/usecases/get_categories.dart';
import 'features/products/domain/usecases/get_product.dart';
import 'features/products/domain/usecases/get_products.dart';
import 'features/products/domain/usecases/get_products_by_category.dart';
import 'features/products/domain/usecases/search_products.dart';
import 'features/products/domain/usecases/update_product.dart';
import 'features/products/presentation/bloc/product_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Product
  // Bloc
  sl.registerFactory(
    () => ProductBloc(
      getProducts: sl(),
      searchProducts: sl(),
      getProductsByCategory: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProduct(sl()));
  sl.registerLazySingleton(() => SearchProducts(sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => GetProductsByCategory(sl()));
  sl.registerLazySingleton(() => AddProduct(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));

  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
}
