import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/home_category_bar.dart';
import '../widgets/home_banner.dart';

import '../widgets/home_search_bar.dart';
import '../widgets/product_grid_item.dart';
import '../../../../injection_container.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductBloc>()..add(GetProductsEvent()),
      child: Scaffold(
        appBar: const HomeTopBar(),
        body: Container(
          color: Colors.grey[200],
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductLoaded) {
                if (state.products.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }
                
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 600;
                    final crossAxisCount = isDesktop ? (constraints.maxWidth / 250).floor() : 2;
                    
                    return CustomScrollView(
                      slivers: [
                        const SliverToBoxAdapter(
                          child: HomeSearchBar(),
                        ),
                        const SliverToBoxAdapter(
                          child: HomeCategoryBar(),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 8),
                        ),
                        const SliverToBoxAdapter(
                          child: HomeBanner(),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 8),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            color: Colors.white,
                            child: const Text(
                              "Recommended for You",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(4),
                          sliver: SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return ProductGridItem(product: state.products[index]);
                              },
                              childCount: state.products.length,
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 20),
                        ),
                      ],
                    );
                  },
                );
                
              } else if (state is ProductError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProductBloc>().add(GetProductsEvent());
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
