import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/search_products.dart';
import '../../domain/usecases/get_products_by_category.dart';
import '../../../../core/usecases/usecase.dart';

// Events
abstract class ProductEvent extends Equatable {
  const ProductEvent();
}

class GetProductsEvent extends ProductEvent {
  @override
  List<Object> get props => [];
}

class SearchProductsEvent extends ProductEvent {
  final String query;
  const SearchProductsEvent(this.query);
  @override
  List<Object> get props => [query];
}

class FilterProductsByCategoryEvent extends ProductEvent {
  final String category;
  const FilterProductsByCategoryEvent(this.category);
  @override
  List<Object> get props => [category];
}

// States
abstract class ProductState extends Equatable {
  const ProductState();
  
  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;

  const ProductLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final SearchProducts searchProducts;
  final GetProductsByCategory getProductsByCategory;

  ProductBloc({
    required this.getProducts,
    required this.searchProducts,
    required this.getProductsByCategory,
  }) : super(ProductInitial()) {
    on<GetProductsEvent>(_onGetProducts);
    on<SearchProductsEvent>(_onSearchProducts);
    on<FilterProductsByCategoryEvent>(_onFilterProductsByCategory);
  }

  void _onGetProducts(GetProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final failureOrProducts = await getProducts(NoParams());
    failureOrProducts.fold(
      (failure) => emit(const ProductError('Server Failure')),
      (products) => emit(ProductLoaded(products)),
    );
  }

  void _onSearchProducts(SearchProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    if (event.query.isEmpty) {
      add(GetProductsEvent());
      return;
    }
    final failureOrProducts = await searchProducts(SearchProductsParams(query: event.query));
    failureOrProducts.fold(
      (failure) => emit(const ProductError('Server Failure')),
      (products) => emit(ProductLoaded(products)),
    );
  }

  void _onFilterProductsByCategory(FilterProductsByCategoryEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    if (event.category == 'All' || event.category == 'all') { // Handle 'All' category
      add(GetProductsEvent());
      return;
    }
    final failureOrProducts = await getProductsByCategory(GetProductsByCategoryParams(category: event.category));
    failureOrProducts.fold(
      (failure) => emit(const ProductError('Server Failure')),
      (products) => emit(ProductLoaded(products)),
    );
  }
}
