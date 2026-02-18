import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class UpdateProductParams extends Equatable {
  final int id;
  final Map<String, dynamic> productData;
  const UpdateProductParams({required this.id, required this.productData});
  @override
  List<Object> get props => [id, productData];
}

class UpdateProduct implements UseCase<Product, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  @override
  Future<Either<Failure, Product>> call(UpdateProductParams params) async {
    return await repository.updateProduct(params.id, params.productData);
  }
}
