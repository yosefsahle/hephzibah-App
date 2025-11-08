import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> bannerImages = [
  'https://i.vimeocdn.com/video/1963077260-7216ca403654b4bef6110fa3f760bd3a3c21905a342d8078a8c35eaefa1f6775-d?f=webp',
  'https://dailyinjera.org/images/wallpaper/verses/Dailyinjera.org%20Verse%20Wallpaper%20297%20-%20PC-%20Preview.jpg',
  'https://dailyinjera.org/images/wallpaper/verses/Dailyinjera.org%20Verse%20Wallpaper%20126%20-%20PC-Preview.jpg',
  'https://dailyinjera.org/images/wallpaper/verses/Dailyinjera.org%20Verse%20Wallpaper%201025%20-%20PC%20Preview.jpg',
];

Widget buildBannerCarousel() {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: CarouselSlider.builder(
      itemCount: bannerImages.length,
      itemBuilder: (context, index, realIdx) {
        final imageUrl = bannerImages[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey.shade200,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 50),
          ),
        );
      },
      options: CarouselOptions(
        height: 150,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: true,
        viewportFraction: 1.0,
      ),
    ),
  );
}
