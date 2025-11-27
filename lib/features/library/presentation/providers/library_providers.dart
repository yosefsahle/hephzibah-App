import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hephzibah/features/library/data/services/library_service.dart';
import 'package:hephzibah/features/library/domain/models/category_models.dart';
import 'package:hephzibah/features/library/domain/models/library_item_model.dart';

class CategoryExpansionState {
  final Map<String, bool> expandedState;

  CategoryExpansionState(this.expandedState);

  CategoryExpansionState copyWith({Map<String, bool>? expandedState}) {
    return CategoryExpansionState(expandedState ?? this.expandedState);
  }
}

class CategoryExpansionNotifier extends StateNotifier<CategoryExpansionState> {
  CategoryExpansionNotifier() : super(CategoryExpansionState({}));

  void toggleExpansion(String categoryId) {
    final currentState = state.expandedState[categoryId] ?? false;
    state = state.copyWith(
      expandedState: {...state.expandedState, categoryId: !currentState},
    );
  }

  void clearState() {
    state = CategoryExpansionState({});
  }
}

final categoryExpansionProvider =
    StateNotifierProvider.autoDispose<
      CategoryExpansionNotifier,
      CategoryExpansionState
    >((ref) {
      return CategoryExpansionNotifier();
    });

/// Provider to fetch all top categories
final topCategoriesProvider = FutureProvider<List<LibraryCategoryModel>>((ref) {
  return LibraryService.getTopCategories();
});

/// Provider to fetch middle categories by top category ID
final middleCategoriesProvider =
    FutureProvider.family<List<LibraryCategoryModel>, String>((
      ref,
      topCategoryId,
    ) {
      // You'll need to implement getMiddleCategories in your LibraryService
      return LibraryService.getMiddleCategories(topCategoryId);
    });

/// Provider to fetch sub categories by middle category ID
final subCategoriesProvider =
    FutureProvider.family<List<LibraryCategoryModel>, String>((
      ref,
      middleCategoryId,
    ) {
      // You'll need to implement getSubCategories in your LibraryService
      return LibraryService.getSubCategories(middleCategoryId);
    });

final libraryItemsProvider = FutureProvider.autoDispose
    .family<List<LibraryItemModel>, String>((ref, subCategoryId) {
      return LibraryService.getLibraryItems(subCategoryId: subCategoryId);
    });

/// Provider for search functionality
final librarySearchProvider = FutureProvider.autoDispose
    .family<List<LibraryItemModel>, Map<String, dynamic>>((ref, params) {
      final query = params['query'] as String;
      final subCategoryId = params['subCategoryId'] as String?;

      return LibraryService.searchLibraryItems(
        query: query,
        subCategoryId: subCategoryId,
      );
    });
