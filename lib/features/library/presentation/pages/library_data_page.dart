import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hephzibah/features/library/domain/models/library_item_model.dart';
import 'package:hephzibah/features/library/presentation/providers/library_providers.dart';
import 'package:hephzibah/features/library/presentation/widgets/library_item_card.dart';

class LibraryItemsPage extends ConsumerStatefulWidget {
  final String subCategoryId;
  final String subCategoryName;

  const LibraryItemsPage({
    super.key,
    required this.subCategoryId,
    required this.subCategoryName,
  });

  @override
  ConsumerState<LibraryItemsPage> createState() => _LibraryItemsPageState();
}

class _LibraryItemsPageState extends ConsumerState<LibraryItemsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _searchQuery = query;
        _isSearching = true;
      });
    } else {
      _clearSearch();
    }
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _isSearching = false;
      _searchController.clear();
    });
  }

  void _onSearchSubmitted(String value) {
    _performSearch();
  }

  @override
  Widget build(BuildContext context) {
    final libraryItemsAsync = _isSearching
        ? ref.watch(
            librarySearchProvider({
              'query': _searchQuery,
              'subCategoryId': widget.subCategoryId,
            }),
          )
        : ref.watch(libraryItemsProvider(widget.subCategoryId));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subCategoryName),
        automaticallyImplyLeading: true,
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearSearch,
              tooltip: 'Clear search',
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search in ${widget.subCategoryName}...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: _onSearchSubmitted,
                    onChanged: (value) {
                      setState(() {}); // Update UI to show/hide clear button
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _performSearch,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
          // Search Results Header
          if (_isSearching) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Search results for "$_searchQuery"',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: _clearSearch,
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
          // Library Items List
          Expanded(
            child: libraryItemsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) {
                print('Error loading library items: $error');
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isSearching
                            ? 'Failed to search items'
                            : 'Failed to load items',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Error: $error',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_isSearching) {
                            ref.invalidate(
                              librarySearchProvider({
                                'query': _searchQuery,
                                'subCategoryId': widget.subCategoryId,
                              }),
                            );
                          } else {
                            ref.invalidate(
                              libraryItemsProvider(widget.subCategoryId),
                            );
                          }
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              },
              data: (libraryItems) {
                if (libraryItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isSearching
                              ? Icons.search_off
                              : Icons.library_books_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isSearching
                              ? 'No results for "$_searchQuery"'
                              : 'No items found in this category',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        if (_isSearching) ...[
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: _clearSearch,
                            child: const Text('Show all items'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: libraryItems.length,
                  itemBuilder: (context, index) {
                    final item = libraryItems[index];
                    return LibraryItemCard(
                      item: item,
                      onTap: () {
                        _onItemTap(item);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTap(LibraryItemModel item) {
    print('Tapped on item: ${item.title}');
    print('Content Type: ${item.contentType}');
    print('Content File: ${item.contentFile}');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.coverImage.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(item.coverImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                item.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              _buildDetailRow('Author', item.author),
              _buildDetailRow(
                'Category',
                '${item.topCategory} → ${item.middleCategory} → ${item.subCategory}',
              ),
              _buildDetailRow('Content Type', item.contentType),
              _buildDetailRow('Age Restriction', item.ageRestriction),
              _buildDetailRow('Views', item.viewCount.toString()),
              _buildDetailRow('Downloads', item.downloadCount.toString()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              _openContent(item);
              Navigator.of(context).pop();
            },
            child: Text(item.isAudio ? 'Play' : 'Open'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _openContent(LibraryItemModel item) {
    // TODO: Implement content opening logic
    // For audio: Use audio player
    // For PDF: Use PDF viewer
    // For video: Use video player
    print('Opening content: ${item.contentFile}');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
