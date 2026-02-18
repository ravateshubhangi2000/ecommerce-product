import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy banner images (using placeholders or network images if reliable)
    // Using solid colors/text for robustness if network fails, or reliable placeholder service
    final banners = [
      'assets/images/banner1.png',
      'assets/images/banner1.png',
      'assets/images/banner1.png',
    ];

    return Container(
      // color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200.0,
          autoPlay: true,
          viewportFraction: 1.0,
          aspectRatio: 16/9,
          autoPlayInterval: const Duration(seconds: 4),
        ),
        items: banners.map((imagePath) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.blueAccent,
                    child: const Center(
                      child: Text(
                        'Sale is Live!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
