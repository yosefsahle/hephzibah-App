import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hephzibah/features/groups/presentation/pages/group_list_page.dart';
import 'package:hephzibah/features/home/presentation/pages/home_screen.dart';
import 'package:hephzibah/features/home/presentation/providers/bottom_nav_provider.dart';
import 'package:hephzibah/features/library/presentation/pages/library_page.dart';
import 'package:hephzibah/features/posts/presentation/pages/post_screen.dart';
import 'package:hephzibah/features/user/presentation/pages/profile_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    PostScreen(),
    Library(),
    GroupsListPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavIndexProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: _screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: colors.primary,
        unselectedItemColor: colors.secondary,
        currentIndex: selectedIndex,
        onTap: (index) =>
            ref.read(bottomNavIndexProvider.notifier).state = index,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Posts'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
