import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hephzibah/core/theme/text_styles.dart';
import 'package:hephzibah/features/library/domain/models/category_models.dart';
import 'package:hephzibah/features/library/presentation/providers/library_providers.dart';
import 'package:hephzibah/features/library/presentation/widgets/search_bar.dart';
import 'package:hephzibah/core/constants/api_contants.dart';

class Library extends ConsumerStatefulWidget {
  const Library({super.key});

  @override
  ConsumerState<Library> createState() => _LibraryState();
}

class _LibraryState extends ConsumerState<Library> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearchChanged(String query) {
    print("Searching for: $query");
  }

  @override
  void initState() {
    super.initState();
    print('Base URL: ${Api().baseUrl}');
  }

  @override
  Widget build(BuildContext context) {
    final topCategoriesAsync = ref.watch(topCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Library", style: AppTextStyles.headlineSmall),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: SearchBarWidget(
            controller: _searchController,
            onChanged: _onSearchChanged,
            onSearch: () {
              print('This is Searching');
            },
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        ],
      ),
      body: topCategoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          print('Error loading categories: $error');

          // Show only favorites when there's an error
          return _buildCategoriesGrid([_createFavoriteCategory()]);
        },
        data: (categories) {
          print('Loaded ${categories.length} categories');

          // Combine API categories with favorites at the end
          final allCategories = [...categories, _createFavoriteCategory()];

          return _buildCategoriesGrid(allCategories);
        },
      ),
    );
  }

  // Helper method to create favorite category
  LibraryCategoryModel _createFavoriteCategory() {
    return LibraryCategoryModel(
      id: 'favorites',
      name: 'My Favorites',
      imageOrIcon: '',
    );
  }

  // Build the grid view for categories
  Widget _buildCategoriesGrid(List<LibraryCategoryModel> categories) {
    if (categories.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No categories found', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isFavorite = category.id == 'favorites';

        return _CategoryGridItem(category: category, isFavorite: isFavorite);
      },
    );
  }
}

class _CategoryGridItem extends StatelessWidget {
  final LibraryCategoryModel category;
  final bool isFavorite;

  const _CategoryGridItem({required this.category, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (isFavorite) {
            print('Tapped on Favorites');
            // TODO: Navigate to favorites page
          } else {
            context.push(
              '/middle-categories?topCategoryId=${category.id}&topCategoryName=${Uri.encodeComponent(category.name)}',
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Category Icon/Image
              Container(
                width: 60,
                height: 60,
                child: isFavorite
                    ? ClipRRect(
                        child: Image.asset(
                          'assets/images/icons/favorite.png',
                          fit: BoxFit.cover,
                        ),
                      )
                    : category.imageOrIcon.isNotEmpty
                    ? ClipRRect(
                        child: Image.network(
                          category.imageOrIcon,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.category, size: 30);
                          },
                        ),
                      )
                    : const Icon(Icons.category, size: 30),
              ),
              const SizedBox(height: 8),
              // Category Name
              Text(
                category.name,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
