import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class DeleteProductParams extends Equatable {
  final int id;
  const DeleteProductParams({required this.id});
  @override
  List<Object> get props => [id];
}

class DeleteProduct implements UseCase<Product, DeleteProductParams> {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  @override
  Future<Either<Failure, Product>> call(DeleteProductParams params) async {
    return await repository.deleteProduct(params.id);
  }
}
