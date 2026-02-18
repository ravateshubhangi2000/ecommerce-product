import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SearchProductsParams extends Equatable {
  final String query;
  const SearchProductsParams({required this.query});
  @override
  List<Object> get props => [query];
}

class SearchProducts implements UseCase<List<Product>, SearchProductsParams> {
  final ProductRepository repository;

  SearchProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(SearchProductsParams params) async {
    return await repository.searchProducts(params.query);
  }
}
