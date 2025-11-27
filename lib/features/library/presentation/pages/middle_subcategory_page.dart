import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hephzibah/features/library/data/services/library_service.dart';
import 'package:hephzibah/features/library/domain/models/category_models.dart';

class MiddleSubCategoriesPage extends ConsumerStatefulWidget {
  final String topCategoryId;
  final String topCategoryName;

  const MiddleSubCategoriesPage({
    super.key,
    required this.topCategoryId,
    required this.topCategoryName,
  });

  @override
  ConsumerState<MiddleSubCategoriesPage> createState() =>
      _MiddleSubCategoriesPageState();
}

class _MiddleSubCategoriesPageState
    extends ConsumerState<MiddleSubCategoriesPage> {
  late Map<String, bool> _expandedState;

  @override
  void initState() {
    super.initState();
    _expandedState = {};
    print('=== INIT MiddleSubCategoriesPage ===');
    print('TopCategoryId: ${widget.topCategoryId}');
    print('TopCategoryName: ${widget.topCategoryName}');
  }

  @override
  void didUpdateWidget(MiddleSubCategoriesPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.topCategoryId != widget.topCategoryId) {
      print('=== CATEGORY CHANGED ===');
      print('From: ${oldWidget.topCategoryId}');
      print('To: ${widget.topCategoryId}');
      setState(() {
        _expandedState.clear();
      });
    }
  }

  Future<List<LibraryCategoryModel>> _loadMiddleCategories() {
    print('Loading middle categories for: ${widget.topCategoryId}');
    return LibraryService.getMiddleCategories(widget.topCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    print('=== BUILD MiddleSubCategoriesPage ===');
    print('Current TopCategoryId: ${widget.topCategoryId}');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topCategoryName),
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<List<LibraryCategoryModel>>(
        future: _loadMiddleCategories(),
        builder: (context, snapshot) {
          print('FutureBuilder state: ${snapshot.connectionState}');
          if (snapshot.hasError) {
            print('FutureBuilder error: ${snapshot.error}');
          }
          if (snapshot.hasData) {
            print('FutureBuilder data count: ${snapshot.data!.length}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load categories',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Error: ${snapshot.error}',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final middleCategories = snapshot.data!;

          if (middleCategories.isEmpty) {
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

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: middleCategories.length,
            itemBuilder: (context, middleIndex) {
              final middleCategory = middleCategories[middleIndex];
              final isExpanded = _expandedState[middleCategory.id] ?? false;

              return _MiddleCategoryItem(
                key: ValueKey(middleCategory.id),
                middleCategory: middleCategory,
                isExpanded: isExpanded,
                onTap: () {
                  setState(() {
                    _expandedState[middleCategory.id] = !isExpanded;
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _MiddleCategoryItem extends StatefulWidget {
  final LibraryCategoryModel middleCategory;
  final bool isExpanded;
  final VoidCallback onTap;

  const _MiddleCategoryItem({
    super.key,
    required this.middleCategory,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<_MiddleCategoryItem> createState() => _MiddleCategoryItemState();
}

class _MiddleCategoryItemState extends State<_MiddleCategoryItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Middle Category Header
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.teal[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: widget.middleCategory.imageOrIcon.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.middleCategory.imageOrIcon,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.category,
                            color: Colors.teal[600],
                            size: 20,
                          );
                        },
                      ),
                    )
                  : Icon(Icons.category, color: Colors.teal[600], size: 20),
            ),
            title: Text(
              widget.middleCategory.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            trailing: Icon(
              widget.isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.grey[600],
            ),
            onTap: widget.onTap,
          ),
          // Sub Categories (if expanded)
          if (widget.isExpanded)
            FutureBuilder<List<LibraryCategoryModel>>(
              future: LibraryService.getSubCategories(widget.middleCategory.id),
              builder: (context, snapshot) {
                print(
                  'SubCategory FutureBuilder for: ${widget.middleCategory.id}',
                );
                print('SubCategory state: ${snapshot.connectionState}');

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  print('SubCategory error: ${snapshot.error}');
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error loading sub-categories',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.red),
                    ),
                  );
                }

                final subCategories = snapshot.data!;
                print('SubCategory data count: ${subCategories.length}');

                if (subCategories.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No sub-categories available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return Column(
                  children: subCategories.map((subCategory) {
                    return _SubCategoryItem(
                      key: ValueKey(subCategory.id),
                      subCategory: subCategory,
                    );
                  }).toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _SubCategoryItem extends StatelessWidget {
  final LibraryCategoryModel subCategory;

  const _SubCategoryItem({super.key, required this.subCategory});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(18),
          ),
          child: subCategory.imageOrIcon.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    subCategory.imageOrIcon,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.subtitles,
                        color: Colors.blue[600],
                        size: 18,
                      );
                    },
                  ),
                )
              : Icon(Icons.subtitles, color: Colors.blue[600], size: 18),
        ),
        title: Text(
          subCategory.name,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        onTap: () {
          // TODO: Navigate to library items for this sub-category
          context.push(
            '/library-items?subCategoryId=${subCategory.id}&subCategoryName=${Uri.encodeComponent(subCategory.name)}',
          );
          print('Tapped on sub-category: ${subCategory.name}');
        },
      ),
    );
  }
}
