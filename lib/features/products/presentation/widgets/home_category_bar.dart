import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_icons.dart';
import '../bloc/product_bloc.dart';

class HomeCategoryBar extends StatelessWidget {
  const HomeCategoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Categories mapped to DummyJSON endpoints
    final categories = [
      {'icon': AppIcons.all, 'name': 'All', 'id': 'all'}, // Special case
      {'icon': AppIcons.smartphones, 'name': 'Mobiles', 'id': 'smartphones'},
      {'icon': AppIcons.laptops, 'name': 'Laptops', 'id': 'laptops'},
      {'icon': AppIcons.fragrances, 'name': 'Fragrances', 'id': 'fragrances'},
      {'icon': AppIcons.skincare, 'name': 'Skincare', 'id': 'skincare'},
      {'icon': AppIcons.groceries, 'name': 'Groceries', 'id': 'groceries'},
      {'icon': AppIcons.home, 'name': 'Home', 'id': 'home-decoration'},
    ];

    return Container(
      height: 90,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          
          return GestureDetector(
            onTap: () {
              final categoryId = cat['id'] as String;
              if (categoryId == 'all') {
                context.read<ProductBloc>().add(GetProductsEvent());
              } else {
                context.read<ProductBloc>().add(FilterProductsByCategoryEvent(categoryId));
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[100],
                    child: SvgPicture.asset(
                      cat['icon'] as String,
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF2874F0),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cat['name'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
