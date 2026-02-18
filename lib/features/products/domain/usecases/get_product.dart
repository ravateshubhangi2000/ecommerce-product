import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductParams extends Equatable {
  final int id;
  const GetProductParams({required this.id});
  @override
  List<Object> get props => [id];
}

class GetProduct implements UseCase<Product, GetProductParams> {
  final ProductRepository repository;

  GetProduct(this.repository);

  @override
  Future<Either<Failure, Product>> call(GetProductParams params) async {
    return await repository.getProduct(params.id);
  }
}
