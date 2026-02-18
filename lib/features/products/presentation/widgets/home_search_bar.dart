import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        onSubmitted: (value) {
          context.read<ProductBloc>().add(SearchProductsEvent(value));
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Search for products, brands and more',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.grey, size: 24),
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
