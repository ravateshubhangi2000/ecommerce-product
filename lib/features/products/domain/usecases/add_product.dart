import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class AddProductParams extends Equatable {
  final Map<String, dynamic> productData;
  const AddProductParams({required this.productData});
  @override
  List<Object> get props => [productData];
}

class AddProduct implements UseCase<Product, AddProductParams> {
  final ProductRepository repository;

  AddProduct(this.repository);

  @override
  Future<Either<Failure, Product>> call(AddProductParams params) async {
    return await repository.addProduct(params.productData);
  }
}
