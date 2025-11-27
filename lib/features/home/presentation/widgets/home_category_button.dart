import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeCategoryButton extends StatelessWidget {
  const HomeCategoryButton({super.key});

  // Internal list of buttons with icon, route, and optional color
  final List<_CategoryButtonData> _buttons = const [
    _CategoryButtonData(icon: Icons.menu_book_rounded, route: '/books'),
    _CategoryButtonData(icon: Icons.audiotrack, route: '/audio'),
    _CategoryButtonData(icon: Icons.video_collection_rounded, route: '/videos'),
    _CategoryButtonData(icon: Icons.phone_android, route: '/apps'),
    _CategoryButtonData(icon: Icons.bookmark, route: '/saved'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buttons.map((button) {
          return GestureDetector(
            onTap: () => context.go(button.route),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(button.icon, color: colors.onPrimary),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Internal helper class to hold button data
class _CategoryButtonData {
  final IconData icon;
  final String route;

  const _CategoryButtonData({required this.icon, required this.route});
}
